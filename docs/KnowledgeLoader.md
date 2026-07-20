# KnowledgeLoader

## Responsibility

Loads knowledge files from a configurable base path.

## Supported Input

- Plain text line files.
- Semicolon-delimited files.
- CSV-like files where delimiter is explicitly defined.

## File Rules

- Ignore blank lines.
- Ignore comment lines beginning with `#`.
- Trim values.
- Preserve source order.
- Report malformed rows.
- Never silently skip structural errors.

## Output

Returns Lists, Maps, or validated model items for other modules.
