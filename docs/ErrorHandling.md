# Error Handling

## Principles

- Never silently ignore errors.
- Missing required files must be reported.
- Malformed rows must include file and line information when possible.
- Runtime must not report Ready when required loading failed.
- Empty optional files may be valid.
- Public operations should return predictable values.
