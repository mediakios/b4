# TFact Writing Rules

## Document Information

| Item | Value |
|------|-------|
| Document ID | KFS-TFACT-005 |
| Component | TFact |
| Version | 1.0 |
| Status | FINAL |

# Purpose

Dokumen ini mendefinisikan aturan baku penulisan TFact agar seluruh implementasi menghasilkan struktur yang konsisten.

# Rules

## Rule 1
Satu TFact hanya mewakili satu fakta.

## Rule 2
Category wajib menggunakan nama canonical.

## Rule 3
Value wajib menggunakan bentuk canonical.

## Rule 4
Source harus menunjukkan komponen pembentuk TFact.

## Rule 5
Reference menggunakan format:
file:id

## Rule 6
Confidence menggunakan rentang 0–100.

## Rule 7
StartPosition dan EndPosition mengacu pada CleanText.

## Rule 8
Jika posisi tidak diketahui gunakan -1.

## Rule 9
Negasi disimpan menggunakan IsNegated=True, bukan mengubah Value.

## Rule 10
TFact tidak boleh menyimpan Relation, Conclusion, Workflow, Gate maupun Business Rule.

# Summary

Seluruh implementasi wajib mengikuti aturan ini agar TFact tetap konsisten lintas bahasa dan platform.
