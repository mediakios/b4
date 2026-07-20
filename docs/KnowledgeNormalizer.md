# KnowledgeNormalizer

## Responsibility

Transforms raw chat into canonical text and tokens.

## Pipeline

1. Lowercase.
2. Normalize whitespace.
3. Remove unsupported punctuation.
4. Apply variant dictionary.
5. Produce canonical tokens.
6. Preserve original chat separately.

## Negation

Negation checks use preceding-token distance. Default design radius: 3 tokens.

## Rules

- No gate selection.
- No scoring.
- No semantic category assignment.
