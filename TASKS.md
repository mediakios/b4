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

Status: Completed

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

Status: Completed

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

Status: Completed

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

Status: Completed

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

Status: Completed

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

Status: Completed

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

---

# T011

Status: Completed

Module / Test Project:

`test/KnowledgeFrameworkTest/`

Objective:

Compile and exercise the public KnowledgeEngine API.

Public API Tested:

- Initialize
- Load
- Analyze
- Reset
- IsReady
- Version

Acceptance Criteria:

- B4J non-UI integration project can be opened.
- Framework sources are linked from `src` without implementation copies.
- Tests use KnowledgeEngine as the primary API.
- Failure paths and NA result structure are asserted.
- PASS/FAIL output is deterministic.
- No external dependencies.

---

# T012

Status: Completed

Module / Test Project:

`test/KnowledgeFrameworkTest/`

Objective:

Add a minimal valid knowledge dataset and verify the complete public
KnowledgeEngine pipeline from Load through Analyze.

Required test knowledge files:

- semantic_file.txt
- obyek.txt
- problem.txt
- goal.txt
- aksi.txt
- request.txt
- keadaan.txt
- context.txt
- rules.txt
- inferensi.txt
- kamus_gaul.csv
- negasi.txt

Test scenarios:

1. Load a complete valid knowledge directory.
2. IsReady returns True after a successful Load.
3. Analyze a keyword-rule example and verify its candidate.
4. Analyze a semantic-inference example and verify its candidate.
5. Analyze an unmatched chat and verify NA.
6. Reset after a successful Load and verify IsReady returns False.
7. Verify returned Candidates, ScoreMap, DetailMap, CleanText, and OriginalText.
8. Keep test output deterministic.

Acceptance Criteria:

- Uses only the public KnowledgeEngine API for integration assertions.
- Test knowledge is minimal and contains no ISP-specific hard-coded logic
  inside framework source modules.
- Valid Load succeeds.
- Keyword path is proven.
- Semantic/inference path is proven.
- NA behavior remains valid.
- All previous 15 baseline tests continue to pass.
- New tests pass.
- No external dependencies.
- T012 becomes Completed only after successful compilation and test run.
- Do not create T013 automatically.

---

# T013

Status: Ready

Objective:

Add `business_dictionary.csv` as the canonical source for business vocabulary,
variants, and semantic categories.

Scope:

- `src/KnowledgeLoader.bas`
- `src/KnowledgeRuntime.bas`
- `test/KnowledgeFrameworkTest/`

Requirements:

1. Define columns: Canonical, Variants, Kategori, Catatan, Prioritas, Status.
2. Ignore blank/comment lines.
3. Load only `Status=active`.
4. Build deterministic variant-to-canonical map.
5. Build semantic category map.
6. Detect conflicting variants.
7. Report malformed rows using existing load errors.
8. Preserve backward compatibility.
9. Do not change the public `KnowledgeEngine` API.

Acceptance Criteria:

- T012 stays Completed.
- T013 becomes the only Ready task.
- Do not implement T013 as part of this task definition update.
