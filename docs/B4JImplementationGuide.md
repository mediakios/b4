# B4J Implementation Guide

## Module Form

Framework source files should be B4J class modules unless a task explicitly requires another module type.

## Global Declarations

- Keep shared Type declarations with approved global declarations.
- When showing paste-ready declarations, omit the `Sub Process_Globals ... End Sub` wrapper.
- Initialize Lists and Maps in `Initialize`.

## Collections

Use predictable empty collections rather than Null.

```text
Dim Result As List
Result.Initialize
Return Result
```

## Strings

- Trim external input.
- Normalize category keys with `Trim.ToLowerCase`.
- Preserve original user input separately.
- Avoid case-sensitive matching unless explicitly required.

## Error Handling

- Record errors in an initialized List.
- Include file name and line number where applicable.
- Return Boolean for operations with predictable success or failure.
- Do not hide malformed data.

## Helpers

- Private helper Subs are allowed when directly required.
- Include all required helpers in the same module.
- Avoid duplicate helpers across modules when a lower-level shared solution exists.

## Compatibility

- Do not introduce external libraries without approval.
- Avoid Java-specific constructs that are unnecessary in B4J.
- Do not create `Main.bas`.
- Do not include UI, database, WhatsApp, OLT, or MikroTik code in the framework core.
