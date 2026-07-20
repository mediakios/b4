# KnowledgeRule

## Responsibility

Evaluates compact keyword rules against normalized text.

## Rule Model

Uses `TRule`.

## Evidence Model

Uses `TEvidence`.

## Rules

- Respect negation.
- Preserve matched keyword details.
- Do not perform final candidate selection.
- Expansion of compact rules must happen once during loading, not during every evaluation.
