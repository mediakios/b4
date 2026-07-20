B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10.5
@EndOfDesignText@
Sub Class_Globals
    Type TEvidence(Keyword As String, Score As Int, Source As String, Category As String, Obyek As String)
    Type TRule(Intent As String, Keyword As String, Category As String, Obyek As String)
    Type TInferenceRule(Intent As String, FeatureList As List)
    Type TKnowledgeResult(Status As String, CandidateCount As Int, Candidates As List, DetailMap As Map, ScoreMap As Map, CleanText As String, OriginalText As String)

    Private InitializationComplete As Boolean
    Private EvidenceList As List
    Private RuleList As List
    Private InferenceRuleList As List
    Private FeatureMap As Map
End Sub

Public Sub Initialize As Boolean
    If InitializationComplete = False Then
        EvidenceList.Initialize
        RuleList.Initialize
        InferenceRuleList.Initialize
        FeatureMap.Initialize
        InitializationComplete = True
    End If
    Return True
End Sub

Public Sub Clear As Boolean
    If InitializationComplete = False Then Initialize
    EvidenceList.Clear
    RuleList.Clear
    InferenceRuleList.Clear
    FeatureMap.Clear
    Return True
End Sub

Public Sub AddEvidence(Evidence As TEvidence) As Boolean
    If InitializationComplete = False Or Evidence.Score <= 0 Then Return False

    Evidence.Keyword = Evidence.Keyword.Trim
    Evidence.Source = Evidence.Source.Trim.ToLowerCase
    Evidence.Category = Evidence.Category.Trim.ToLowerCase
    Evidence.Obyek = Evidence.Obyek.Trim
    If Evidence.Source.Length = 0 Then Return False

    For Each Existing As TEvidence In EvidenceList
        If EvidenceEquals(Existing, Evidence) Then Return False
    Next
    EvidenceList.Add(Evidence)
    Return True
End Sub

Public Sub GetEvidenceList As List
    Dim Result As List
    Result.Initialize
    If InitializationComplete = False Then Return Result
    For Each Evidence As TEvidence In EvidenceList
        Result.Add(CopyEvidence(Evidence))
    Next
    Return Result
End Sub

Public Sub AddRule(Rule As TRule) As Boolean
    If InitializationComplete = False Then Return False

    Rule.Intent = Rule.Intent.Trim
    Rule.Keyword = Rule.Keyword.Trim
    Rule.Category = Rule.Category.Trim
    Rule.Obyek = Rule.Obyek.Trim
    If Rule.Intent.Length = 0 Or Rule.Keyword.Length = 0 Then Return False

    For Each Existing As TRule In RuleList
        If RuleEquals(Existing, Rule) Then Return False
    Next
    RuleList.Add(Rule)
    Return True
End Sub

Public Sub GetRuleList As List
    Dim Result As List
    Result.Initialize
    If InitializationComplete = False Then Return Result
    For Each Rule As TRule In RuleList
        Result.Add(CopyRule(Rule))
    Next
    Return Result
End Sub

Public Sub AddInferenceRule(Rule As TInferenceRule) As Boolean
    If InitializationComplete = False Then Return False
    Rule.Intent = Rule.Intent.Trim
    If Rule.Intent.Length = 0 Or Rule.FeatureList.IsInitialized = False Or Rule.FeatureList.Size = 0 Then Return False

    Dim StoredRule As TInferenceRule
    StoredRule.Initialize
    StoredRule.Intent = Rule.Intent
    StoredRule.FeatureList = CopyList(Rule.FeatureList)
    For Each Existing As TInferenceRule In InferenceRuleList
        If InferenceRuleEquals(Existing, StoredRule) Then Return False
    Next
    InferenceRuleList.Add(StoredRule)
    Return True
End Sub

Public Sub GetInferenceRuleList As List
    Dim Result As List
    Result.Initialize
    If InitializationComplete = False Then Return Result
    For Each Rule As TInferenceRule In InferenceRuleList
        Dim RuleCopy As TInferenceRule
        RuleCopy.Initialize
        RuleCopy.Intent = Rule.Intent
        RuleCopy.FeatureList = CopyList(Rule.FeatureList)
        Result.Add(RuleCopy)
    Next
    Return Result
End Sub

Public Sub SetFeature(Category As String, Values As List) As Boolean
    If InitializationComplete = False Or Values.IsInitialized = False Then Return False
    Dim NormalizedCategory As String = Category.Trim.ToLowerCase
    If NormalizedCategory.Length = 0 Then Return False

    Dim StoredValues As List
    StoredValues.Initialize
    For Each Value As String In Values
        Dim TrimmedValue As String = Value.Trim
        If TrimmedValue.Length > 0 And StoredValues.IndexOf(TrimmedValue) = -1 Then
            StoredValues.Add(TrimmedValue)
        End If
    Next
    FeatureMap.Put(NormalizedCategory, StoredValues)
    Return True
End Sub

Public Sub GetFeature(Category As String) As List
    Dim Result As List
    Result.Initialize
    If InitializationComplete = False Then Return Result
    Dim NormalizedCategory As String = Category.Trim.ToLowerCase
    If NormalizedCategory.Length = 0 Or FeatureMap.ContainsKey(NormalizedCategory) = False Then Return Result
    Return CopyList(FeatureMap.Get(NormalizedCategory))
End Sub

Public Sub GetFeatureMap As Map
    Dim Result As Map
    Result.Initialize
    If InitializationComplete = False Then Return Result
    For Each Category As String In FeatureMap.Keys
        Result.Put(Category, CopyList(FeatureMap.Get(Category)))
    Next
    Return Result
End Sub

Private Sub EvidenceEquals(First As TEvidence, Second As TEvidence) As Boolean
    Return First.Keyword = Second.Keyword And First.Score = Second.Score And First.Source = Second.Source And _
        First.Category = Second.Category And First.Obyek = Second.Obyek
End Sub

Private Sub RuleEquals(First As TRule, Second As TRule) As Boolean
    Return First.Intent = Second.Intent And First.Keyword = Second.Keyword And _
        First.Category = Second.Category And First.Obyek = Second.Obyek
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

Private Sub CopyRule(Source As TRule) As TRule
    Dim Result As TRule
    Result.Initialize
    Result.Intent = Source.Intent
    Result.Keyword = Source.Keyword
    Result.Category = Source.Category
    Result.Obyek = Source.Obyek
    Return Result
End Sub

Private Sub InferenceRuleEquals(First As TInferenceRule, Second As TInferenceRule) As Boolean
    If First.Intent <> Second.Intent Or First.FeatureList.Size <> Second.FeatureList.Size Then Return False
    For Index = 0 To First.FeatureList.Size - 1
        If First.FeatureList.Get(Index) <> Second.FeatureList.Get(Index) Then Return False
    Next
    Return True
End Sub

Private Sub CopyList(Source As List) As List
    Dim Result As List
    Result.Initialize
    If Source.IsInitialized = False Then Return Result
    For Each Item As Object In Source
        Result.Add(Item)
    Next
    Return Result
End Sub
