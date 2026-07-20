# KnowledgeModel

## Responsibility

Defines shared Types and runtime collections.

## Required Types

```text
TEvidence(
    Keyword As String,
    Score As Int,
    Source As String,
    Category As String,
    Obyek As String
)

TRule(
    Intent As String,
    Keyword As String,
    Category As String,
    Obyek As String
)

TInferenceRule(
    Intent As String,
    FeatureList As List
)
```

## Rules

- Types must be declared only once.
- Collections must remain initialized after Clear.
- Getter functions must never return uninitialized List or Map.
- No loading, matching, scoring, or formatting logic.
