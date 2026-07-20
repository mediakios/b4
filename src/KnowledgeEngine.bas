B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10.5
@EndOfDesignText@
Sub Class_Globals
    Private Runtime As KnowledgeRuntime
    Private IsInitialized As Boolean
End Sub

Public Sub Initialize As Boolean
    Try
        If Runtime.Initialize Then
            IsInitialized = True
            Return True
        End If
    Catch
        IsInitialized = False
    End Try
    IsInitialized = False
    Return False
End Sub

Public Sub Load(BasePath As String) As Boolean
    Try
        If EnsureInitialized = False Then Return False
        Return Runtime.LoadKnowledge(BasePath)
    Catch
        Return False
    End Try
End Sub

Public Sub Analyze(ChatText As String) As KnowledgeModel.TKnowledgeResult
    Try
        If EnsureInitialized = False Then Return CreateFallbackNA(ChatText)
        Return Runtime.Process(ChatText)
    Catch
        Return CreateFallbackNA(ChatText)
    End Try
End Sub

Public Sub Reset As Boolean
    Try
        If EnsureInitialized = False Then Return False
        Return Runtime.Reset
    Catch
        Return False
    End Try
End Sub

Public Sub IsReady As Boolean
    If IsInitialized = False Then Return False
    Try
        Return Runtime.IsReady
    Catch
        Return False
    End Try
End Sub

Public Sub Version As String
    Return "1.0.0"
End Sub

Private Sub EnsureInitialized As Boolean
    If IsInitialized = False Then Return Initialize
    Return True
End Sub

Private Sub CreateFallbackNA(ChatText As String) As KnowledgeModel.TKnowledgeResult
    Dim Result As KnowledgeModel.TKnowledgeResult
    Result.Initialize
    Result.Status = "NA"
    Result.CandidateCount = 0
    Result.Candidates.Initialize
    Result.DetailMap.Initialize
    Result.ScoreMap.Initialize
    Result.CleanText = ""
    If ChatText = Null Then
        Result.OriginalText = ""
    Else
        Result.OriginalText = ChatText
    End If
    Return Result
End Sub
