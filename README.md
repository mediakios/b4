# B4 Knowledge Framework

B4 Knowledge Framework adalah framework modular berbasis B4J untuk memuat, menormalkan, menganalisis, mengevaluasi, dan menjalankan knowledge berbasis file.

## Tujuan

- Memisahkan knowledge dari source code.
- Menjaga arsitektur modular.
- Mendukung keyword, semantic, dan inference secara paralel.
- Mengutamakan presisi daripada recall.
- Memungkinkan integrasi dengan proyek B4J lain.

## Alur Utama

Input
→ Normalize
→ Semantic Extraction
→ Rule Evaluation
→ Inference
→ Candidate Evaluation
→ Result
→ Runtime
→ Public Engine

## Struktur

- `AGENTS.md` — aturan tetap untuk Codex.
- `TASKS.md` — urutan implementasi.
- `ARCHITECTURE.md` — arsitektur utama.
- `MODULES.md` — daftar modul.
- `docs/` — spesifikasi detail.
- `src/` — source code B4J.
- `knowledge/` — file knowledge.
- `tests/` — pengujian.
