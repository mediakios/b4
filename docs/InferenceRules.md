# Inference Rules

## Purpose

Maps combinations of features to candidate gates.

## Recommended Conceptual Format

```text
Intent;Feature1=Value1;Feature2=Value2
```

## Matching

- All required features must match.
- Extra features do not invalidate a rule unless exclusion is defined later.
- Rule order must not change final ranking by itself.
- Duplicate rules must be removed during load.
