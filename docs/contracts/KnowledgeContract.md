# Knowledge Contract

## Source of Truth

Knowledge files are the source of truth for vocabulary, rules, semantic values, and inference rules.

Business knowledge must not be hard-coded in B4J modules.

## Loading

Knowledge is loaded once during runtime initialization unless an explicit reload is requested.

## Validation

Loading must validate:

- required file existence,
- row structure,
- supported category names,
- duplicate canonical entries,
- malformed rule expressions.

## Expansion

Compact rules may be expanded during loading.

Expansion must happen once and must not repeat during every analysis.

## Immutability During Analysis

Loaded knowledge collections must be treated as read-only while processing input.

## Reload

Reload must:

- clear previous loaded knowledge,
- load the new state,
- validate completeness,
- update readiness only after successful validation.

## Partial Failure

Required knowledge failure makes runtime not ready.

Optional file failure may be reported without blocking readiness only when explicitly documented.
