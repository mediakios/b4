# Module Contract

## Single Responsibility

Each module has one primary responsibility.

A module must not absorb responsibilities from neighboring modules for convenience.

## Public API

- Public Sub names are fixed by `TASKS.md`.
- Public methods may not be renamed without documentation updates.
- Public parameters and return types are part of the contract.
- Public getters must return initialized collections.

## Private Helpers

Private helper Subs are allowed only when required by the module's responsibility.

## Dependencies

Modules may only depend on modules allowed by `DependencyMatrix.md`.

Circular dependencies are forbidden.

## State Ownership

Each module owns and manages its internal state.

External modules may not directly mutate internal Lists, Maps, or flags.

## Reset Behavior

A module reset must:

- clear transient state,
- keep required collections initialized,
- preserve configuration only when explicitly documented.
