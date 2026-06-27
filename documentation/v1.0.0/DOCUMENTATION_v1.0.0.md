# 🌙 Dokumentasi Aplikasi Pedoman Hidup — ver 1.0.0

Aplikasi Islami lengkap yang menggabungkan fitur Al-Quran, log harian Ibadah Hub, serta Kumpulan Doa & Dzikir, dirancang dengan antarmuka premium bertema **Emerald Green & Gold** dan efek **Ambient Light Glow** yang elegan.

---

## 📱 Ringkasan Proyek
- **Nama Aplikasi**: Pedoman Hidup
- **Versi**: 1.0.0
- **Platform**: Android & iOS
- **Bahasa & Framework**: Dart (Flutter)
- **Tipe Penyimpanan**: Offline-First (Local Database SQLite & Shared Preferences)

---

## 🛠️ Arsitektur & Teknologi

Aplikasi ini dibangun menggunakan prinsip **Clean Architecture** yang terbagi menjadi 3 lapisan utama pada setiap fiturnya:
1. **Data Layer**: Menangani interaksi sumber data eksternal (API HTTP/Local DB) dan implementasi repositori.
2. **Domain Layer**: Berisi entitas bisnis inti (Entities) dan kontrak repositori yang murni bebas dari framework.
3. **Presentation Layer**: UI widget, halaman, dan pengatur status tampilan menggunakan Riverpod Providers.

### Stack Teknologi Inti:
- **State Management**: [Riverpod](https://pub.dev/packages/flutter_riverpod) (Tunggal & terpusat)
- **Penyimpanan Lokal**: 
  - `sqflite` (SQLite) untuk data terstruktur seperti bookmark ayat dan log riwayat ibadah.
  - `shared_preferences` untuk pengaturan user & caching data sederhana.
- **Audio Engine**: `just_audio` & `audio_session` untuk memutar Murattal per ayat secara dinamis.
- **Render Aset**: `flutter_svg` untuk render asset berformat SVG secara tajam.

---

## ✨ Fitur Utama (v1.0.0)

### 1. Fitur Al-Quran
- **Daftar Surah & Detail**: Membaca Al-Quran 30 Juz secara offline dengan teks Arab (`Scheherazade New`) dan terjemahan bahasa Indonesia (`Plus Jakarta Sans`).
- **Tafsir Lengkap**: Penjelasan tafsir detail per ayat.
- **Audio Murattal**: Memutar lantunan ayat Al-Quran langsung per ayat dengan player controller yang mulus.
- **Tanda Baca Tajwid**: Panduan belajar tajwid terintegrasi.
- **Bookmark Ayat**: Menyimpan ayat favorit langsung ke database lokal.

### 2. Fitur Ibadah Hub
- **Checklist Ibadah Harian**: Melacak catatan ibadah wajib dan sunnah (Shalat 5 waktu, Dhuha, Tahajjud, dll.) yang disimpan ke database lokal.
- **Jadwal Shalat**: Informasi waktu shalat harian terintegrasi.
- **Kumpulan Doa & Dzikir**: 
  - Doa harian lengkap.
  - Dzikir & Doa setelah Shalat Fardhu.

### 3. Tampilan Premium (UI/UX)
- **Ambient Light Glow**: Gradasi pendaran cahaya hijau-emas yang menawan di belakang konten (aktif secara global pada Dark Mode).
- **Notched Navigation Bar**: Navigasi bawah melengkung modern dengan Floating Action Button (FAB) di tengah.
- **FAB Kustom**: Tombol tengah navigasi bawah berbentuk lingkaran dengan logo bintang 16 emas bersinar di atas warna hijau emerald `#0A4128`.

---

## 🎨 Spesifikasi Logo & Aset Visual

Logo resmi **Pedoman Hidup** menggunakan desain geometri matematika islami yang sangat presisi:
- **Konstruksi**: 4 persegi konsentris berukuran *Large*, *Medium*, dan *Small* yang diputar bertahap (`0°`, `22.5°`, `45°`, `67.5°`) membentuk Bintang 16 Sudut yang dinamis.
- **Glow Gradient**: Warna emas berkilau (`#FFF3B3` ke `#D4AF37` dan `#9E7810`) dengan efek pendaran cahaya (*shining gradient*) putih di pusatnya yang menyebar ke sisi luar.
- **Background**: Warna hijau emerald matte solid (`#0A4128`).
- **Penerapan**:
  - File Vector SVG: [assets/images/logo.svg](file:///h:/Flutter%20Project/pedoman_hidup_app/assets/images/logo.svg)
  - File Raster PNG: [assets/images/logo.png](file:///h:/Flutter%20Project/pedoman_hidup_app/assets/images/logo.png)
  - Digunakan sebagai **App Launcher Icon** Android & iOS dan logo FAB menu utama.

---

## 🚀 Cara Menjalankan Project

### 1. Unduh Dependensi
Jalankan perintah berikut di root folder proyek:
```bash
flutter pub get
```

### 2. Jalankan Generator Launcher Icon (Opsional)
Jika ingin merestore kembali launcher icon dari logo gambar:
```bash
flutter pub run flutter_launcher_icons
```

### 3. Jalankan Aplikasi ke Device/Emulator
```bash
flutter run
```

---

## 📌 Informasi Tag Git
Versi rilis ini ditandai menggunakan Git Tag:
- **Tag**: `v1.0.0`
- **Tujuan**: Menandai rilis versi pertama (v1.0.0) yang stabil dengan integrasi Al-Quran, Ibadah Hub, dan UI/UX bertema Emerald Gold yang baru.
