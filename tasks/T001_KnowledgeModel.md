# T001 — Implement KnowledgeModel.bas

## Status

READY FOR IMPLEMENTATION

## Objective

Implement `KnowledgeModel.bas` as the shared data-model and in-memory state module for the B4 Knowledge Framework.

This task must not implement loading, normalization, semantic extraction, rule matching, inference, evaluation, result formatting, or runtime orchestration.

## Required Module

```text
KnowledgeModel.bas
```

Do not create `Main.bas`.

## Required Shared Types

```text
Type TEvidence( _
    Keyword As String, _
    Score As Int, _
    Source As String, _
    Category As String, _
    Obyek As String _
)

Type TRule( _
    Intent As String, _
    Keyword As String, _
    Category As String, _
    Obyek As String _
)

Type TInferenceRule( _
    Intent As String, _
    FeatureList As List _
)

Type TKnowledgeResult( _
    Status As String, _
    CandidateCount As Int, _
    Candidates As List, _
    DetailMap As Map, _
    ScoreMap As Map, _
    CleanText As String, _
    OriginalText As String _
)
```

Use `Obyek`, never `Object`.

## Required Public API

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

## Required State

The module must own:

- initialized flag,
- EvidenceList,
- RuleList,
- InferenceRuleList,
- FeatureMap.

## Behavioral Contract

### Initialize

- Initializes every List and Map.
- May be called repeatedly.
- Must not create duplicate state.
- Returns `True` when successful.

### Clear

- Clears evidence, rules, inference rules, and features.
- Leaves every collection initialized.
- Keeps the module usable.
- Returns `True`.

### AddEvidence

Reject when:

- module is not initialized,
- `Score <= 0`,
- `Source` is empty.

Normalize:

- trim string fields,
- lowercase `Source` and `Category`,
- preserve `Keyword` and `Obyek` as trimmed canonical values.

Exact duplicate evidence must not be added twice.

### AddRule

Reject when:

- module is not initialized,
- `Intent` is empty,
- `Keyword` is empty.

Trim all string fields.

Exact duplicate rules must not be added twice.

### AddInferenceRule

Reject when:

- module is not initialized,
- `Intent` is empty,
- `FeatureList` is uninitialized or empty.

Store an independent initialized copy of `FeatureList`.

Exact duplicate inference rules must not be added twice.

### SetFeature

- Normalize category using `Trim.ToLowerCase`.
- Reject empty category.
- Accept an initialized List.
- Trim values.
- Ignore empty values.
- Remove duplicates.
- Preserve original order.
- Store an independent List copy.

### GetFeature

- Never return Null.
- Missing category returns an initialized empty List.
- Return a copy so callers cannot mutate internal state.

### Public Collection Getters

`GetEvidenceList`, `GetRuleList`, `GetInferenceRuleList`, and `GetFeatureMap` must return initialized copies rather than direct mutable internal references.

## Forbidden Behavior

- No file access.
- No logging to UI.
- No database access.
- No WhatsApp, OLT, or MikroTik logic.
- No scoring aggregation.
- No rule evaluation.
- No inference evaluation.
- No external libraries.
- No architecture changes.
- No additional public APIs unless explicitly approved.

## Acceptance Criteria

T001 is accepted only when:

1. `KnowledgeModel.bas` exists.
2. All four shared Types exist exactly as specified.
3. Every required public Sub exists with the specified return type.
4. Every collection is initialized after `Initialize`.
5. `Clear` leaves collections initialized.
6. Getters never return Null.
7. Getters do not expose mutable internal collections.
8. Duplicate evidence, rules, inference rules, and feature values are prevented.
9. Required validation is implemented.
10. No forbidden dependency or integration exists.
11. Code is valid B4J syntax.
12. No unrelated files are changed.
