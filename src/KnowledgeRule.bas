B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10.5
@EndOfDesignText@
Sub Class_Globals
    Private RuleList As List
    Private EvidenceList As List
    Private IsInitialized As Boolean
End Sub

Public Sub Initialize As Boolean
    If RuleList.IsInitialized = False Then RuleList.Initialize
    If EvidenceList.IsInitialized = False Then EvidenceList.Initialize
    RuleList.Clear
    EvidenceList.Clear
    IsInitialized = True
    Return True
End Sub

Public Sub SetRules(Rules As List) As Boolean
    EnsureInitialized
    RuleList.Clear
    If Rules.IsInitialized Then
        For Each SourceRule As KnowledgeModel.TRule In Rules
            Dim StoredRule As KnowledgeModel.TRule = CopyRule(SourceRule)
            If StoredRule.Intent.Length > 0 And StoredRule.Keyword.Length > 0 Then
                RuleList.Add(StoredRule)
            End If
        Next
    End If
    ClearEvidence
    Return True
End Sub

Public Sub Evaluate(Tokens As List, NegationWords As List) As Boolean
    EnsureInitialized
    ClearEvidence
    If Tokens.IsInitialized = False Then Return True

    For Each Rule As KnowledgeModel.TRule In RuleList
        If MatchRule(Tokens, Rule, NegationWords) Then
            Dim Evidence As KnowledgeModel.TEvidence
            Evidence.Initialize
            Evidence.Keyword = Rule.Keyword
            Evidence.Score = 1
            Evidence.Source = "rule"
            Evidence.Category = Rule.Category
            Evidence.Obyek = Rule.Obyek
            EvidenceList.Add(Evidence)
        End If
    Next
    Return True
End Sub

Public Sub MatchRule(Tokens As List, Rule As KnowledgeModel.TRule, NegationWords As List) As Boolean
    EnsureInitialized
    If Tokens.IsInitialized = False Then Return False
    Dim Intent As String = NormalizeValue(Rule.Intent)
    Dim Keyword As String = NormalizeValue(Rule.Keyword)
    If Intent.Length = 0 Or Keyword.Length = 0 Then Return False

    For TokenIndex = 0 To Tokens.Size - 1
        Dim Token As String = ValueToString(Tokens.Get(TokenIndex)).Trim.ToLowerCase
        If Token = Keyword And IsTokenNegated(Tokens, TokenIndex, NegationWords) = False Then Return True
    Next
    Return False
End Sub

Public Sub GetEvidence As List
    EnsureInitialized
    Dim Result As List
    Result.Initialize
    For Each Evidence As KnowledgeModel.TEvidence In EvidenceList
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
    If IsInitialized = False Then Initialize
End Sub

Private Sub CopyRule(Source As KnowledgeModel.TRule) As KnowledgeModel.TRule
    Dim Result As KnowledgeModel.TRule
    Result.Initialize
    Result.Intent = NormalizeValue(Source.Intent)
    Result.Keyword = NormalizeValue(Source.Keyword)
    Result.Category = NormalizeValue(Source.Category)
    Result.Obyek = NormalizeValue(Source.Obyek)
    Return Result
End Sub

Private Sub CopyEvidence(Source As KnowledgeModel.TEvidence) As KnowledgeModel.TEvidence
    Dim Result As KnowledgeModel.TEvidence
    Result.Initialize
    Result.Keyword = Source.Keyword
    Result.Score = Source.Score
    Result.Source = Source.Source
    Result.Category = Source.Category
    Result.Obyek = Source.Obyek
    Return Result
End Sub

Private Sub IsTokenNegated(Tokens As List, TokenIndex As Int, NegationWords As List) As Boolean
    If NegationWords.IsInitialized = False Or NegationWords.Size = 0 Then Return False
    Dim FirstIndex As Int = TokenIndex - 3
    If FirstIndex < 0 Then FirstIndex = 0

    For Index = TokenIndex - 1 To FirstIndex Step -1
        Dim Candidate As String = ValueToString(Tokens.Get(Index)).Trim.ToLowerCase
        For Each NegationValue As Object In NegationWords
            Dim NegationWord As String = ValueToString(NegationValue).Trim.ToLowerCase
            If NegationWord.Length > 0 And Candidate = NegationWord Then Return True
        Next
    Next
    Return False
End Sub

Private Sub NormalizeValue(Value As String) As String
    If Value = Null Then Return ""
    Return Value.Trim.ToLowerCase
End Sub

Private Sub ValueToString(Value As Object) As String
    If Value = Null Then Return ""
    Return Value
End Sub
