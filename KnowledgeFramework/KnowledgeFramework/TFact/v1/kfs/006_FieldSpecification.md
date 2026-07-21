# TFact Field Specification

## Document Information

| Item | Value |
|------|-------|
| Document ID | KFS-TFACT-006 |
| Component | TFact |
| Version | 1.0 |
| Status | FINAL |

# Fields

| Field | Type | Required | Description |
|------|------|----------|-------------|
| ID | String | Yes | Unique identifier for the fact. |
| Category | String | Yes | Canonical fact category. |
| Value | String | Yes | Canonical value. |
| Source | String | Yes | Originating component. |
| Reference | String | Yes | Traceable reference to source knowledge. |
| Confidence | Int | Yes | Confidence score (0-100). |
| StartPosition | Int | Yes | Start index in CleanText (-1 if unknown). |
| EndPosition | Int | Yes | End index in CleanText (-1 if unknown). |
| IsNegated | Boolean | Yes | Indicates whether the fact is negated. |

# Constraints

- Category and Value must be canonical.
- Confidence range: 0..100.
- Positions refer to CleanText only.
- Unknown positions use -1.
- IsNegated must not modify Value.

# Summary

Every TFact instance must satisfy this specification.
