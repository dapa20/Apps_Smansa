# TODO — Realtime Kalender & Berita (2026) — ✅ SELESAI

## Backend (C:\xampp\htdocs\lms-smansa)
- [x] 1. Buat endpoint `api/kalender.php` (jadwal ujian + deadline tugas + libur nasional 2026)
- [x] 2. Update isi pengumuman di DB agar tahun 2026

## Flutter (lms-smansa-mobile)
- [x] 3. `api_repository.dart` — tambah method `getKalender()`
- [x] 4. `kalender_screen.dart` — ganti mock → API (focusedDay=sekarang, rentang 2026, subtitle dinamis, loading/error/retry)
- [x] 5. `beranda_screen.dart` — ganti mock → API (berita dari getPengumuman/getDashboard, pelajaran dari getJadwal)
- [x] 6. Perbaiki bug `LocaleDataException` di `main.dart` (initializeDateFormatting)
- [x] 7. Hapus file temp `tmp_inspect_data.php` & `tmp_update_pengumuman.php`

## Testing
- [x] 8. `flutter analyze` — 0 error (3 info lama)
- [x] 9. Endpoint kalender terverifikasi: SUCCESS, 15 events (2026)
- [x] 10. Pengumuman DB terverifikasi: 3 records, tahun 2026

