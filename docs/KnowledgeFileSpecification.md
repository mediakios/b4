# Knowledge File Specification

## General Rules

- Encoding: UTF-8.
- Empty lines are ignored.
- Comment lines begin with `#`.
- Leading and trailing whitespace is trimmed.
- Duplicate canonical entries are removed during loading.
- Malformed rows must be reported with file name and line number when possible.
- Knowledge is loaded at application startup.
- Compact rules are expanded once during loading, never repeatedly during evaluation.

## intent.csv

```text
intent;keyword1,keyword2,keyword3
```

Purpose: initial keyword candidates.

The format is fixed and must not be changed.

## rules.txt

```text
keyword;intent;category;obyek
```

Rules should place `obyek` at the end.

## kamus_gaul.csv

```text
variant;canonical
```

Maps slang, abbreviations, and common misspellings to canonical tokens.

## katainti.txt

```text
one_canonical_token_per_line
```

## negasi.txt

```text
one_true_negation_token_per_line
```

Only genuine negation words belong here.

## context_obyek.txt

```text
one_obyek_per_line
```

Used to validate that relevant rules contain an object.

## aksi_selesai.txt

```text
one_completed_action_marker_per_line
```

Used to distinguish completed actions from desired actions.

## semantic_file.txt

```text
obyek.txt
problem.txt
goal.txt
aksi.txt
request.txt
keadaan.txt
context.txt
```

The list is dynamic; the number of semantic files may change.

## Semantic Category Files

Each file contains one canonical token per line.

Approved initial categories:

- obyek
- problem
- goal
- aksi
- request
- keadaan
- context

## business_dictionary.csv

```text
Canonical;Variants;Kategori;Catatan;Prioritas;Status
```

- `Canonical`: canonical token.
- `Variants`: comma-separated variants.
- `Kategori`: approved semantic category.
- `Catatan`: optional human-readable note.
- `Prioritas`: metadata.
- `Status`: active or inactive.

## Inferensi.txt

Recommended format:

```text
intent;Category1=Value1;Category2=Value2
```

Example:

```text
lupa_sandi;problem=lupa;obyek=sandi
gangguan;problem=mati;obyek=internet
```

All required feature expressions must match.
