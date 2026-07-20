# KnowledgeEvaluator

## Responsibility

Combines all evidence sources.

## Inputs

- Keyword evidence.
- Semantic evidence where applicable.
- Inference evidence.

## Outputs

- Score map.
- Detail map.
- Qualified candidate list.
- Final state.

## Principles

- Precision over recall.
- NA preferred over wrong classification.
- Deterministic candidate ordering.
- Multiple precise candidates produce Multi.
