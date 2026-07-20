# Framework Contract

## Purpose

This document defines the framework-wide behavioral contract.

## Core Guarantees

- The framework is deterministic for the same input and same knowledge state.
- Knowledge remains external to source code.
- Public getters never return uninitialized Lists or Maps.
- NA is a valid result.
- Precision is preferred over recall.
- Lower modules never depend on higher modules.
- No module silently changes another module's internal state.

## Lifecycle

1. Initialize.
2. Load knowledge.
3. Validate readiness.
4. Process input.
5. Return result.
6. Reset runtime state when requested.

## Reinitialization

Repeated calls to `Initialize` must be safe.

Reinitialization must:

- leave all required collections initialized,
- not duplicate existing knowledge,
- not preserve stale transient evidence,
- not create hidden side effects.

## Mutation

Shared runtime collections may only be mutated by their owning module or through approved public methods.

## Failure Behavior

When a required operation fails:

- return a predictable value,
- record a descriptive error,
- do not continue with partial hidden fallback behavior.
