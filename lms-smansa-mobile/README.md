# LMS SMANSA Mobile 📱

[![Flutter](https://img.shields.io/badge/Flutter-3.11+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/license-Internal-lightgrey)](#license)
[![Version](https://img.shields.io/badge/version-2.4.0-blue)](pubspec.yaml)

Aplikasi mobile **LMS (Learning Management System)** untuk siswa **SMA Negeri 1 Bumiayu**. Dibangun dengan **Flutter** dan berkomunikasi dengan backend **PHP + MySQL** yang sudah terpasang di XAMPP (`lms-smansa`).

> Aplikasi siswa resmi yang menampilkan jadwal pelajaran, tugas, ujian, kalender akademik, materi, berita, pengumuman, riwayat akademik, dan pengaturan akun.

---

## 📑 Daftar Isi

1. [Tentang Aplikasi](#-tentang-aplikasi)
2. [Screenshot / Fitur](#-fitur-utama)
3. [Arsitektur & Tech Stack](#-arsitektur--tech-stack)
4. [Struktur Folder](#-struktur-folder)
5. [Setup & Instalasi](#-setup--instalasi)
6. [Konfigurasi](#-konfigurasi)
7. [Backend (Wajib)](#-backend-wajib)
8. [Menjalankan Aplikasi](#-menjalankan-aplikasi)
9. [Akun Default](#-akun-default)
10. [API yang Dipakai](#-api-yang-dipakai)
11. [Build untuk Android](#-build-untuk-android)
12. [Troubleshooting](#-troubleshooting)
13. [Catatan Developer](#-catatan-developer)
14. [Lisensi](#-lisensi)

---

## 🎯 Tentang Aplikasi

`lms-smansa-mobile` adalah aplikasi Flutter yang dipakai siswa SMA Negeri 1 Bumiayu untuk:

- 🏠 **Beranda** — lihat pengumuman, materi terbaru, dan pintasan ke semua fitur.
- 📅 **Jadwal** — jadwal pelajaran per hari (Senin–Sabtu).
- 🗓️ **Kalender Akademik** — agenda ujian, deadline tugas, libur nasional dari API.
- 📝 **Tugas & Ujian** — daftar tugas aktif, status pengumpulan, ujian yang sedang berlangsung.
- 📚 **Materi** — daftar materi pembelajaran per mata pelajaran.
- 🔔 **Notifikasi** — daftar pengumuman dari sekolah dengan badge merah untuk yang baru.
- 📰 **Berita** — kumpulan berita & pengumuman.
- 📊 **Riwayat Akademik** — rekap nilai per semester, rata-rata, huruf mutu.
- 🎫 **Pemindai Kartu** — pemindai QR/barcode (placeholder).
- 🏫 **SMANSAGO** — portal pintasan ke layanan digital sekolah.
- 👤 **Profil & Pengaturan Akun** — data diri, ubah password, logout.

---

## ✨ Fitur Utama

| Fitur | Status | Keterangan |
|---|---|---|
| Autentikasi (NIS + Password) | ✅ | Token disimpan di `shared_preferences` |
| Auto-login saat app dibuka | ✅ | Validasi token ke server saat splash |
| Lihat jadwal pelajaran | ✅ | Realtime dari API |
| Lihat kalender akademik | ✅ | Realtime dari API (ujian + deadline + libur) |
| Daftar tugas & status | ✅ | Realtime dari API |
| Daftar ujian & kuis | ✅ | Realtime (mock untuk ujian mendatang) |
| Lihat materi per mapel | ✅ | Realtime dari API |
| Daftar pengumuman/berita | ✅ | Realtime dari API |
| Riwayat nilai | ✅ | Realtime per semester |
| Scan QR/barcode | ⚠️ | UI placeholder |
| Notifikasi badge merah | ✅ | Otomatis hilang setelah lihat tab Notifikasi |
| Ubah password | ✅ | Validasi client + server |
| Tombol back di semua halaman | ✅ | Konsisten (AppBar atau overlay) |
| Logout | ✅ | Clear token + cache |
| Dark mode | ❌ | Belum diimplementasikan |

---

## 🏗 Arsitektur & Tech Stack

### Frontend (Flutter)
- **Bahasa:** Dart (SDK `^3.11.5`)
- **Framework:** Flutter (Material Design 3)
- **HTTP Client:** `http` package (REST API)
- **State Management:** `setState` + `ChangeNotifier` (ringan, tanpa GetX/Provider/BLoC)
- **Storage Lokal:** `shared_preferences` (token + cache siswa)
- **Font:** Google Fonts (`google_fonts`)
- **Kalender:** `table_calendar` + `intl` (lokalisasi `id_ID`)

### Backend (PHP + MySQL)
- **Web server:** Apache (XAMPP)
- **Bahasa:** PHP 8.2 native (PDO, tanpa framework)
- **Database:** MySQL (`lms_smansa`)
- **Autentikasi:** Token-based (Bearer), disimpan di tabel `siswa_tokens`

### Pola Arsitektur
```
Screens (UI)
    ↓ panggil method
ApiRepository (singleton) → ApiClient (HTTP)
                                ↓ Authorization: Bearer <token>
                            Backend PHP
                                ↓ query PDO
                            MySQL (lms_smansa)

Notifikasi badge ↔ NotificationBadgeController (ChangeNotifier)
Pindah tab        ↔ MainShellController (ChangeNotifier)
```

---

## 📂 Struktur Folder

```
lms-smansa-mobile/
├── android/                        # Konfigurasi native Android
│   ├── app/
│   │   ├── build.gradle.kts
│   │   └── src/main/AndroidManifest.xml
│   └── ...
├── assets/
│   └── images/
│       └── logo_smansa.png         # Logo sekolah
├── lib/
│   ├── main.dart                   # Entry point (inisialisasi date formatting)
│   ├── app/                        # App-level config
│   │   ├── app.dart                # MaterialApp + routing
│   │   ├── routes.dart             # Daftar nama route
│   │   ├── main_shell_controller.dart   # Controller pindah tab bottom nav
│   │   └── notification_badge_controller.dart  # Badge merah notifikasi
│   ├── core/                       # Core utilities
│   │   ├── api/
│   │   │   ├── api_config.dart         # Base URL & key storage
│   │   │   ├── api_client.dart         # HTTP client + ApiException
│   │   │   ├── api_repository.dart     # Semua endpoint API
│   │   │   └── auth_service.dart       # Login, logout, token management
│   │   ├── constants/
│   │   │   └── app_constants.dart      # Nama app, sekolah, spacing
│   │   └── theme/
│   │       ├── app_colors.dart         # Palet warna
│   │       ├── app_text_styles.dart    # Typography
│   │       └── app_theme.dart          # ThemeData
│   ├── data/
│   │   └── mock_data.dart           # Data dummy (ujian)
│   ├── models/                     # Data classes (Tugas, Siswa, Jadwal, dll)
│   ├── screens/                    # Halaman-halaman
│   │   ├── main_shell.dart         # Container 4 tab (Beranda/Notif/Berita/Profil)
│   │   ├── auth/
│   │   │   ├── splash_screen.dart
│   │   │   └── login_screen.dart
│   │   ├── beranda/
│   │   │   └── beranda_screen.dart
│   │   ├── berita/
│   │   │   └── berita_screen.dart
│   │   ├── jadwal/
│   │   │   └── jadwal_screen.dart
│   │   ├── kalender/
│   │   │   └── kalender_screen.dart
│   │   ├── materi/
│   │   │   └── materi_screen.dart          # + MateriDetailScreen
│   │   ├── notifikasi/
│   │   │   └── notifikasi_screen.dart
│   │   ├── pemindai/
│   │   │   └── pemindai_screen.dart        # UI placeholder
│   │   ├── profil/
│   │   │   ├── profil_screen.dart
│   │   │   ├── data_diri_screen.dart
│   │   │   └── pengaturan_akun_screen.dart
│   │   ├── riwayat/
│   │   │   └── riwayat_screen.dart
│   │   ├── smansago/
│   │   │   └── smansago_screen.dart
│   │   ├── tugas/
│   │   │   └── tugas_screen.dart
│   │   └── ujian/
│   │       └── ujian_screen.dart
│   └── widgets/                   # Komponen reusable
│       ├── back_button_overlay.dart  # Tombol back reusable
│       ├── blue_header.dart
│       ├── bottom_nav_bar.dart
│       ├── search_bar_widget.dart
│       ├── section_header.dart
│       ├── stat_card.dart
│       └── status_chip.dart
├── test/
├── pubspec.yaml                   # Dependencies
├── pubspec.lock
├── analysis_options.yaml          # Lint rules
├── TODO.md                        # Catatan pengerjaan
└── README.md                      # ← File ini
```

---

## 🛠 Setup & Instalasi

### Prasyarat
- **Flutter SDK** `^3.11.5` ([install](https://docs.flutter.dev/get-started/install))
- **Dart SDK** (otomatis dari Flutter)
- **Git**
- **XAMPP** (atau Apache + MySQL standalone)
- **Chrome** (untuk testing mode web)

### Langkah Instalasi

```powershell
# 1. Clone repository
git clone https://github.com/dapa20/Apps_Smansa.git
cd Apps_Smansa

# 2. Install dependencies
flutter pub get

# 3. Aktifkan backend (lihat bagian "Backend" di bawah)

# 4. Jalankan aplikasi
flutter run -d chrome
```

---

## ⚙️ Konfigurasi

### Base URL API

Edit `lib/core/api/api_config.dart`:

```dart
class ApiConfig {
  /// Base URL backend (tanpa trailing slash).
  ///
  /// - **Chrome (web)**: gunakan `http://localhost/lms-smansa`.
  /// - **Emulator Android**: gunakan `http://10.0.2.2/lms-smansa`.
  /// - **Perangkat fisik Android**: gunakan IP LAN PC, mis. `http://192.168.1.10/lms-smansa`.
  static const String baseUrl = 'http://localhost/lms-smansa';
  ...
}
```

| Target | baseUrl |
|---|---|
| Chrome (web) | `http://localhost/lms-smansa` |
| Emulator Android | `http://10.0.2.2/lms-smansa` |
| Android device fisik | `http://<IP-LAN-PC>/lms-smansa` |
| iOS Simulator | `http://localhost/lms-smansa` |

---

## 🗄 Backend (Wajib)

Aplikasi ini **tidak akan bisa login** tanpa backend PHP yang berjalan. Backend tersedia di repo terpisah atau di folder `D:\xampp\htdocs\lms-smansa\`.

### 1. Install XAMPP
- Download dari https://www.apachefriends.org/
- Install ke `C:\xampp` (default)
- Aktifkan **Apache** + **MySQL** dari XAMPP Control Panel

### 2. Taruh Backend
Salin folder `lms-smansa` ke:
```
C:\xampp\htdocs\lms-smansa\
```

Struktur yang diharapkan:
```
C:\xampp\htdocs\lms-smansa\
├── api/
│   ├── auth/
│   │   ├── login.php
│   │   └── logout.php
│   ├── dashboard.php
│   ├── jadwal.php
│   ├── kalender.php
│   ├── materi.php
│   ├── nilai.php
│   ├── pengumuman.php
│   ├── profil.php
│   ├── tugas.php
│   ├── password_update.php
│   └── config.php
├── config/
│   └── database.php
├── database/
│   └── lms_smansa.sql   ← WAJIB DI-IMPORT
└── ...
```

### 3. Import Database
1. Buka http://localhost/phpmyadmin
2. Buat database `lms_smansa` (utf8mb4_unicode_ci)
3. Import file `database/lms_smansa.sql`

### 4. Jalankan Skema SQL Tambahan (WAJIB untuk Login)

> Tabel `siswa` di SQL bawaan **tidak punya kolom `password`** dan tabel `siswa_tokens` **tidak dibuat otomatis**. Jalankan SQL berikut agar login siswa bekerja:

```sql
USE lms_smansa;

-- Tambah kolom password di tabel siswa
ALTER TABLE siswa ADD COLUMN password VARCHAR(255) NULL AFTER jenis_kelamin;

-- Buat tabel sesi/token siswa
CREATE TABLE IF NOT EXISTS siswa_tokens (
  id INT AUTO_INCREMENT PRIMARY KEY,
  siswa_id INT UNSIGNED NOT NULL,
  token VARCHAR(64) NOT NULL UNIQUE,
  expires_at DATETIME NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (siswa_id) REFERENCES siswa(id) ON DELETE CASCADE,
  INDEX idx_token (token),
  INDEX idx_siswa (siswa_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Set password default 'siswa123' untuk semua siswa
-- Ganti <hash> di bawah dengan hash bcrypt yang di-generate:
--   D:\xampp\php\php.exe -r "echo password_hash('siswa123', PASSWORD_BCRYPT);"
UPDATE siswa SET password = '<hash>' WHERE password IS NULL OR password = '';
```

> **Verifikasi**: Buka http://localhost/lms-smansa/api/auth/login.php — harus muncul JSON, bukan error 404.

---

## 🚀 Menjalankan Aplikasi

### Mode Web (Chrome — paling cepat untuk development)
```powershell
flutter run -d chrome
```

### Mode Android Emulator
```powershell
# Pastikan emulator Android sudah jalan dari Android Studio
flutter emulators --launch <emulator_id>
flutter run
```

### Mode Android Device Fisik
1. Aktifkan **USB Debugging** di HP
2. Sambungkan via USB
3. Pastikan HP & PC satu jaringan WiFi
4. Ubah `baseUrl` ke IP LAN PC (lihat Konfigurasi)
6. Jalankan:
   ```powershell
   flutter run
   ```

### Build APK Release
```powershell
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

> ⚠️ Untuk Android device fisik, jangan lupa tambah izin INTERNET di `android/app/src/main/AndroidManifest.xml`:
> ```xml
> <uses-permission android:name="android.permission.INTERNET"/>
> ```
> dan izinkan cleartext HTTP:
> ```xml
> <application ... android:usesCleartextTraffic="true">
> ```

---

## 🔑 Akun Default

Setelah import SQL & set hash password di atas, tersedia **10 akun siswa**:

| NIS | Password | Nama |
|---|---|---|
| 1920101 | siswa123 | Budi Santoso |
| 1920102 | siswa123 | Siti Aminah |
| 1920103 | siswa123 | Ahmad Wijaya |
| 1920104 | siswa123 | Aditya Pratama |
| 1920105 | siswa123 | Budi Santoso Nugraha |
| 1920106 | siswa123 | Citra Lestari |
| 1920107 | siswa123 | Dewi Maharani |
| 1920108 | siswa123 | Eko Prasetyo |
| 1920109 | siswa123 | Fitriani Rahayu |
| 1920110 | siswa123 | Galih Setiawan |

Akun **guru/admin** (untuk backend web, bukan untuk app mobile ini) ada di tabel `users`. Lihat file `database/lms_smansa.sql` untuk melihat semua akun & cara cek password hash-nya.

---

## 🔌 API yang Dipakai

Semua endpoint ada di `http://localhost/lms-smansa/api/` dan memakai header:
```
Authorization: Bearer <token>
Content-Type: application/json
```

| Endpoint | Method | Fungsi |
|---|---|---|
| `/auth/login.php` | POST | Login siswa (NIS + password) |
| `/auth/logout.php` | POST | Logout (hapus token) |
| `/dashboard.php` | GET | Data beranda (siswa, pengumuman, materi terbaru) |
| `/jadwal.php` | GET | Jadwal pelajaran (per hari) |
| `/kalender.php` | GET | Kalender akademik (ujian, deadline, libur) |
| `/tugas.php` | GET | Daftar tugas siswa |
| `/tugas_kumpul.php` | POST | Kumpulkan tugas (support upload file) |
| `/ujian.php` | GET | Daftar ujian/kuis (opsional) |
| `/materi.php` | GET | Daftar materi per mapel / detail |
| `/pengumuman.php` | GET | Daftar pengumuman/berita |
| `/profil.php` | GET | Profil siswa + kehadiran |
| `/kehadiran.php` | GET | Riwayat kehadiran |
| `/nilai.php` | GET | Nilai per semester |
| `/password_update.php` | POST | Ubah password siswa |

Response format standar:
```json
{
  "success": true,
  "message": "...",
  "data": { ... }
}
```

---

## 🧪 Testing

```powershell
flutter analyze         # Static analysis (saat ini: 0 error)
flutter test            # Unit tests (belum banyak test case)
```

---

## 🐞 Troubleshooting

### ❌ Login gagal dengan pesan "Tidak dapat terhubung ke server"

1. **Cek XAMPP aktif** — buka XAMPP Control Panel, pastikan Apache & MySQL hijau (running).
2. **Cek baseUrl** — pastikan `lib/core/api/api_config.dart` sesuai target:
   - Chrome → `http://localhost/lms-smansa`
   - Emulator → `http://10.0.2.2/lms-smansa`
3. **Cek backend ada** — buka http://localhost/lms-smansa di browser, harus muncul halaman login web guru (bukan 404).
4. **Cek tabel `siswa` punya kolom `password`** — jalankan SQL `DESCRIBE siswa;` di phpMyAdmin.
5. **Cek tabel `siswa_tokens` ada** — jalankan `SHOW TABLES LIKE 'siswa_tokens';`.

### ❌ Badge merah tidak muncul
- Buka tab Notifikasi → badge otomatis hilang (sesuai UX).
- Logout & login ulang → badge refresh.
- Cek API `/api/pengumuman.php` di browser, pastikan return array data.

### ❌ Tombol back tidak ada
- Semua halaman non-home sudah ditambahkan tombol back (lihat `lib/widgets/back_button_overlay.dart`).
- Halaman tab (Beranda, Notifikasi, Berita, Profil) **tidak** punya tombol back karena itu halaman root dari bottom nav.

### ❌ Aplikasi stuck di splash
- Biasanya masalah token validasi. Hapus cache:
  ```powershell
  # Chrome: buka DevTools → Application → Clear Storage
  # Android: Settings → Apps → LMS SMANSA → Clear Data
  ```

### ❌ Password tidak bisa diubah
- Cek kolom `password` di tabel `siswa` sudah ditambahkan (lihat SQL di atas).
- Cek endpoint `/api/password_update.php` bisa diakses:
  ```powershell
  curl http://localhost/lms-smansa/api/password_update.php
  # Harus return JSON "Metode tidak diizinkan" (karena pakai GET)
  ```

---

## 📝 Catatan Developer

### Arsitektur Pattern

- **Singleton controllers**: `MainShellController`, `NotificationBadgeController` di `lib/app/`. Dipakai untuk komunikasi global (mis. Beranda minta pindah tab).
- **Repository pattern**: `ApiRepository` (singleton) membungkus semua panggilan API. Screen tidak pernah panggil `http` langsung.
- **Reusable widgets**: Tombol back, header, chip, dll. ada di `lib/widgets/`.

### State Management
- `setState` untuk state lokal per screen
- `ChangeNotifier` untuk state global (controller di `lib/app/`)
- Tidak pakai Provider/GetX/BLoC agar dependency tetap minimal

### Konvensi Kode
- Lint: `flutter_lints: ^6.0.0` (lihat `analysis_options.yaml`)
- Naming: PascalCase untuk class, snake_case untuk file, camelCase untuk variabel
- Bahasa UI: **Bahasa Indonesia** untuk semua label & pesan

### Roadmap (TODO)
- [ ] Implementasi asli pemindai QR/barcode (paket `mobile_scanner`)
- [ ] Notifikasi push (FCM)
- [ ] Mode offline (cache response API)
- [ ] Dark mode
- [ ] i18n (English/Bahasa Indonesia switch)
- [ ] Upload foto profil
- [ ] Test unit + integration

---

## 👥 Kontributor

- **fkhdz** (Fiko Hilmy Dzaky) — Developer utama

---

## 📄 Lisensi

Proyek internal **SMA Negeri 1 Bumiayu**. Belum dipublikasikan ke publik (`publish_to: 'none'` di `pubspec.yaml`).

---

<div align="center">

**LMS SMANSA Mobile** — dibuat dengan ❤️ menggunakan Flutter untuk siswa-siswi SMA Negeri 1 Bumiayu.

</div>