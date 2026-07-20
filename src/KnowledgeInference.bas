B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10.5
@EndOfDesignText@
Sub Class_Globals
    Private InferenceRuleList As List
    Private EvidenceList As List
    Private IsInitialized As Boolean
End Sub

Public Sub Initialize As Boolean
    If InferenceRuleList.IsInitialized = False Then InferenceRuleList.Initialize
    If EvidenceList.IsInitialized = False Then EvidenceList.Initialize
    InferenceRuleList.Clear
    EvidenceList.Clear
    IsInitialized = True
    Return True
End Sub

Public Sub SetInferenceRules(Rules As List) As Boolean
    EnsureInitialized
    InferenceRuleList.Clear
    If Rules.IsInitialized Then
        For Each SourceRule As TInferenceRule In Rules
            Dim StoredRule As TInferenceRule = CopyInferenceRule(SourceRule)
            If StoredRule.Intent.Length > 0 And StoredRule.FeatureList.Size > 0 Then
                InferenceRuleList.Add(StoredRule)
            End If
        Next
    End If
    ClearEvidence
    Return True
End Sub

Public Sub Evaluate(FeatureMap As Map) As Boolean
    EnsureInitialized
    ClearEvidence
    If FeatureMap.IsInitialized = False Then Return True

    For Each Rule As TInferenceRule In InferenceRuleList
        If MatchRule(FeatureMap, Rule) Then
            Dim Evidence As TEvidence
            Evidence.Initialize
            Evidence.Keyword = Rule.Intent
            Evidence.Score = CountValidFeatures(Rule.FeatureList)
            Evidence.Source = "inference"
            Evidence.Category = "inference"
            Evidence.Obyek = ""
            If Evidence.Score > 0 Then EvidenceList.Add(Evidence)
        End If
    Next
    Return True
End Sub

Public Sub MatchFeature(FeatureMap As Map, FeatureExpression As String) As Boolean
    EnsureInitialized
    If FeatureMap.IsInitialized = False Then Return False
    Dim NormalizedExpression As String = NormalizeValue(FeatureExpression)
    Dim SeparatorIndex As Int = NormalizedExpression.IndexOf("=")
    If SeparatorIndex < 1 Then Return False

    Dim Category As String = NormalizedExpression.SubString2(0, SeparatorIndex).Trim
    Dim ExpectedValue As String = NormalizedExpression.SubString(SeparatorIndex + 1).Trim
    If Category.Length = 0 Or ExpectedValue.Length = 0 Then Return False
    If FeatureMap.ContainsKey(Category) = False Then Return False

    Dim FeatureValues As List = FeatureMap.Get(Category)
    If FeatureValues.IsInitialized = False Then Return False
    For Each FeatureValue As Object In FeatureValues
        If ValueToString(FeatureValue).Trim.ToLowerCase = ExpectedValue Then Return True
    Next
    Return False
End Sub

Public Sub MatchRule(FeatureMap As Map, Rule As TInferenceRule) As Boolean
    EnsureInitialized
    If NormalizeValue(Rule.Intent).Length = 0 Then Return False
    If Rule.FeatureList.IsInitialized = False Or Rule.FeatureList.Size = 0 Then Return False

    For Each FeatureExpression As Object In Rule.FeatureList
        If MatchFeature(FeatureMap, ValueToString(FeatureExpression)) = False Then Return False
    Next
    Return True
End Sub

Public Sub GetEvidence As List
    EnsureInitialized
    Dim Result As List
    Result.Initialize
    For Each Evidence As TEvidence In EvidenceList
        Result.Add(CopyEvidence(Evidence))
    Next
    Return Result
End Sub

Public Sub ClearEvidence As Boolean
    EnsureInitialized
    EvidenceList.Clear
    Return True
End Sub

Private Sub EnsureInitialized
    If IsInitialized = False Then
        Dim InitializationSucceeded As Boolean = Initialize
        If InitializationSucceeded = False Then Log("KnowledgeInference initialization failed")
    End If
End Sub

Private Sub CopyInferenceRule(Source As TInferenceRule) As TInferenceRule
    Dim Result As TInferenceRule
    Result.Initialize
    Result.Intent = NormalizeValue(Source.Intent)
    Result.FeatureList.Initialize
    If Source.FeatureList.IsInitialized Then
        For Each SourceExpression As Object In Source.FeatureList
            Dim Expression As String = ValueToString(SourceExpression).Trim.ToLowerCase
            If Expression.Length > 0 Then Result.FeatureList.Add(Expression)
        Next
    End If
    Return Result
End Sub

Private Sub CopyEvidence(Source As TEvidence) As TEvidence
    Dim Result As TEvidence
    Result.Initialize
    Result.Keyword = Source.Keyword
    Result.Score = Source.Score
    Result.Source = Source.Source
    Result.Category = Source.Category
    Result.Obyek = Source.Obyek
    Return Result
End Sub

Private Sub CountValidFeatures(FeatureList As List) As Int
    Dim ValidCount As Int
    If FeatureList.IsInitialized = False Then Return ValidCount
    For Each FeatureExpression As Object In FeatureList
        If IsValidFeatureExpression(ValueToString(FeatureExpression)) Then ValidCount = ValidCount + 1
    Next
    Return ValidCount
End Sub

Private Sub IsValidFeatureExpression(FeatureExpression As String) As Boolean
    Dim NormalizedExpression As String = NormalizeValue(FeatureExpression)
    Dim SeparatorIndex As Int = NormalizedExpression.IndexOf("=")
    If SeparatorIndex < 1 Then Return False
    Dim Category As String = NormalizedExpression.SubString2(0, SeparatorIndex).Trim
    Dim ExpectedValue As String = NormalizedExpression.SubString(SeparatorIndex + 1).Trim
    Return Category.Length > 0 And ExpectedValue.Length > 0
End Sub

Private Sub NormalizeValue(Value As String) As String
    If Value = Null Then Return ""
    Return Value.Trim.ToLowerCase
End Sub

Private Sub ValueToString(Value As Object) As String
    If Value = Null Then Return ""
    Return Value
End Sub
