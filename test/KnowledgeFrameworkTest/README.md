# KnowledgeFrameworkTest

Project ini adalah integration test B4J non-UI untuk API publik `KnowledgeEngine`.

## Membuka project

1. Pasang B4J dan JDK sesuai petunjuk resmi B4J.
2. Pertahankan struktur repository; project memakai link relatif ke semua modul dalam `../../src`.
3. Buka `KnowledgeFrameworkTest.b4j` dari B4J IDE.
4. Jika IDE meminta pemulihan linked modules, tambahkan setiap file `.bas` dari `../../src` dengan opsi **Link - relative path**.

B4J menyimpan modul Main secara langsung di file project `.b4j`. `Main.bas` disediakan sebagai mirror referensi source test; jangan tambahkan file itu sebagai module kedua karena akan menduplikasi Main.

## Menjalankan

Pilih **Run** atau **Compile & Run**. Project adalah console/non-UI dan hanya membutuhkan library bawaan `jCore`.

Test mencakup:

- `Initialize`;
- versi `1.0.0`;
- kondisi awal belum ready;
- `Analyze` sebelum load dan struktur hasil NA;
- kegagalan load pada path yang tidak ada;
- `Reset`;
- keamanan input string kosong dan `Null`.
- load dataset valid dan status ready;
- jalur keyword-rule dengan kandidat tunggal;
- jalur semantic/inference dengan kandidat tunggal;
- integrasi varian dan kategori aktif dari `business_dictionary.csv`;
- pengabaian entri kamus bisnis berstatus inactive;
- pelaporan varian kamus bisnis yang konflik dan baris malformed;
- hasil NA untuk chat yang tidak cocok;
- struktur `Candidates`, `ScoreMap`, `DetailMap`, `CleanText`, dan `OriginalText`;
- reset setelah load berhasil.

## Expected output

Output berasal dari assertion aktual dan berbentuk:

```text
PASS | Initialize
PASS | Version
...
TOTAL: 34
PASSED: 34
FAILED: 0
```

Jumlah PASS yang aktual tetap ditentukan oleh eksekusi test; kegagalan akan ditampilkan sebagai `FAIL | <nama> | <detail>`.

## Verified baseline

Baseline ini diverifikasi dengan B4JBuilder 10.50 dan Java 19. Project berhasil dikompilasi, JAR test dijalankan, dan menghasilkan:

```text
TOTAL: 15
PASSED: 15
FAILED: 0
```

Integrasi T013 juga diverifikasi dengan B4JBuilder 10.20 dan Java 17. Seluruh assertion menghasilkan:

```text
TOTAL: 41
PASSED: 41
FAILED: 0
```

## Batasan

Fixture minimal berada di direktori `knowledge` dan hanya berisi pengetahuan netral untuk pengujian pipeline. Compile dan runtime harus dijalankan melalui B4J IDE apabila compiler B4J tidak tersedia di lingkungan Codex.
