# TFact Function Specification

## Document Information

| Item | Value |
|------|-------|
| Document ID | KFS-TFACT-004 |
| Component | TFact |
| Version | 1.0 |
| Status | FINAL |

# Purpose

TFact merepresentasikan satu fakta atomik hasil ekstraksi dari CleanText.

# Primary Function

Menyimpan satu fakta knowledge yang telah dikenali.

# Responsibilities

- Menyimpan kategori fakta
- Menyimpan nilai canonical
- Menyimpan source
- Menyimpan reference
- Menyimpan confidence
- Menyimpan posisi fakta
- Menyimpan status negasi

# Non Responsibilities

TFact tidak:
- membangun relation
- melakukan inference
- menentukan workflow
- menentukan gate
- menentukan intent
- menjalankan business rule

# Lifecycle

CleanText
↓
Fact Extraction
↓
TFact
↓
Relation Builder
↓
Inference Engine

# Summary

TFact adalah fondasi seluruh Knowledge Framework.
