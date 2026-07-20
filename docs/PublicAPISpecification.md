# Public API Specification

## General Contract

- Public Sub names are fixed by `TASKS.md`.
- Public methods must return predictable values.
- Lists and Maps returned by public methods must be initialized.
- Invalid required parameters must not be silently accepted.
- Private helper Subs may be added as needed.

---

## KnowledgeModel

```text
Initialize As Boolean
Clear As Boolean
IsInitialized As Boolean
AddEvidence(Evidence As TEvidence) As Boolean
GetEvidenceList As List
AddRule(Rule As TRule) As Boolean
GetRuleList As List
AddInferenceRule(Rule As TInferenceRule) As Boolean
GetInferenceRuleList As List
SetFeature(Category As String, Values As List) As Boolean
GetFeature(Category As String) As List
GetFeatureMap As Map
```

## KnowledgeLoader

```text
Initialize As Boolean
SetBasePath(BasePath As String) As Boolean
GetBasePath As String
LoadTextLines(FileName As String) As List
LoadDelimitedFile(FileName As String, Delimiter As String) As List
LoadSemanticFileList(FileName As String) As List
LoadAll As Boolean
GetLoadErrors As List
ClearErrors As Boolean
```

## KnowledgeNormalizer

```text
Initialize As Boolean
SetVariantMap(VariantMap As Map) As Boolean
NormalizeText(InputText As String) As String
NormalizeTokens(Tokens As List) As List
Tokenize(InputText As String) As List
JoinTokens(Tokens As List) As String
IsNegated(Tokens As List, MatchIndex As Int) As Boolean
```

## KnowledgeSemantic

```text
Initialize As Boolean
SetSemanticDictionary(SemanticDictionary As Map) As Boolean
ClearFeatures As Boolean
ExtractFeatures(Tokens As List) As Map
GetFeature(Category As String) As List
GetFeatureMap As Map
HasFeature(Category As String, Value As String) As Boolean
```

## KnowledgeRule

```text
Initialize As Boolean
SetRules(Rules As List) As Boolean
Evaluate(NormalizedText As String, Tokens As List) As List
MatchRule(Rule As TRule, NormalizedText As String, Tokens As List) As Boolean
GetEvidence As List
ClearEvidence As Boolean
```

## KnowledgeInference

```text
Initialize As Boolean
SetInferenceRules(Rules As List) As Boolean
Evaluate(FeatureMap As Map) As List
MatchFeature(FeatureMap As Map, FeatureExpression As String) As Boolean
MatchRule(FeatureMap As Map, Rule As TInferenceRule) As Boolean
GetEvidence As List
ClearEvidence As Boolean
```

## KnowledgeEvaluator

```text
Initialize As Boolean
Clear As Boolean
AddEvidenceList(EvidenceList As List) As Boolean
BuildScoreMap As Map
BuildDetailMap As Map
GetQualifiedCandidates As List
EvaluateFinal(CleanText As String, OriginalText As String) As TKnowledgeResult
```

## KnowledgeResult

```text
Initialize As Boolean
CreateResult(Status As String, Candidates As List, DetailMap As Map, ScoreMap As Map, CleanText As String, OriginalText As String) As TKnowledgeResult
CreateNAResult(CleanText As String, OriginalText As String) As TKnowledgeResult
CreateMultiResult(Candidates As List, DetailMap As Map, ScoreMap As Map, CleanText As String, OriginalText As String) As TKnowledgeResult
ToDelimitedText(Result As TKnowledgeResult) As String
ToMap(Result As TKnowledgeResult) As Map
```

## KnowledgeRuntime

```text
Initialize(BasePath As String) As Boolean
LoadKnowledge As Boolean
Process(InputText As String) As TKnowledgeResult
Reset As Boolean
IsReady As Boolean
GetLastErrors As List
```

## KnowledgeEngine

```text
Initialize(BasePath As String) As Boolean
Load As Boolean
Analyze(InputText As String) As TKnowledgeResult
Reset As Boolean
IsReady As Boolean
Version As String
```
