# T001 Review Checklist

## File Scope

- [ ] Only `KnowledgeModel.bas` was added or changed.
- [ ] No `Main.bas` was created.
- [ ] No unrelated module was implemented.

## Types

- [ ] `TEvidence` matches specification.
- [ ] `TRule` matches specification.
- [ ] `TInferenceRule` matches specification.
- [ ] `TKnowledgeResult` matches specification.
- [ ] Field name `Obyek` is used.

## API

- [ ] `Initialize As Boolean`
- [ ] `Clear As Boolean`
- [ ] `IsInitialized As Boolean`
- [ ] `AddEvidence(...) As Boolean`
- [ ] `GetEvidenceList As List`
- [ ] `AddRule(...) As Boolean`
- [ ] `GetRuleList As List`
- [ ] `AddInferenceRule(...) As Boolean`
- [ ] `GetInferenceRuleList As List`
- [ ] `SetFeature(...) As Boolean`
- [ ] `GetFeature(...) As List`
- [ ] `GetFeatureMap As Map`

## Collection Safety

- [ ] All Lists and Maps initialize correctly.
- [ ] `Clear` keeps collections initialized.
- [ ] Getters never return Null.
- [ ] Getters return copies.
- [ ] Input Lists are copied before storage.

## Validation

- [ ] Invalid evidence is rejected.
- [ ] Invalid rules are rejected.
- [ ] Invalid inference rules are rejected.
- [ ] Empty feature category is rejected.
- [ ] Empty feature values are ignored.
- [ ] Exact duplicates are prevented.

## Architecture

- [ ] No file loading.
- [ ] No normalization pipeline.
- [ ] No rule evaluation.
- [ ] No inference evaluation.
- [ ] No score aggregation.
- [ ] No external integration.
- [ ] No circular dependency.

## Review Result

```text
APPROVED
```

Allowed final values:

```text
APPROVED
CHANGES REQUIRED
REJECTED
```
