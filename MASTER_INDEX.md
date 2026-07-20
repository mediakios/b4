# B4 Knowledge Framework — Master Index

## Purpose

This document is the primary navigation index for the B4 Knowledge Framework repository.

It does not replace architecture, specification, contract, or task documents. Its role is to define:

- the order in which documentation should be read,
- which document is authoritative for each topic,
- the current document status,
- the implementation sequence,
- the change-control path.

---

## Source-of-Truth Priority

When documents appear inconsistent, use the following priority:

1. `AGENTS.md`
2. `ARCHITECTURE.md`
3. `docs/ArchitectureLock.md`
4. `docs/DependencyMatrix.md`
5. `docs/PublicAPISpecification.md`
6. `TASKS.md`
7. Module-specific documentation
8. Contract documents
9. Supporting project-management documentation

A lower-priority document must not override a higher-priority document.

Any contradiction must be resolved by updating the affected documents before implementation continues.

---

## Recommended Reading Order

### 1. Project Foundation

1. `README.md`
2. `AGENTS.md`
3. `ARCHITECTURE.md`
4. `MODULES.md`
5. `TASKS.md`

### 2. Architecture and Specification

6. `docs/ArchitectureLock.md`
7. `docs/DependencyMatrix.md`
8. `docs/TypeSpecification.md`
9. `docs/PublicAPISpecification.md`
10. `docs/KnowledgeFileSpecification.md`
11. `docs/B4JImplementationGuide.md`

### 3. Module Design

12. `docs/KnowledgeModel.md`
13. `docs/KnowledgeLoader.md`
14. `docs/KnowledgeNormalizer.md`
15. `docs/KnowledgeSemantic.md`
16. `docs/KnowledgeRule.md`
17. `docs/KnowledgeInference.md`
18. `docs/KnowledgeEvaluator.md`
19. `docs/KnowledgeResult.md`
20. `docs/KnowledgeRuntime.md`
21. `docs/KnowledgeEngine.md`

### 4. Internal Contracts

22. `docs/contracts/FrameworkContract.md`
23. `docs/contracts/ModuleContract.md`
24. `docs/contracts/CollectionContract.md`
25. `docs/contracts/EvidenceContract.md`
26. `docs/contracts/FeatureContract.md`
27. `docs/contracts/KnowledgeContract.md`
28. `docs/contracts/RuntimeContract.md`
29. `docs/contracts/ResultContract.md`

### 5. Knowledge and Inference Design

30. `docs/KnowledgeFiles.md`
31. `docs/BusinessDictionary.md`
32. `docs/SemanticCategories.md`
33. `docs/InferenceRules.md`
34. `docs/KnowledgeLifecycle.md`

### 6. Implementation and Governance

35. `docs/B4JCodingStandard.md`
36. `docs/NamingConvention.md`
37. `docs/ErrorHandling.md`
38. `docs/Testing.md`
39. `docs/ReviewChecklist.md`
40. `docs/Roadmap.md`
41. `docs/RoadmapDetailed.md`
42. `docs/Versioning.md`
43. `docs/ReleaseProcess.md`
44. `docs/Glossary.md`

---

## Repository Structure

```text
/
├── AGENTS.md
├── ARCHITECTURE.md
├── MASTER_INDEX.md
├── MODULES.md
├── README.md
├── TASKS.md
├── docs/
│   ├── ArchitectureLock.md
│   ├── DependencyMatrix.md
│   ├── TypeSpecification.md
│   ├── PublicAPISpecification.md
│   ├── KnowledgeFileSpecification.md
│   ├── B4JImplementationGuide.md
│   ├── KnowledgeModel.md
│   ├── KnowledgeLoader.md
│   ├── KnowledgeNormalizer.md
│   ├── KnowledgeSemantic.md
│   ├── KnowledgeRule.md
│   ├── KnowledgeInference.md
│   ├── KnowledgeEvaluator.md
│   ├── KnowledgeResult.md
│   ├── KnowledgeRuntime.md
│   ├── KnowledgeEngine.md
│   ├── contracts/
│   │   ├── FrameworkContract.md
│   │   ├── ModuleContract.md
│   │   ├── CollectionContract.md
│   │   ├── EvidenceContract.md
│   │   ├── FeatureContract.md
│   │   ├── KnowledgeContract.md
│   │   ├── RuntimeContract.md
│   │   └── ResultContract.md
│   └── ...
└── src/
    └── framework modules are added task by task
```

---

## Framework Module Sequence

Implementation must follow this order unless the architecture is formally changed:

| Task | Module | Status |
|---|---|---|
| T001 | `KnowledgeModel.bas` | Not Started |
| T002 | `KnowledgeLoader.bas` | Blocked by T001 |
| T003 | `KnowledgeNormalizer.bas` | Blocked by T001 |
| T004 | `KnowledgeSemantic.bas` | Blocked by T001 and T003 |
| T005 | `KnowledgeRule.bas` | Blocked by T001 and T003 |
| T006 | `KnowledgeInference.bas` | Blocked by T001 and T004 |
| T007 | `KnowledgeEvaluator.bas` | Blocked by T001, T005, and T006 |
| T008 | `KnowledgeResult.bas` | Blocked by T001 and T007 |
| T009 | `KnowledgeRuntime.bas` | Blocked by T001–T008 |
| T010 | `KnowledgeEngine.bas` | Blocked by T009 |

Only one implementation task should be active at a time unless explicitly approved.

---

## Document Status

### Approved Baseline

The following documents form the baseline architecture once reviewed and approved:

- `AGENTS.md`
- `ARCHITECTURE.md`
- `MODULES.md`
- `TASKS.md`
- `docs/ArchitectureLock.md`
- `docs/DependencyMatrix.md`
- `docs/TypeSpecification.md`
- `docs/PublicAPISpecification.md`
- `docs/KnowledgeFileSpecification.md`

### Supporting Documents

Supporting documents explain implementation details but may not override the approved baseline.

### Draft Documents

A document remains Draft until its content has been checked against:

- module names,
- public APIs,
- dependency direction,
- type definitions,
- task sequence,
- framework contracts.

---

## Architecture Summary

The framework contains ten modules:

1. KnowledgeModel
2. KnowledgeLoader
3. KnowledgeNormalizer
4. KnowledgeSemantic
5. KnowledgeRule
6. KnowledgeInference
7. KnowledgeEvaluator
8. KnowledgeResult
9. KnowledgeRuntime
10. KnowledgeEngine

Core flow:

```text
Input
  ↓
Normalization
  ↓
Semantic Feature Extraction
  ↓
Keyword / Rule Evaluation
  ↓
Inference Evaluation
  ↓
Evidence Combination
  ↓
Final Result
```

Keyword and inference paths remain independent until evidence combination.

---

## Locked Principles

- Knowledge stays outside source code.
- Precision is preferred over recall.
- NA is valid and preferred over an inaccurate classification.
- Rules are expanded once during loading.
- Shared naming uses `Obyek`, never `Object`.
- Lists and Maps exposed through public APIs must be initialized.
- Circular dependencies are forbidden.
- The framework core does not contain WhatsApp, SQLite, OLT, MikroTik, or UI logic.
- `KnowledgeEngine` is the host-facing facade.
- `KnowledgeRuntime` owns pipeline coordination.
- `KnowledgeEvaluator` combines evidence.
- `KnowledgeResult` formats results but does not score.

---

## Change Control

Before changing architecture:

1. Record the reason.
2. Identify affected modules.
3. Identify API impact.
4. Update architecture documents.
5. Update `TASKS.md`.
6. Update module and contract documents.
7. Review compatibility.
8. Approve before coding.

Codex must not redefine architecture while implementing a task.

---

## Implementation Gate

Implementation may begin only when:

- documentation review is complete,
- contradictions have been resolved,
- T001 acceptance criteria are explicit,
- repository is clean,
- Codex receives only the active task.

The first active implementation task is:

```text
T001 — KnowledgeModel.bas
```
