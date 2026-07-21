B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10.5
@EndOfDesignText@
Sub Class_Globals
    Private Model As KnowledgeModel
    Private Loader As KnowledgeLoader
    Private Normalizer As KnowledgeNormalizer
    Private Semantic As KnowledgeSemantic
    Private RuleEngine As KnowledgeRule
    Private InferenceEngine As KnowledgeInference
    Private Evaluator As KnowledgeEvaluator
    Private ResultBuilder As KnowledgeResult
    Private NegationWords As List
    Private LastErrorList As List
    Private Ready As Boolean
    Private IsInitialized As Boolean
End Sub

Public Sub Initialize As Boolean
    If LastErrorList.IsInitialized = False Then LastErrorList.Initialize
    LastErrorList.Clear
    If NegationWords.IsInitialized = False Then NegationWords.Initialize
    NegationWords.Clear
    Ready = False
    IsInitialized = False

    Dim CurrentModule As String = "KnowledgeModel"
    Try
        If Model.Initialize = False Then Return InitializationFailed("KnowledgeModel")
        CurrentModule = "KnowledgeLoader"
        If Loader.Initialize = False Then Return InitializationFailed("KnowledgeLoader")
        CurrentModule = "KnowledgeNormalizer"
        If Normalizer.Initialize = False Then Return InitializationFailed("KnowledgeNormalizer")
        CurrentModule = "KnowledgeSemantic"
        If Semantic.Initialize = False Then Return InitializationFailed("KnowledgeSemantic")
        CurrentModule = "KnowledgeRule"
        If RuleEngine.Initialize = False Then Return InitializationFailed("KnowledgeRule")
        CurrentModule = "KnowledgeInference"
        If InferenceEngine.Initialize = False Then Return InitializationFailed("KnowledgeInference")
        CurrentModule = "KnowledgeEvaluator"
        If Evaluator.Initialize = False Then Return InitializationFailed("KnowledgeEvaluator")
        CurrentModule = "KnowledgeResult"
        If ResultBuilder.Initialize = False Then Return InitializationFailed("KnowledgeResult")
    Catch
        AddError("INITIALIZE_FAILED|" & CurrentModule)
        Return False
    End Try
    IsInitialized = True
    Return True
End Sub

Public Sub LoadKnowledge(BasePath As String) As Boolean
    If EnsureInitialized = False Then Return False
    LastErrorList.Clear
    Ready = False
    If ResetInternalState = False Then Return False

    Dim KnowledgePath As String = PreserveText(BasePath)
    If Loader.SetBasePath(KnowledgePath) = False Then
        AddError("BASE_PATH_INVALID|")
        Return False
    End If
    If Loader.LoadAll(Model) = False Then
        CopyLoaderErrors
        Return False
    End If

    Dim VariantRows As List = Loader.LoadDelimitedFile("kamus_gaul.csv", ";")
    Dim BusinessDictionaryRows As List = Loader.LoadDelimitedFile("business_dictionary.csv", ";")
    Dim LoadedNegations As List = Loader.LoadTextLines("negasi.txt")
    Dim ConfigurationLoadErrors As List = Loader.GetLoadErrors
    If ConfigurationLoadErrors.Size > 0 Then
        CopyLoaderErrors
        Return False
    End If

    Dim Variants As Map = BuildVariantMap(VariantRows)
    AddBusinessVariants(Variants, BusinessDictionaryRows)
    NegationWords = CopyNormalizedList(LoadedNegations)
    If Normalizer.SetVariantMap(Variants) = False Then Return ConfigurationFailed("KnowledgeNormalizer")
    If Semantic.SetSemanticDictionary(Model.GetFeatureMap) = False Then Return ConfigurationFailed("KnowledgeSemantic")
    If RuleEngine.SetRules(Model.GetRuleList) = False Then Return ConfigurationFailed("KnowledgeRule")
    If InferenceEngine.SetInferenceRules(Model.GetInferenceRuleList) = False Then Return ConfigurationFailed("KnowledgeInference")
    If Evaluator.Clear = False Then Return ConfigurationFailed("KnowledgeEvaluator")

    LastErrorList.Clear
    Ready = True
    Return True
End Sub

Public Sub Process(ChatText As String) As TKnowledgeResult
    EnsureInitialized
    Dim OriginalText As String = PreserveText(ChatText)
    Dim CleanText As String
    If Ready = False Then
        AddError("RUNTIME_NOT_READY|")
        Return ResultBuilder.CreateNAResult("", OriginalText)
    End If

    Try
        CleanText = Normalizer.NormalizeText(OriginalText)
        Dim Tokens As List = Normalizer.Tokenize(CleanText)
        If Semantic.ClearFeatures = False Then Return CreateProcessFailure("KnowledgeSemantic", CleanText, OriginalText)
        If Semantic.ExtractFeatures(Tokens) = False Then Return CreateProcessFailure("KnowledgeSemantic", CleanText, OriginalText)
        Dim Features As Map = Semantic.GetFeatureMap
        If RuleEngine.Evaluate(Tokens, NegationWords) = False Then Return CreateProcessFailure("KnowledgeRule", CleanText, OriginalText)
        If InferenceEngine.Evaluate(Features) = False Then Return CreateProcessFailure("KnowledgeInference", CleanText, OriginalText)
        If Evaluator.Clear = False Then Return CreateProcessFailure("KnowledgeEvaluator", CleanText, OriginalText)
        If Evaluator.AddEvidenceList(RuleEngine.GetEvidence) = False Then Return CreateProcessFailure("KnowledgeEvaluator", CleanText, OriginalText)
        If Evaluator.AddEvidenceList(InferenceEngine.GetEvidence) = False Then Return CreateProcessFailure("KnowledgeEvaluator", CleanText, OriginalText)

        Dim StructuredResult As TKnowledgeResult = Evaluator.EvaluateFinal(CleanText, OriginalText)
        Return ResultBuilder.CreateResult(StructuredResult.Status, StructuredResult.Candidates, _
            StructuredResult.DetailMap, StructuredResult.ScoreMap, StructuredResult.CleanText, _
            StructuredResult.OriginalText)
    Catch
        AddError("PROCESS_EXCEPTION|" & LastException.Message)
        Return ResultBuilder.CreateNAResult(CleanText, OriginalText)
    End Try
End Sub

Public Sub Reset As Boolean
    If EnsureInitialized = False Then Return False
    Return ResetInternalState
End Sub

Public Sub IsReady As Boolean
    EnsureInitialized
    Return Ready
End Sub

Public Sub GetLastErrors As List
    EnsureInitialized
    Dim Result As List
    Result.Initialize
    For Each ErrorText As String In LastErrorList
        Result.Add(ErrorText)
    Next
    Return Result
End Sub

Private Sub EnsureInitialized As Boolean
    If IsInitialized = False Then
        Dim InitializationSucceeded As Boolean = CallSub(Me, "Initialize")
        Return InitializationSucceeded
    End If
    Return True
End Sub

Private Sub ResetInternalState As Boolean
    Ready = False
    LastErrorList.Clear
    Dim Success As Boolean = True
    If Model.Clear = False Then
        AddError("RESET_FAILED|KnowledgeModel")
        Success = False
    End If
    If Loader.ClearErrors = False Then
        AddError("RESET_FAILED|KnowledgeLoader")
        Success = False
    End If
    If Normalizer.Initialize = False Then
        AddError("RESET_FAILED|KnowledgeNormalizer")
        Success = False
    End If
    If Semantic.Initialize = False Then
        AddError("RESET_FAILED|KnowledgeSemantic")
        Success = False
    End If
    If RuleEngine.Initialize = False Then
        AddError("RESET_FAILED|KnowledgeRule")
        Success = False
    End If
    If InferenceEngine.Initialize = False Then
        AddError("RESET_FAILED|KnowledgeInference")
        Success = False
    End If
    If Evaluator.Initialize = False Then
        AddError("RESET_FAILED|KnowledgeEvaluator")
        Success = False
    End If
    If ResultBuilder.Initialize = False Then
        AddError("RESET_FAILED|KnowledgeResult")
        Success = False
    End If
    NegationWords.Clear
    Return Success
End Sub

Private Sub BuildVariantMap(Rows As List) As Map
    Dim Result As Map
    Result.Initialize
    If Rows.IsInitialized = False Then Return Result
    For Each RowValue As Object In Rows
        Dim Columns As List = RowValue
        If Columns.IsInitialized And Columns.Size >= 2 Then
            Dim Variant As String = ValueToString(Columns.Get(0)).Trim.ToLowerCase
            Dim Canonical As String = ValueToString(Columns.Get(1)).Trim.ToLowerCase
            If Variant.Length > 0 And Canonical.Length > 0 Then Result.Put(Variant, Canonical)
        End If
    Next
    Return Result
End Sub

Private Sub AddBusinessVariants(VariantMap As Map, Rows As List)
    If Rows.IsInitialized = False Then Return
    For Each RowValue As Object In Rows
        Dim Columns As List = RowValue
        If Columns.IsInitialized And Columns.Size = 6 Then
            Dim Canonical As String = ValueToString(Columns.Get(0)).Trim.ToLowerCase
            Dim Status As String = ValueToString(Columns.Get(5)).Trim.ToLowerCase
            If Status = "active" And Canonical <> "canonical" Then
                VariantMap.Put(Canonical, Canonical)
                Dim Variants() As String = Regex.Split(",", ValueToString(Columns.Get(1)))
                For Each VariantValue As String In Variants
                    Dim Variant As String = VariantValue.Trim.ToLowerCase
                    If Variant.Length > 0 Then VariantMap.Put(Variant, Canonical)
                Next
            End If
        End If
    Next
End Sub

Private Sub CopyNormalizedList(Source As List) As List
    Dim Result As List
    Result.Initialize
    If Source.IsInitialized = False Then Return Result
    For Each Item As Object In Source
        Dim NormalizedItem As String = ValueToString(Item).Trim.ToLowerCase
        If NormalizedItem.Length > 0 Then Result.Add(NormalizedItem)
    Next
    Return Result
End Sub

Private Sub CopyLoaderErrors
    For Each ErrorText As String In Loader.GetLoadErrors
        AddError(ErrorText)
    Next
End Sub

Private Sub InitializationFailed(ModuleName As String) As Boolean
    AddError("INITIALIZE_FAILED|" & ModuleName)
    Return False
End Sub

Private Sub ConfigurationFailed(ModuleName As String) As Boolean
    AddError("CONFIGURE_FAILED|" & ModuleName)
    Ready = False
    Return False
End Sub

Private Sub CreateProcessFailure(ModuleName As String, CleanText As String, OriginalText As String) As TKnowledgeResult
    AddError("PROCESS_FAILED|" & ModuleName)
    Return ResultBuilder.CreateNAResult(CleanText, OriginalText)
End Sub

Private Sub AddError(ErrorText As String)
    If LastErrorList.IsInitialized = False Then LastErrorList.Initialize
    If LastErrorList.IndexOf(ErrorText) = -1 Then LastErrorList.Add(ErrorText)
End Sub

Private Sub PreserveText(Value As String) As String
    If Value = Null Then Return ""
    Return Value
End Sub

Private Sub ValueToString(Value As Object) As String
    If Value = Null Then Return ""
    Return Value
End Sub
