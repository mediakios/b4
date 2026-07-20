Sub Class_Globals
    Private SemanticDictionary As Map
    Private FeatureMap As Map
    Private Initialized As Boolean
End Sub

Public Sub Initialize As Boolean
    If SemanticDictionary.IsInitialized = False Then SemanticDictionary.Initialize
    If FeatureMap.IsInitialized = False Then FeatureMap.Initialize
    SemanticDictionary.Clear
    PrepareEmptyFeatures
    Initialized = True
    Return True
End Sub

Public Sub SetSemanticDictionary(Dictionary As Map) As Boolean
    EnsureInitialized
    SemanticDictionary.Clear
    If Dictionary.IsInitialized Then
        For Each CategoryValue As Object In Dictionary.Keys
            Dim Category As String = ValueToString(CategoryValue).Trim.ToLowerCase
            If IsSupportedCategory(Category) Then
                Dim StoredValues As List
                If SemanticDictionary.ContainsKey(Category) Then
                    StoredValues = SemanticDictionary.Get(Category)
                Else
                    StoredValues.Initialize
                End If
                Dim SourceValues As List = Dictionary.Get(CategoryValue)
                If SourceValues.IsInitialized Then
                    For Each SourceValue As Object In SourceValues
                        Dim NormalizedValue As String = ValueToString(SourceValue).Trim.ToLowerCase
                        If NormalizedValue.Length > 0 And StoredValues.IndexOf(NormalizedValue) = -1 Then
                            StoredValues.Add(NormalizedValue)
                        End If
                    Next
                End If
                SemanticDictionary.Put(Category, StoredValues)
            End If
        Next
    End If
    ClearFeatures
    Return True
End Sub

Public Sub ClearFeatures As Boolean
    EnsureInitialized
    PrepareEmptyFeatures
    Return True
End Sub

Public Sub ExtractFeatures(Tokens As List) As Boolean
    EnsureInitialized
    ClearFeatures
    If Tokens.IsInitialized = False Then Return True

    Dim Categories As List = GetSupportedCategories
    For Each TokenValue As Object In Tokens
        Dim Token As String = ValueToString(TokenValue).Trim.ToLowerCase
        If Token.Length > 0 Then
            For Each Category As String In Categories
                If SemanticDictionary.ContainsKey(Category) Then
                    Dim DictionaryValues As List = SemanticDictionary.Get(Category)
                    If DictionaryValues.IndexOf(Token) > -1 Then
                        Dim Features As List = FeatureMap.Get(Category)
                        If Features.IndexOf(Token) = -1 Then Features.Add(Token)
                    End If
                End If
            Next
        End If
    Next
    Return True
End Sub

Public Sub GetFeature(Category As String) As List
    EnsureInitialized
    Dim Result As List
    Result.Initialize
    Dim NormalizedCategory As String = NormalizeTextValue(Category)
    If IsSupportedCategory(NormalizedCategory) = False Then Return Result

    Dim StoredFeatures As List = FeatureMap.Get(NormalizedCategory)
    For Each Feature As String In StoredFeatures
        Result.Add(Feature)
    Next
    Return Result
End Sub

Public Sub GetFeatureMap As Map
    EnsureInitialized
    Dim Result As Map
    Result.Initialize
    Dim Categories As List = GetSupportedCategories
    For Each Category As String In Categories
        Result.Put(Category, GetFeature(Category))
    Next
    Return Result
End Sub

Public Sub HasFeature(Category As String, Value As String) As Boolean
    EnsureInitialized
    Dim NormalizedCategory As String = NormalizeTextValue(Category)
    Dim NormalizedValue As String = NormalizeTextValue(Value)
    If IsSupportedCategory(NormalizedCategory) = False Or NormalizedValue.Length = 0 Then Return False
    Dim Features As List = FeatureMap.Get(NormalizedCategory)
    Return Features.IndexOf(NormalizedValue) > -1
End Sub

Private Sub EnsureInitialized
    If Initialized = False Then Initialize
End Sub

Private Sub PrepareEmptyFeatures
    FeatureMap.Clear
    Dim Categories As List = GetSupportedCategories
    For Each Category As String In Categories
        Dim Features As List
        Features.Initialize
        FeatureMap.Put(Category, Features)
    Next
End Sub

Private Sub GetSupportedCategories As List
    Dim Categories As List
    Categories.Initialize
    Categories.Add("obyek")
    Categories.Add("problem")
    Categories.Add("goal")
    Categories.Add("aksi")
    Categories.Add("request")
    Categories.Add("keadaan")
    Categories.Add("context")
    Return Categories
End Sub

Private Sub IsSupportedCategory(Category As String) As Boolean
    Dim Categories As List = GetSupportedCategories
    Return Categories.IndexOf(Category) > -1
End Sub

Private Sub NormalizeTextValue(Value As String) As String
    If Value = Null Then Return ""
    Return Value.Trim.ToLowerCase
End Sub

Private Sub ValueToString(Value As Object) As String
    If Value = Null Then Return ""
    Return Value
End Sub
