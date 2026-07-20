# Result Contract

## Result Model

Results use `TKnowledgeResult`.

## Required Fields

- Status
- CandidateCount
- Candidates
- DetailMap
- ScoreMap
- CleanText
- OriginalText

## Status Values

Approved initial statuses:

- `Presisi`
- `Multi`
- `Ragu`
- `NA`

## Consistency Rules

- `CandidateCount` equals `Candidates.Size`.
- NA has zero candidates.
- Presisi has exactly one qualified candidate.
- Multi has more than one qualified candidate.
- OriginalText is preserved unchanged.
- CleanText contains normalized text.

## Determinism

Candidate ordering must be deterministic.

Detail and score output must use stable ordering when converted to text.

## Immutability

After a result is returned by the framework, callers should treat it as read-only.

## Serialization

`ToDelimitedText` and `ToMap` must represent the same logical result without changing its meaning.
