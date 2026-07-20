Sub Class_Globals
    Private EvidenceList As List
    Private Initialized As Boolean
End Sub

Public Sub Initialize As Boolean
    If EvidenceList.IsInitialized = False Then EvidenceList.Initialize
    EvidenceList.Clear
    Initialized = True
    Return True
End Sub

Public Sub Clear As Boolean
    EnsureInitialized
    EvidenceList.Clear
    Return True
End Sub

Public Sub AddEvidenceList(EvidenceItems As List) As Boolean
    EnsureInitialized
    If EvidenceItems.IsInitialized = False Then Return True

    For Each SourceEvidence As KnowledgeModel.TEvidence In EvidenceItems
        Dim StoredEvidence As KnowledgeModel.TEvidence = CopyEvidence(SourceEvidence)
        If StoredEvidence.Score > 0 And StoredEvidence.Source.Length > 0 And StoredEvidence.Keyword.Length > 0 Then
            EvidenceList.Add(StoredEvidence)
        End If
    Next
    Return True
End Sub

Public Sub BuildScoreMap As Map
    EnsureInitialized
    Dim Result As Map
    Result.Initialize
    Dim Candidates As List = CandidateOrder
    For Each Candidate As String In Candidates
        Dim TotalScore As Int
        For Each Evidence As KnowledgeModel.TEvidence In EvidenceList
            If Evidence.Source = "inference" And Evidence.Keyword = Candidate Then
                TotalScore = TotalScore + Evidence.Score
            End If
        Next
        Result.Put(Candidate, TotalScore)
    Next
    Return Result
End Sub

Public Sub BuildDetailMap As Map
    EnsureInitialized
    Dim Result As Map
    Result.Initialize
    Dim Candidates As List = CandidateOrder
    For Each Candidate As String In Candidates
        Dim Details As List
        Details.Initialize
        Result.Put(Candidate, Details)
    Next

    For Each Evidence As KnowledgeModel.TEvidence In EvidenceList
        If Evidence.Source = "inference" And Evidence.Keyword.Length > 0 Then
            Dim CandidateDetails As List = Result.Get(Evidence.Keyword)
            CandidateDetails.Add(Evidence.Source & "|" & Evidence.Keyword & "|" & Evidence.Score & "|" & _
                Evidence.Category & "|" & Evidence.Obyek)
        End If
    Next
    Return Result
End Sub

Public Sub GetQualifiedCandidates As List
    EnsureInitialized
    Dim Result As List
    Result.Initialize
    Dim Candidates As List = CandidateOrder
    If Candidates.Size = 0 Then Return Result

    Dim Scores As Map = BuildScoreMap
    Dim HighestScore As Int
    Dim HasHighestScore As Boolean
    For Each Candidate As String In Candidates
        Dim CandidateScore As Int = Scores.Get(Candidate)
        If HasHighestScore = False Or CandidateScore > HighestScore Then
            HighestScore = CandidateScore
            HasHighestScore = True
            Result.Clear
            Result.Add(Candidate)
        Else If CandidateScore = HighestScore Then
            Result.Add(Candidate)
        End If
    Next
    Return Result
End Sub

Public Sub EvaluateFinal(CleanText As String, OriginalText As String) As KnowledgeModel.TKnowledgeResult
    EnsureInitialized
    Dim Result As KnowledgeModel.TKnowledgeResult
    Result.Initialize
    Result.ScoreMap = BuildScoreMap
    Result.DetailMap = BuildDetailMap
    Result.Candidates = GetQualifiedCandidates
    Result.CandidateCount = Result.Candidates.Size
    Result.CleanText = PreserveText(CleanText)
    Result.OriginalText = PreserveText(OriginalText)

    If Result.CandidateCount = 0 Then
        Result.Status = "NA"
    Else If Result.CandidateCount = 1 Then
        Result.Status = "Presisi"
    Else
        Result.Status = "Multi"
    End If
    Return Result
End Sub

Private Sub EnsureInitialized
    If Initialized = False Then Initialize
End Sub

Private Sub CopyEvidence(Source As KnowledgeModel.TEvidence) As KnowledgeModel.TEvidence
    Dim Result As KnowledgeModel.TEvidence
    Result.Initialize
    Result.Keyword = NormalizeValue(Source.Keyword)
    Result.Score = Source.Score
    Result.Source = NormalizeValue(Source.Source)
    Result.Category = NormalizeValue(Source.Category)
    Result.Obyek = NormalizeValue(Source.Obyek)
    Return Result
End Sub

Private Sub CandidateOrder As List
    Dim Result As List
    Result.Initialize
    For Each Evidence As KnowledgeModel.TEvidence In EvidenceList
        If Evidence.Source = "inference" And Evidence.Keyword.Length > 0 And Result.IndexOf(Evidence.Keyword) = -1 Then
            Result.Add(Evidence.Keyword)
        End If
    Next
    Return Result
End Sub

Private Sub NormalizeValue(Value As String) As String
    If Value = Null Then Return ""
    Return Value.Trim.ToLowerCase
End Sub

Private Sub PreserveText(Value As String) As String
    If Value = Null Then Return ""
    Return Value
End Sub
