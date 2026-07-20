# Collection Contract

## General Rules

- Lists and Maps must be initialized before use.
- Public methods must not return Null collections.
- Empty initialized collections are preferred over Null.
- Collection order must be deterministic where order affects results.

## Ownership

The module that creates a collection owns its mutation.

Getters expose data for reading. Callers must not assume ownership.

## Duplicates

Duplicates are not allowed in:

- canonical token lists,
- semantic values per category,
- loaded rule collections,
- inference rule collections,
- candidate lists.

Duplicate evidence may be retained only when it represents distinct sources or distinct matches.

## Clear

`Clear` removes collection contents but leaves the collection initialized.

## Maps

- Keys representing categories must use `Trim.ToLowerCase`.
- Missing keys must return an initialized empty List where a List is expected.
- Map iteration order must not be used for final ranking unless explicitly sorted.
