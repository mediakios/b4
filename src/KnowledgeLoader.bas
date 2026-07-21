B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10.5
@EndOfDesignText@
Sub Class_Globals
    Private BasePath As String
    Private LoadErrorList As List
End Sub

Public Sub Initialize As Boolean
    BasePath = ""
    If LoadErrorList.IsInitialized = False Then LoadErrorList.Initialize
    LoadErrorList.Clear
    Return True
End Sub

Public Sub SetBasePath(Path As String) As Boolean
    Dim TrimmedPath As String = Path.Trim
    If TrimmedPath.Length = 0 Then Return False
    BasePath = TrimmedPath
    Return True
End Sub

Public Sub GetBasePath As String
    If BasePath = Null Then Return ""
    Return BasePath
End Sub

Public Sub LoadTextLines(FileName As String) As List
    EnsureErrorList
    Dim Result As List
    Result.Initialize
    Dim TrimmedFileName As String = FileName.Trim
    If TrimmedFileName.Length = 0 Then
        AddLoadError("INVALID_FILE_NAME|")
        Return Result
    End If
    If BasePath.Trim.Length = 0 Then
        AddLoadError("BASE_PATH_NOT_SET|" & TrimmedFileName)
        Return Result
    End If
    If File.Exists(BasePath, TrimmedFileName) = False Then
        AddLoadError("FILE_NOT_FOUND|" & TrimmedFileName)
        Return Result
    End If

    Try
        Dim SourceLines As List = File.ReadList(BasePath, TrimmedFileName)
        For Each SourceLine As String In SourceLines
            Dim TrimmedLine As String = SourceLine.Trim
            If TrimmedLine.Length > 0 And TrimmedLine.StartsWith("#") = False And TrimmedLine.StartsWith("//") = False Then
                Result.Add(TrimmedLine)
            End If
        Next
    Catch
        AddLoadError("READ_FAILED|" & TrimmedFileName & "|" & LastException.Message)
        Result.Clear
    End Try
    Return Result
End Sub

Public Sub LoadDelimitedFile(FileName As String, Delimiter As String) As List
    EnsureErrorList
    Dim Result As List
    Result.Initialize
    If Delimiter.Length = 0 Then
        AddLoadError("INVALID_DELIMITER|" & FileName.Trim)
        Return Result
    End If

    Dim Lines As List = LoadTextLines(FileName)
    For Each Line As String In Lines
        Result.Add(SplitPreservingEmptyColumns(Line, Delimiter))
    Next
    Return Result
End Sub

Public Sub LoadSemanticFileList As List
    Dim Result As List
    Result.Initialize
    Dim FileNames As List = LoadTextLines("semantic_file.txt")
    For Each FileName As String In FileNames
        If Result.IndexOf(FileName) = -1 Then Result.Add(FileName)
    Next
    Return Result
End Sub

Public Sub LoadAll(Model As KnowledgeModel) As Boolean
    ClearErrors
    If Model.IsInitialized = False Then
        AddLoadError("MODEL_NOT_INITIALIZED|")
        Return False
    End If

    Dim StagedModel As KnowledgeModel
    StagedModel.Initialize

    Dim IntentRows As List = LoadDelimitedFile("intent.csv", ";")
    Dim VariantRows As List = LoadDelimitedFile("kamus_gaul.csv", ";")
    LoadTextLines("katainti.txt")
    LoadTextLines("negasi.txt")
    LoadTextLines("context_obyek.txt")
    LoadTextLines("aksi_selesai.txt")
    Dim RuleRows As List = LoadDelimitedFile("rules.txt", ";")
    Dim SemanticFiles As List = LoadSemanticFileList
    Dim InferenceRows As List = LoadDelimitedFile("Inferensi.txt", ";")
    Dim DictionaryRows As List = LoadDelimitedFile("business_dictionary.csv", ";")

    AddIntentRulesToModel(StagedModel, IntentRows, "intent.csv")
    ValidateColumnCount(VariantRows, 2, "kamus_gaul.csv")

    For Each SemanticFile As String In SemanticFiles
        Dim SemanticValues As List = LoadTextLines(SemanticFile)
        If StagedModel.SetFeature(GetFileStem(SemanticFile), SemanticValues) = False Then
            AddLoadError("INVALID_SEMANTIC_FILE|" & SemanticFile)
        End If
    Next
    AddBusinessDictionaryToModel(StagedModel, DictionaryRows, "business_dictionary.csv")

    AddRulesToModel(StagedModel, RuleRows, "rules.txt")
    AddInferenceRulesToModel(StagedModel, InferenceRows, "Inferensi.txt")
    If LoadErrorList.Size > 0 Then Return False

    Model.Clear
    For Each Rule As TRule In StagedModel.GetRuleList
        Model.AddRule(Rule)
    Next
    For Each InferenceRule As TInferenceRule In StagedModel.GetInferenceRuleList
        Model.AddInferenceRule(InferenceRule)
    Next
    Dim Features As Map = StagedModel.GetFeatureMap
    For Each Category As String In Features.Keys
        Model.SetFeature(Category, Features.Get(Category))
    Next
    Return True
End Sub

Public Sub GetLoadErrors As List
    EnsureErrorList
    Dim Result As List
    Result.Initialize
    For Each LoadError As String In LoadErrorList
        Result.Add(LoadError)
    Next
    Return Result
End Sub

Public Sub ClearErrors As Boolean
    EnsureErrorList
    LoadErrorList.Clear
    Return True
End Sub

Private Sub EnsureErrorList
    If LoadErrorList.IsInitialized = False Then LoadErrorList.Initialize
End Sub

Private Sub AddLoadError(ErrorText As String)
    EnsureErrorList
    LoadErrorList.Add(ErrorText)
End Sub

Private Sub SplitPreservingEmptyColumns(Line As String, Delimiter As String) As List
    Dim Result As List
    Result.Initialize
    Dim Sentinel As String = Chr(1)
    Dim Parts() As String = Regex.Split(EscapeRegexLiteral(Delimiter), Line & Delimiter & Sentinel)
    For Index = 0 To Parts.Length - 2
        Result.Add(Parts(Index).Trim)
    Next
    Return Result
End Sub

Private Sub GetFileStem(FileName As String) As String
    Dim DotIndex As Int = FileName.LastIndexOf(".")
    If DotIndex <= 0 Then Return FileName.Trim
    Return FileName.SubString2(0, DotIndex).Trim
End Sub

Private Sub AddRulesToModel(Model As KnowledgeModel, Rows As List, FileName As String)
    For RowIndex = 0 To Rows.Size - 1
        Dim Columns As List = Rows.Get(RowIndex)
        If Columns.Size <> 4 Then
            AddLoadError("INVALID_ROW|" & FileName & "|" & (RowIndex + 1))
        Else
            Dim Rule As TRule
            Rule.Initialize
            Rule.Keyword = Columns.Get(0)
            Rule.Intent = Columns.Get(1)
            Rule.Category = Columns.Get(2)
            Rule.Obyek = Columns.Get(3)
            If Rule.Intent.Length = 0 Or Rule.Keyword.Length = 0 Then
                AddLoadError("INVALID_ROW|" & FileName & "|" & (RowIndex + 1))
            Else If RuleExists(Model, Rule) = False Then
                Model.AddRule(Rule)
            End If
        End If
    Next
End Sub

Private Sub AddInferenceRulesToModel(Model As KnowledgeModel, Rows As List, FileName As String)
    For RowIndex = 0 To Rows.Size - 1
        Dim Columns As List = Rows.Get(RowIndex)
        If Columns.Size < 2 Then
            AddLoadError("INVALID_ROW|" & FileName & "|" & (RowIndex + 1))
        Else
            Dim Intent As String = Columns.Get(0)
            Dim Rule As TInferenceRule
            Rule.Initialize
            Rule.Intent = Intent
            Rule.FeatureList.Initialize
            For ColumnIndex = 1 To Columns.Size - 1
                Dim FeatureExpression As String = Columns.Get(ColumnIndex)
                If FeatureExpression.Length > 0 Then Rule.FeatureList.Add(FeatureExpression)
            Next
            If Rule.Intent.Length = 0 Or Rule.FeatureList.Size = 0 Then
                AddLoadError("INVALID_ROW|" & FileName & "|" & (RowIndex + 1))
            Else If InferenceRuleExists(Model, Rule) = False Then
                Model.AddInferenceRule(Rule)
            End If
        End If
    Next
End Sub

Private Sub AddIntentRulesToModel(Model As KnowledgeModel, Rows As List, FileName As String)
    For RowIndex = 0 To Rows.Size - 1
        Dim Columns As List = Rows.Get(RowIndex)
        If Columns.Size <> 2 Then
            AddLoadError("INVALID_ROW|" & FileName & "|" & (RowIndex + 1))
        Else
            Dim Intent As String = Columns.Get(0)
            Dim Keywords() As String = Regex.Split(EscapeRegexLiteral(","), Columns.Get(1))
            If Intent.Length = 0 Or Keywords.Length = 0 Then
                AddLoadError("INVALID_ROW|" & FileName & "|" & (RowIndex + 1))
            Else
                For Each Keyword As String In Keywords
                    Dim Rule As TRule
                    Rule.Initialize
                    Rule.Intent = Intent
                    Rule.Keyword = Keyword.Trim
                    If Rule.Keyword.Length = 0 Then
                        AddLoadError("INVALID_ROW|" & FileName & "|" & (RowIndex + 1))
                    Else If RuleExists(Model, Rule) = False Then
                        Model.AddRule(Rule)
                    End If
                Next
            End If
        End If
    Next
End Sub

Private Sub ValidateColumnCount(Rows As List, ExpectedCount As Int, FileName As String)
    For RowIndex = 0 To Rows.Size - 1
        Dim Columns As List = Rows.Get(RowIndex)
        If Columns.Size <> ExpectedCount Then AddLoadError("INVALID_ROW|" & FileName & "|" & (RowIndex + 1))
    Next
End Sub

Private Sub AddBusinessDictionaryToModel(Model As KnowledgeModel, Rows As List, FileName As String)
    Dim VariantOwners As Map
    VariantOwners.Initialize
    For RowIndex = 0 To Rows.Size - 1
        Dim Columns As List = Rows.Get(RowIndex)
        If Columns.Size <> 6 Then
            AddLoadError("INVALID_ROW|" & FileName & "|" & (RowIndex + 1))
        Else If IsBusinessDictionaryHeader(Columns) = False Then
            Dim Status As String = ValueToString(Columns.Get(5)).Trim.ToLowerCase
            If Status = "active" Then
                Dim Canonical As String = ValueToString(Columns.Get(0)).Trim.ToLowerCase
                Dim Category As String = ValueToString(Columns.Get(2)).Trim.ToLowerCase
                If Canonical.Length = 0 Or IsApprovedSemanticCategory(Category) = False Then
                    AddLoadError("INVALID_ROW|" & FileName & "|" & (RowIndex + 1))
                Else
                    RegisterBusinessVariant(VariantOwners, Canonical, Canonical, FileName, RowIndex + 1)
                    Dim Variants() As String = Regex.Split(EscapeRegexLiteral(","), ValueToString(Columns.Get(1)))
                    For Each VariantValue As String In Variants
                        Dim Variant As String = VariantValue.Trim.ToLowerCase
                        If Variant.Length > 0 Then RegisterBusinessVariant(VariantOwners, Variant, Canonical, FileName, RowIndex + 1)
                    Next
                    AddSemanticValue(Model, Category, Canonical)
                End If
            Else If Status <> "inactive" Then
                AddLoadError("INVALID_ROW|" & FileName & "|" & (RowIndex + 1))
            End If
        End If
    Next
End Sub

Private Sub RegisterBusinessVariant(VariantOwners As Map, Variant As String, Canonical As String, FileName As String, RowNumber As Int)
    If VariantOwners.ContainsKey(Variant) Then
        If VariantOwners.Get(Variant) <> Canonical Then AddLoadError("CONFLICTING_VARIANT|" & FileName & "|" & RowNumber & "|" & Variant)
    Else
        VariantOwners.Put(Variant, Canonical)
    End If
End Sub

Private Sub AddSemanticValue(Model As KnowledgeModel, Category As String, Canonical As String)
    Dim FeatureValues As List
    FeatureValues.Initialize
    Dim FeatureMap As Map = Model.GetFeatureMap
    If FeatureMap.ContainsKey(Category) Then
        Dim ExistingValues As List = FeatureMap.Get(Category)
        For Each ExistingValue As Object In ExistingValues
            FeatureValues.Add(ExistingValue)
        Next
    End If
    If FeatureValues.IndexOf(Canonical) = -1 Then FeatureValues.Add(Canonical)
    Model.SetFeature(Category, FeatureValues)
End Sub

Private Sub IsBusinessDictionaryHeader(Columns As List) As Boolean
    Return ValueToString(Columns.Get(0)).Trim.ToLowerCase = "canonical" And _
        ValueToString(Columns.Get(1)).Trim.ToLowerCase = "variants" And _
        ValueToString(Columns.Get(2)).Trim.ToLowerCase = "kategori" And _
        ValueToString(Columns.Get(5)).Trim.ToLowerCase = "status"
End Sub

Private Sub IsApprovedSemanticCategory(Category As String) As Boolean
    Return Category = "obyek" Or Category = "problem" Or Category = "goal" Or _
        Category = "aksi" Or Category = "request" Or Category = "keadaan" Or Category = "context"
End Sub

Private Sub ValueToString(Value As Object) As String
    If Value = Null Then Return ""
    Return Value
End Sub

Private Sub RuleExists(Model As KnowledgeModel, Candidate As TRule) As Boolean
    For Each Existing As TRule In Model.GetRuleList
        If Existing.Intent = Candidate.Intent And Existing.Keyword = Candidate.Keyword And _
            Existing.Category = Candidate.Category And Existing.Obyek = Candidate.Obyek Then Return True
    Next
    Return False
End Sub

Private Sub InferenceRuleExists(Model As KnowledgeModel, Candidate As TInferenceRule) As Boolean
    For Each Existing As TInferenceRule In Model.GetInferenceRuleList
        If Existing.Intent = Candidate.Intent And Existing.FeatureList.Size = Candidate.FeatureList.Size Then
            Dim SameRule As Boolean = True
            For Index = 0 To Existing.FeatureList.Size - 1
                If Existing.FeatureList.Get(Index) <> Candidate.FeatureList.Get(Index) Then SameRule = False
            Next
            If SameRule Then Return True
        End If
    Next
    Return False
End Sub

Private Sub EscapeRegexLiteral(Value As String) As String
    Dim Result As String
    Dim MetaCharacters As String = "\.^$|?*+()[]{}"
    For Index = 0 To Value.Length - 1
        Dim Character As String = Value.CharAt(Index)
        If MetaCharacters.Contains(Character) Then Result = Result & "\"
        Result = Result & Character
    Next
    Return Result
End Sub
