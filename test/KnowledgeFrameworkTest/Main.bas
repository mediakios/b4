B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=10.5
@EndOfDesignText@
#Region Project Attributes
    #CommandLineArgs:
    #MergeLibraries: True
#End Region

Sub Process_Globals
    Private PassedCount As Int
    Private FailedCount As Int
End Sub

Sub AppStart (Args() As String)
    Dim Engine As KnowledgeEngine
    Dim InitializationSucceeded As Boolean = Engine.Initialize
    AssertTrue("Initialize", InitializationSucceeded)

    If InitializationSucceeded Then
        AssertEquals("Version", "1.0.0", Engine.Version)
        AssertTrue("Initial ready state", Engine.IsReady = False)

        Dim BeforeLoad As TKnowledgeResult = Engine.Analyze("wifi mati")
        AssertEquals("Analyze before Load status", "NA", BeforeLoad.Status)
        AssertEquals("Analyze before Load candidate count", 0, BeforeLoad.CandidateCount)
        AssertTrue("Analyze before Load candidates", IsEmptyList(BeforeLoad.Candidates))
        AssertTrue("Analyze before Load detail map", IsEmptyMap(BeforeLoad.DetailMap))
        AssertTrue("Analyze before Load score map", IsEmptyMap(BeforeLoad.ScoreMap))
        AssertEquals("Analyze before Load original text", "wifi mati", BeforeLoad.OriginalText)

        Dim InvalidPath As String = File.Combine(File.DirApp, "missing_knowledge_pack_for_t011")
        AssertTrue("Invalid Load", Engine.Load(InvalidPath) = False)
        AssertTrue("Ready after invalid Load", Engine.IsReady = False)

        AssertTrue("Reset", Engine.Reset)
        AssertTrue("Ready after Reset", Engine.IsReady = False)

        Dim EmptyResult As TKnowledgeResult = Engine.Analyze("")
        AssertValidEmptyResult("Analyze empty", EmptyResult)

        Dim NullResult As TKnowledgeResult = Engine.Analyze(Null)
        AssertValidEmptyResult("Analyze Null", NullResult)

        Dim KnowledgePath As String = ResolveKnowledgePath
        AssertTrue("Valid Load", Engine.Load(KnowledgePath))
        AssertTrue("Ready after valid Load", Engine.IsReady)

        Dim KeywordResult As TKnowledgeResult = Engine.Analyze("HALO!!!")
        AssertCandidateResult("Keyword candidate", KeywordResult, "halo", 1)
        AssertEquals("Keyword clean text", "halo", KeywordResult.CleanText)
        AssertEquals("Keyword original text", "HALO!!!", KeywordResult.OriginalText)
        AssertResultMaps("Keyword maps", KeywordResult, "halo", 1, _
            "inference|halo|1|inference|")

        Dim InferenceResult As TKnowledgeResult = Engine.Analyze("Tolong CARI bola.")
        AssertCandidateResult("Inference candidate", InferenceResult, "temukan_bola", 2)
        AssertEquals("Inference clean text", "tolong cari bola", InferenceResult.CleanText)
        AssertEquals("Inference original text", "Tolong CARI bola.", InferenceResult.OriginalText)
        AssertResultMaps("Inference maps", InferenceResult, "temukan_bola", 2, _
            "inference|temukan_bola|2|inference|")

        Dim UnmatchedResult As TKnowledgeResult = Engine.Analyze("Teks asing?")
        AssertEquals("Unmatched status", "NA", UnmatchedResult.Status)
        AssertEquals("Unmatched candidate count", 0, UnmatchedResult.CandidateCount)
        AssertTrue("Unmatched candidates", IsEmptyList(UnmatchedResult.Candidates))
        AssertTrue("Unmatched score map", IsEmptyMap(UnmatchedResult.ScoreMap))
        AssertTrue("Unmatched detail map", IsEmptyMap(UnmatchedResult.DetailMap))
        AssertEquals("Unmatched clean text", "teks asing", UnmatchedResult.CleanText)
        AssertEquals("Unmatched original text", "Teks asing?", UnmatchedResult.OriginalText)

        AssertTrue("Reset after valid Load", Engine.Reset)
        AssertTrue("Ready after successful Load Reset", Engine.IsReady = False)
    End If

    PrintSummary
End Sub

Private Sub ResolveKnowledgePath As String
    Dim ProjectKnowledgePath As String = File.Combine(File.DirApp, "knowledge")
    If File.Exists(ProjectKnowledgePath, "semantic_file.txt") Then Return ProjectKnowledgePath
    Return File.Combine(File.DirApp, "../knowledge")
End Sub

Private Sub AssertCandidateResult(TestName As String, Result As TKnowledgeResult, ExpectedCandidate As String, ExpectedScore As Int)
    Dim IsValid As Boolean = Result.Status = "Presisi" And Result.CandidateCount = 1
    If IsValid Then IsValid = Result.Candidates.IsInitialized And Result.Candidates.Size = 1
    If IsValid Then IsValid = Result.Candidates.Get(0) = ExpectedCandidate
    If IsValid Then IsValid = Result.ScoreMap.IsInitialized And Result.ScoreMap.ContainsKey(ExpectedCandidate)
    If IsValid Then IsValid = Result.ScoreMap.Get(ExpectedCandidate) = ExpectedScore
    AssertTrue(TestName, IsValid)
End Sub

Private Sub AssertResultMaps(TestName As String, Result As TKnowledgeResult, Candidate As String, ExpectedScore As Int, ExpectedDetail As String)
    Dim IsValid As Boolean = Result.ScoreMap.IsInitialized And Result.ScoreMap.Size = 1
    If IsValid Then IsValid = Result.ScoreMap.ContainsKey(Candidate)
    If IsValid Then IsValid = Result.ScoreMap.Get(Candidate) = ExpectedScore
    If IsValid Then IsValid = Result.DetailMap.IsInitialized And Result.DetailMap.Size = 1
    If IsValid Then IsValid = Result.DetailMap.ContainsKey(Candidate)
    If IsValid Then
        Dim Details As List = Result.DetailMap.Get(Candidate)
        IsValid = Details.IsInitialized And Details.Size = 1
        If IsValid Then IsValid = Details.Get(0) = ExpectedDetail
    End If
    AssertTrue(TestName, IsValid)
End Sub

Private Sub AssertValidEmptyResult(TestName As String, Result As TKnowledgeResult)
    Dim IsValid As Boolean = Result.Status = "NA" And Result.CandidateCount = 0 And Result.OriginalText = ""
    If IsValid Then IsValid = IsEmptyList(Result.Candidates)
    If IsValid Then IsValid = IsEmptyMap(Result.DetailMap)
    If IsValid Then IsValid = IsEmptyMap(Result.ScoreMap)
    AssertTrue(TestName, IsValid)
End Sub

Private Sub IsEmptyList(Value As List) As Boolean
    If Value.IsInitialized = False Then Return False
    Return Value.Size = 0
End Sub

Private Sub IsEmptyMap(Value As Map) As Boolean
    If Value.IsInitialized = False Then Return False
    Return Value.Size = 0
End Sub

Private Sub AssertTrue(TestName As String, Condition As Boolean)
    If Condition Then
        RecordPass(TestName)
    Else
        RecordFail(TestName, "condition was False")
    End If
End Sub

Private Sub AssertEquals(TestName As String, Expected As Object, Actual As Object)
    If Expected = Actual Then
        RecordPass(TestName)
    Else
        RecordFail(TestName, "expected=" & Expected & ", actual=" & Actual)
    End If
End Sub

Private Sub RecordPass(TestName As String)
    PassedCount = PassedCount + 1
    Log("PASS | " & TestName)
End Sub

Private Sub RecordFail(TestName As String, Detail As String)
    FailedCount = FailedCount + 1
    Log("FAIL | " & TestName & " | " & Detail)
End Sub

Private Sub PrintSummary
    Log("TOTAL: " & (PassedCount + FailedCount))
    Log("PASSED: " & PassedCount)
    Log("FAILED: " & FailedCount)
End Sub
