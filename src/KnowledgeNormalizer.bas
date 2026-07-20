B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10.5
@EndOfDesignText@
Sub Class_Globals
    Private VariantMap As Map
    Private NegationRadius As Int
    Private IsInitialized As Boolean
End Sub

Public Sub Initialize As Boolean
    If VariantMap.IsInitialized = False Then VariantMap.Initialize
    VariantMap.Clear
    NegationRadius = 3
    IsInitialized = True
    Return True
End Sub

Public Sub SetVariantMap(Variants As Map) As Boolean
    EnsureInitialized
    VariantMap.Clear
    If Variants.IsInitialized = False Then Return True

    For Each VariantKey As Object In Variants.Keys
        Dim KeyText As String = ValueToString(VariantKey).Trim.ToLowerCase
        Dim ValueText As String = ValueToString(Variants.Get(VariantKey)).Trim.ToLowerCase
        If KeyText.Length > 0 And ValueText.Length > 0 Then VariantMap.Put(KeyText, ValueText)
    Next
    Return True
End Sub

Public Sub NormalizeText(Text As String) As String
    EnsureInitialized
    Dim SourceText As String
    If Text = Null Then
        SourceText = ""
    Else
        SourceText = Text.ToLowerCase.Trim
    End If
    Return JoinTokens(NormalizeTokens(Tokenize(SourceText)))
End Sub

Public Sub NormalizeTokens(Tokens As List) As List
    EnsureInitialized
    Dim Result As List
    Result.Initialize
    If Tokens.IsInitialized = False Then Return Result

    For Each TokenValue As Object In Tokens
        Dim NormalizedToken As String = ValueToString(TokenValue).Trim.ToLowerCase
        If NormalizedToken.Length > 0 Then
            If VariantMap.ContainsKey(NormalizedToken) Then
                NormalizedToken = ValueToString(VariantMap.Get(NormalizedToken)).Trim.ToLowerCase
            End If
            If NormalizedToken.Length > 0 Then Result.Add(NormalizedToken)
        End If
    Next
    Return Result
End Sub

Public Sub Tokenize(Text As String) As List
    EnsureInitialized
    Dim Result As List
    Result.Initialize
    If Text = Null Then Return Result

    Dim SeparatedText As String = NormalizeSeparators(Text.ToLowerCase.Trim).Trim
    If SeparatedText.Length = 0 Then Return Result
    Dim Parts() As String = Regex.Split(" +", SeparatedText)
    For Each Part As String In Parts
        Dim Token As String = Part.Trim
        If Token.Length > 0 Then Result.Add(Token)
    Next
    Return Result
End Sub

Public Sub JoinTokens(Tokens As List) As String
    If Tokens.IsInitialized = False Then Return ""
    Dim Result As StringBuilder
    Result.Initialize
    For Each TokenValue As Object In Tokens
        Dim Token As String = ValueToString(TokenValue).Trim
        If Token.Length > 0 Then
            If Result.Length > 0 Then Result.Append(" ")
            Result.Append(Token)
        End If
    Next
    Return Result.ToString
End Sub

Public Sub IsNegated(Tokens As List, TokenIndex As Int, NegationWords As List) As Boolean
    EnsureInitialized
    If Tokens.IsInitialized = False Or NegationWords.IsInitialized = False Then Return False
    If TokenIndex < 0 Or TokenIndex >= Tokens.Size Or NegationWords.Size = 0 Then Return False

    Dim FirstIndex As Int = TokenIndex - NegationRadius
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

Private Sub EnsureInitialized
    If IsInitialized = False Then Initialize
End Sub

Private Sub NormalizeSeparators(Text As String) As String
    Return Regex.Replace("[^\p{L}\p{N}]+", Text, " ")
End Sub

Private Sub ValueToString(Value As Object) As String
    If Value = Null Then Return ""
    Return Value
End Sub
