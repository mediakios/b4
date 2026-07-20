# Evidence Contract

## Evidence Model

Evidence uses `TEvidence`.

## Required Fields

- `Keyword`
- `Score`
- `Source`
- `Category`
- `Obyek`

## Validity

Evidence is valid when:

- Source is not empty.
- Score is greater than zero.
- Candidate association can be determined by the owning evaluation context.
- Category and Obyek are normalized when provided.

## Source Values

Recommended source values:

- `intent`
- `rule`
- `semantic`
- `inference`

Additional values require documentation.

## Duplicate Evidence

Evidence is considered duplicate when all identifying fields and candidate target are identical.

Exact duplicates should be removed before final evaluation.

Distinct evidence from different sources may coexist.

## Scoring

Evidence producers assign evidence scores.

`KnowledgeEvaluator` combines scores but must not reinterpret evidence meaning.

## Mutability

Once evidence enters final evaluation, it should be treated as read-only.
