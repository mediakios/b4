# Documentation Consistency Matrix

## Purpose

Use this checklist before starting T001.

| Check | Expected Result | Status |
|---|---|---|
| Ten module names are identical across all documents | Exact match | Pending |
| `KnowledgeModel.bas` is the first implementation module | Confirmed | Pending |
| Shared Types are defined in one place | `KnowledgeModel.bas` | Pending |
| `TEvidence` fields match the architecture | Keyword, Score, Source, Category, Obyek | Pending |
| `TRule` fields match the architecture | Intent, Keyword, Category, Obyek | Pending |
| `TInferenceRule` fields match the architecture | Intent, FeatureList | Pending |
| Public API names match `TASKS.md` | Exact match | Pending |
| Dependency Matrix has no circular dependency | None found | Pending |
| Loader does not evaluate | Confirmed | Pending |
| Evaluator does not load knowledge | Confirmed | Pending |
| Result does not calculate scores | Confirmed | Pending |
| Runtime does not contain external integrations | Confirmed | Pending |
| Engine delegates to Runtime | Confirmed | Pending |
| Collections never return Null | Confirmed | Pending |
| NA behavior is defined | Confirmed | Pending |
| Rule expansion occurs once | Confirmed | Pending |
| `Object` is not used as the domain field name | Use `Obyek` | Pending |

## Review Outcome

Review status:

```text
NOT REVIEWED
```

Change to:

```text
APPROVED FOR T001
```

only after every required row has been checked.
