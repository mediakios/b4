# Type Specification

## Purpose

This document defines the approved shared B4J Types.

All shared Types belong in `KnowledgeModel.bas` unless an explicitly approved central Types module is introduced later.

## TEvidence

```text
Type TEvidence( _
    Keyword As String, _
    Score As Int, _
    Source As String, _
    Category As String, _
    Obyek As String _
)
```

### Field Meaning

- `Keyword`: matched canonical token, phrase, or inference description.
- `Score`: evidence score.
- `Source`: origin such as keyword, rule, semantic, or inference.
- `Category`: semantic or rule category.
- `Obyek`: matched entity or service.

## TRule

```text
Type TRule( _
    Intent As String, _
    Keyword As String, _
    Category As String, _
    Obyek As String _
)
```

### Field Meaning

- `Intent`: candidate gate produced by the rule.
- `Keyword`: canonical keyword or phrase.
- `Category`: rule category.
- `Obyek`: required or associated object.

## TInferenceRule

```text
Type TInferenceRule( _
    Intent As String, _
    FeatureList As List _
)
```

### Field Meaning

- `Intent`: candidate gate produced when all required features match.
- `FeatureList`: ordered List of required feature expressions.

## TKnowledgeResult

```text
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

## Type Rules

- Use `Obyek`, never `Object`.
- Lists and Maps inside Types must be initialized before use.
- Shared Types must not be duplicated across modules.
- Field names are part of the public architecture and must not be renamed casually.
- New shared Types require an architecture update before implementation.
