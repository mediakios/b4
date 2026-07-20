# Architecture Lock

## Status

Version: 1.0  
State: Proposed for approval

## Locked Decisions

1. The framework consists of ten core modules.
2. Knowledge remains outside source code.
3. Keyword and semantic/inference paths remain separate until evaluation.
4. `KnowledgeEvaluator` combines evidence.
5. `KnowledgeResult` formats results but does not score.
6. `KnowledgeRuntime` coordinates the pipeline.
7. `KnowledgeEngine` is the only intended host-facing entry point.
8. Precision is preferred over recall.
9. NA is a valid result.
10. Shared fields use `Obyek`, not `Object`.
11. Rules are expanded only once during loading.
12. No direct integration with WhatsApp, SQLite, OLT, or MikroTik exists in the core framework.

## Change Procedure

Any change to a locked decision must include:

- reason,
- affected modules,
- compatibility impact,
- TASKS.md update,
- documentation update.

Codex must not change locked architecture on its own.
