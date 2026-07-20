B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10.5
@EndOfDesignText@
Sub Class_Globals
    Private IsInitialized As Boolean
End Sub

Public Sub Initialize As Boolean
    IsInitialized = True
    Return True
End Sub

Public Sub CreateResult(Status As String, Candidates As List, DetailMap As Map, ScoreMap As Map, CleanText As String, OriginalText As String) As TKnowledgeResult
    EnsureInitialized
    Dim Result As TKnowledgeResult
    Result.Initialize
    Result.Status = NormalizeStatus(Status)
    Result.Candidates = CopyStringList(Candidates)
    Result.CandidateCount = Result.Candidates.Size
    Result.DetailMap = CopyDetailMap(DetailMap)
    Result.ScoreMap = CopyMap(ScoreMap)
    Result.CleanText = PreserveText(CleanText)
    Result.OriginalText = PreserveText(OriginalText)
    Return Result
End Sub

Public Sub CreateNAResult(CleanText As String, OriginalText As String) As TKnowledgeResult
    Dim Candidates As List
    Candidates.Initialize
    Dim Details As Map
    Details.Initialize
    Dim Scores As Map
    Scores.Initialize
    Return CreateResult("NA", Candidates, Details, Scores, CleanText, OriginalText)
End Sub

Public Sub CreateMultiResult(Candidates As List, DetailMap As Map, ScoreMap As Map, CleanText As String, OriginalText As String) As TKnowledgeResult
    Return CreateResult("Multi", Candidates, DetailMap, ScoreMap, CleanText, OriginalText)
End Sub

Public Sub ToDelimitedText(Result As TKnowledgeResult) As String
    EnsureInitialized
    Return EscapeDelimited(Result.Status) & ";" & Result.CandidateCount & ";" & _
        SerializeCandidates(Result.Candidates) & ";" & SerializeDetailMap(Result.DetailMap) & ";" & _
        SerializeScoreMap(Result.ScoreMap) & ";" & EscapeDelimited(Result.CleanText) & ";" & _
        EscapeDelimited(Result.OriginalText)
End Sub

Public Sub ToMap(Result As TKnowledgeResult) As Map
    EnsureInitialized
    Dim Output As Map
    Output.Initialize
    Output.Put("status", PreserveText(Result.Status))
    Output.Put("candidate_count", Result.CandidateCount)
    Output.Put("candidates", CopyStringList(Result.Candidates))
    Output.Put("detail_map", CopyDetailMap(Result.DetailMap))
    Output.Put("score_map", CopyMap(Result.ScoreMap))
    Output.Put("clean_text", PreserveText(Result.CleanText))
    Output.Put("original_text", PreserveText(Result.OriginalText))
    Return Output
End Sub

Private Sub EnsureInitialized
    If IsInitialized = False Then
        Dim InitializationSucceeded As Boolean = CallSub(Me, "Initialize")
        If InitializationSucceeded = False Then Log("KnowledgeResult initialization failed")
    End If
End Sub

Private Sub CopyStringList(Source As List) As List
    Dim Result As List
    Result.Initialize
    If Source.IsInitialized = False Then Return Result
    For Each Item As Object In Source
        Result.Add(ValueToString(Item))
    Next
    Return Result
End Sub

Private Sub CopyDetailMap(Source As Map) As Map
    Dim Result As Map
    Result.Initialize
    If Source.IsInitialized = False Then Return Result
    For Each SourceKey As Object In Source.Keys
        Dim Key As String = ValueToString(SourceKey)
        Dim SourceValue As Object = Source.Get(SourceKey)
        If SourceValue Is List Then
            Dim SourceList As List = SourceValue
            Result.Put(Key, CopyStringList(SourceList))
        Else
            Result.Put(Key, SourceValue)
        End If
    Next
    Return Result
End Sub

Private Sub CopyMap(Source As Map) As Map
    Dim Result As Map
    Result.Initialize
    If Source.IsInitialized = False Then Return Result
    For Each SourceKey As Object In Source.Keys
        Result.Put(ValueToString(SourceKey), Source.Get(SourceKey))
    Next
    Return Result
End Sub

Private Sub SerializeCandidates(Candidates As List) As String
    If Candidates.IsInitialized = False Then Return ""
    Dim Parts As List
    Parts.Initialize
    For Each Candidate As Object In Candidates
        Parts.Add(EscapeDelimited(ValueToString(Candidate)))
    Next
    Return JoinStrings(Parts, ",")
End Sub

Private Sub SerializeDetailMap(Details As Map) As String
    If Details.IsInitialized = False Then Return ""
    Dim Entries As List
    Entries.Initialize
    For Each DetailKey As Object In Details.Keys
        Dim SerializedValues As String
        Dim DetailValue As Object = Details.Get(DetailKey)
        If DetailValue Is List Then
            Dim DetailList As List = DetailValue
            If DetailList.IsInitialized Then
                Dim Values As List
                Values.Initialize
                For Each DetailItem As Object In DetailList
                    Values.Add(EscapeDelimited(ValueToString(DetailItem)))
                Next
                SerializedValues = JoinStrings(Values, ",")
            End If
        Else
            SerializedValues = EscapeDelimited(ValueToString(DetailValue))
        End If
        Entries.Add(EscapeDelimited(ValueToString(DetailKey)) & "=" & SerializedValues)
    Next
    Return JoinStrings(Entries, "|")
End Sub

Private Sub SerializeScoreMap(Scores As Map) As String
    If Scores.IsInitialized = False Then Return ""
    Dim Entries As List
    Entries.Initialize
    For Each ScoreKey As Object In Scores.Keys
        Entries.Add(EscapeDelimited(ValueToString(ScoreKey)) & "=" & _
            EscapeDelimited(ValueToString(Scores.Get(ScoreKey))))
    Next
    Return JoinStrings(Entries, "|")
End Sub

Private Sub JoinStrings(Items As List, Delimiter As String) As String
    Dim Result As StringBuilder
    Result.Initialize
    For Each Item As String In Items
        If Result.Length > 0 Then Result.Append(Delimiter)
        Result.Append(Item)
    Next
    Return Result.ToString
End Sub

Private Sub EscapeDelimited(Value As String) As String
    Dim Escaped As String = PreserveText(Value)
    Escaped = Escaped.Replace("%", "%25")
    Escaped = Escaped.Replace(";", "%3B")
    Escaped = Escaped.Replace("|", "%7C")
    Escaped = Escaped.Replace(",", "%2C")
    Escaped = Escaped.Replace("=", "%3D")
    Escaped = Escaped.Replace(Chr(13), "%0D")
    Escaped = Escaped.Replace(Chr(10), "%0A")
    Return Escaped
End Sub

Private Sub NormalizeStatus(Value As String) As String
    If Value = Null Then Return ""
    Return Value.Trim
End Sub

Private Sub PreserveText(Value As String) As String
    If Value = Null Then Return ""
    Return Value
End Sub

Private Sub ValueToString(Value As Object) As String
    If Value = Null Then Return ""
    Return Value
End Sub
