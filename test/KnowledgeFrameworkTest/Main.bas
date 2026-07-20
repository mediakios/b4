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

        Dim BeforeLoad As KnowledgeModel.TKnowledgeResult = Engine.Analyze("wifi mati")
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

        Dim EmptyResult As KnowledgeModel.TKnowledgeResult = Engine.Analyze("")
        AssertValidEmptyResult("Analyze empty", EmptyResult)

        Dim NullResult As KnowledgeModel.TKnowledgeResult = Engine.Analyze(Null)
        AssertValidEmptyResult("Analyze Null", NullResult)
    End If

    PrintSummary
End Sub

Private Sub AssertValidEmptyResult(TestName As String, Result As KnowledgeModel.TKnowledgeResult)
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
