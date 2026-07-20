# Feature Contract

## Feature Model

Features are stored in a Map:

```text
category -> List of canonical values
```

## Approved Initial Categories

- obyek
- problem
- goal
- aksi
- request
- keadaan
- context

## Category Keys

Category keys must be normalized using:

```text
Trim.ToLowerCase
```

## Values

- Values must be canonical.
- Values must be trimmed.
- Empty values are rejected.
- Duplicate values in one category are removed.
- Original token order should be preserved where possible.

## Ownership

`KnowledgeSemantic` owns feature extraction.

`KnowledgeModel` may store the current FeatureMap.

Other modules may read features but must not mutate them directly.

## Missing Category

A missing category must behave as an initialized empty List.

## Clear

Clearing features removes all category values while leaving FeatureMap initialized.
