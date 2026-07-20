# Dependency Matrix

## Purpose

This document locks the allowed dependency direction between framework modules.

A module may depend only on modules explicitly listed under **Allowed Dependencies**.

## Matrix

| Module | Allowed Dependencies | Forbidden Direct Dependencies |
|---|---|---|
| KnowledgeModel | None | All other framework modules |
| KnowledgeLoader | KnowledgeModel | Normalizer, Semantic, Rule, Inference, Evaluator, Result, Runtime, Engine |
| KnowledgeNormalizer | KnowledgeModel | Loader, Semantic, Rule, Inference, Evaluator, Result, Runtime, Engine |
| KnowledgeSemantic | KnowledgeModel | Loader, Rule, Inference, Evaluator, Result, Runtime, Engine |
| KnowledgeRule | KnowledgeModel, KnowledgeNormalizer | Loader, Semantic, Inference, Evaluator, Result, Runtime, Engine |
| KnowledgeInference | KnowledgeModel, KnowledgeSemantic | Loader, Normalizer, Rule, Evaluator, Result, Runtime, Engine |
| KnowledgeEvaluator | KnowledgeModel | Loader, Normalizer, Semantic, Rule, Inference, Result, Runtime, Engine |
| KnowledgeResult | KnowledgeModel | Loader, Normalizer, Semantic, Rule, Inference, Evaluator, Runtime, Engine |
| KnowledgeRuntime | KnowledgeModel, KnowledgeLoader, KnowledgeNormalizer, KnowledgeSemantic, KnowledgeRule, KnowledgeInference, KnowledgeEvaluator, KnowledgeResult | KnowledgeEngine |
| KnowledgeEngine | KnowledgeRuntime, KnowledgeResult | All lower modules except through Runtime |

## Rules

- Lower modules must never call higher modules.
- KnowledgeEngine must not duplicate Runtime processing.
- KnowledgeEvaluator receives evidence as input; it must not call Rule or Inference directly.
- KnowledgeResult receives evaluated data; it must not recalculate scores.
- KnowledgeLoader must not normalize, match, score, or evaluate.
- Circular dependencies are forbidden.
