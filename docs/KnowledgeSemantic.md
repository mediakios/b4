# KnowledgeSemantic

## Categories

- obyek
- problem
- goal
- aksi
- request
- keadaan
- context

## Responsibility

Maps normalized tokens to semantic categories.

## Output

FeatureMap example:

```text
obyek    → [internet, wifi]
problem  → [mati]
keadaan  → [sudah]
aksi     → [transfer]
```

## Rules

- One token may belong to more than one category only when explicitly defined.
- Preserve deterministic order.
- Remove duplicates.
- Do not select final gate.
