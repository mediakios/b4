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

## Expected output

Output berasal dari assertion aktual dan berbentuk:

```text
PASS | Initialize
PASS | Version
...
TOTAL: 15
PASSED: 15
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

## Batasan

Project ini fokus pada compile dan failure-path integration. Tidak ada knowledge fixture karena load sukses membutuhkan seluruh knowledge pack wajib yang ditetapkan loader. Compile dan runtime harus dijalankan melalui B4J IDE apabila compiler B4J tidak tersedia di lingkungan Codex.
