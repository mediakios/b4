# TASKS

## Workflow

- Only one task may have `Status: Ready`.
- All other unfinished tasks must be `Pending`.
- Complete tasks sequentially.
- Do not skip tasks.
- Do not begin the next task automatically.

---

# T001

Status: Completed

Module:

`src/KnowledgeModel.bas`

Objective:

Create the central data model and shared runtime collections.

Public Functions:

- Initialize
- Clear
- IsInitialized
- AddEvidence
- GetEvidenceList
- AddRule
- GetRuleList
- AddInferenceRule
- GetInferenceRuleList
- SetFeature
- GetFeature
- GetFeatureMap

Acceptance Criteria:

- Valid B4J class module.
- All collections initialized.
- No business logic.
- No hard-coded knowledge.
- No unrelated modules created.
- T001 becomes Completed.
- T002 becomes Ready.
- Stop.

---

# T002

Status: Completed

Module:

`src/KnowledgeLoader.bas`

Objective:

Load and validate knowledge files.

Public Functions:

- Initialize
- SetBasePath
- GetBasePath
- LoadTextLines
- LoadDelimitedFile
- LoadSemanticFileList
- LoadAll
- GetLoadErrors
- ClearErrors

Acceptance Criteria:

- Missing files reported predictably.
- Empty lines ignored.
- Comments supported.
- No normalization or evaluation logic.

---

# T003

Status: Completed

Module:

`src/KnowledgeNormalizer.bas`

Objective:

Normalize raw input into canonical text and tokens.

Public Functions:

- Initialize
- SetVariantMap
- NormalizeText
- NormalizeTokens
- Tokenize
- JoinTokens
- IsNegated

Acceptance Criteria:

- Case-insensitive normalization.
- Preserves deterministic token order.
- Negation radius configurable internally.
- No semantic or rule scoring.

---

# T004

Status: Completed

Module:

`src/KnowledgeSemantic.bas`

Objective:

Extract semantic features from normalized tokens.

Public Functions:

- Initialize
- SetSemanticDictionary
- ClearFeatures
- ExtractFeatures
- GetFeature
- GetFeatureMap
- HasFeature

Acceptance Criteria:

- Supports categories: obyek, problem, goal, aksi, request, keadaan, context.
- No gate selection.
- No rule or inference evaluation.

---

# T005

Status: Ready

Module:

`src/KnowledgeRule.bas`

Objective:

Evaluate keyword rules and produce evidence.

Public Functions:

- Initialize
- SetRules
- Evaluate
- MatchRule
- GetEvidence
- ClearEvidence

Acceptance Criteria:

- Uses TRule and TEvidence.
- Supports negation checking.
- Produces evidence only.
- Does not select final result.

---

# T006

Status: Pending

Module:

`src/KnowledgeInference.bas`

Objective:

Evaluate semantic feature rules and produce inference evidence.

Public Functions:

- Initialize
- SetInferenceRules
- Evaluate
- MatchFeature
- MatchRule
- GetEvidence
- ClearEvidence

Acceptance Criteria:

- Uses TInferenceRule.
- No hard-coded gates.
- No final candidate selection.

---

# T007

Status: Pending

Module:

`src/KnowledgeEvaluator.bas`

Objective:

Combine keyword and inference evidence.

Public Functions:

- Initialize
- Clear
- AddEvidenceList
- BuildScoreMap
- BuildDetailMap
- GetQualifiedCandidates
- EvaluateFinal

Acceptance Criteria:

- Precision over recall.
- NA allowed.
- Multi allowed.
- Deterministic ordering.

---

# T008

Status: Pending

Module:

`src/KnowledgeResult.bas`

Objective:

Create structured and text results.

Public Functions:

- Initialize
- CreateResult
- CreateNAResult
- CreateMultiResult
- ToDelimitedText
- ToMap

Acceptance Criteria:

- Stable output format.
- No evaluation logic.
- Original chat preserved.

---

# T009

Status: Pending

Module:

`src/KnowledgeRuntime.bas`

Objective:

Coordinate initialization and processing pipeline.

Public Functions:

- Initialize
- LoadKnowledge
- Process
- Reset
- IsReady
- GetLastErrors

Acceptance Criteria:

- Coordinates modules only.
- Stops predictably on load failure.
- No UI, WhatsApp, database, OLT, or MikroTik dependencies.

---

# T010

Status: Pending

Module:

`src/KnowledgeEngine.bas`

Objective:

Expose the public framework API.

Public Functions:

- Initialize
- Load
- Analyze
- Reset
- IsReady
- Version

Acceptance Criteria:

- Simple host-facing API.
- Delegates to KnowledgeRuntime.
- No duplicated processing logic.
