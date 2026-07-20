# Runtime Contract

## Responsibility

`KnowledgeRuntime` coordinates the complete processing pipeline.

## Readiness

Runtime is ready only when:

- initialization succeeded,
- required knowledge loaded,
- all required modules initialized,
- no blocking load error remains.

## Process Contract

`Process(InputText)` must:

1. preserve OriginalText,
2. normalize input,
3. extract features,
4. evaluate keyword rules,
5. evaluate inference rules,
6. combine evidence,
7. build a structured result.

## Empty Input

Empty or whitespace-only input returns a predictable NA result.

## Errors

Processing errors must be recorded in `GetLastErrors`.

Runtime must not silently return a successful result after a blocking internal failure.

## Reset

Reset clears transient processing state.

Reset does not delete knowledge configuration unless explicitly requested.

## Integration Boundary

Runtime contains no direct UI, WhatsApp, database, OLT, or MikroTik logic.
