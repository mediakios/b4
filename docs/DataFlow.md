# Data Flow

```text
RawText
  ↓
NormalizedText
  ↓
TokenList
  ↓
FeatureMap
  ↓
KeywordEvidence + InferenceEvidence
  ↓
ScoreMap + DetailMap
  ↓
QualifiedCandidates
  ↓
StructuredResult
```

Each transformation must remain inspectable for debugging.
