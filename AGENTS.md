# AGENTS

## Project

Name: B4 Knowledge Framework  
Language: B4J  
Primary Branch: main

## Mandatory Workflow

1. Read `AGENTS.md`.
2. Read `TASKS.md`.
3. Find the first task with `Status: Ready`.
4. Implement only that task.
5. Do not implement any Pending task.
6. Update task status after completion.
7. Stop.

## Task Rules

- Only one task may be `Ready`.
- One task targets one `.bas` module.
- Public functions must exactly match the task.
- Private helper Subs may be added only when necessary.
- Do not rename existing public functions.
- Do not create unrelated modules.
- Do not modify completed modules unless explicitly required.

## B4J Rules

- Produce valid B4J syntax.
- Do not create `Main.bas` unless explicitly requested.
- Use descriptive names.
- Use `Obyek`, not `Object`, for project entity fields.
- Keep helper Subs with the main implementation.
- Initialize all Lists and Maps before use.
- Do not silently ignore errors.
- Do not hard-code business knowledge.
- Keep Type declarations in the approved central model module.
- Avoid unsupported Java syntax.

## Architecture Rules

- Knowledge must remain file-driven.
- Loader only loads.
- Normalizer only normalizes.
- Semantic module only extracts semantic features.
- Rule module only evaluates keyword rules.
- Inference module only evaluates inference rules.
- Evaluator combines candidate evidence.
- Result module formats results.
- Runtime coordinates modules.
- Engine exposes the public API.

## Completion Report

After completing a task, report:

- task ID,
- files created,
- files modified,
- public functions implemented,
- checks performed,
- unresolved issues.

## Restrictions

- Do not invent requirements.
- Do not change architecture without explicit instruction.
- Do not add external libraries without approval.
- Do not automatically continue to the next task.
