# Architecture

## Core Pipeline

```text
Raw Input
  ↓
KnowledgeNormalizer
  ↓
KnowledgeSemantic
  ↓
KnowledgeRule
  ↓
KnowledgeInference
  ↓
KnowledgeEvaluator
  ↓
KnowledgeResult
  ↓
KnowledgeRuntime
  ↓
KnowledgeEngine
```

## Design Principles

- Precision over recall.
- Knowledge outside source code.
- Clear module boundaries.
- Deterministic results.
- Predictable error handling.
- No hidden fallback behavior.
- Runtime state separated from knowledge files.

## Parallel Analysis Paths

The framework supports two analysis paths:

1. Keyword path
2. Semantic and inference path

Both produce evidence. Evidence is combined only in `KnowledgeEvaluator`.

## Result States

Recommended result states:

- `Presisi`
- `Multi`
- `Ragu`
- `NA`

## Dependency Direction

Lower-level modules must not depend on higher-level modules.

```text
KnowledgeModel
↑
KnowledgeLoader
↑
KnowledgeNormalizer
↑
KnowledgeSemantic / KnowledgeRule / KnowledgeInference
↑
KnowledgeEvaluator
↑
KnowledgeResult
↑
KnowledgeRuntime
↑
KnowledgeEngine
```
