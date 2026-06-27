# 🌙 Dokumentasi Aplikasi Pedoman Hidup — ver 2.0.0

Aplikasi Islami lengkap dan premium yang memadukan akses offline Al-Quran, log harian Ibadah Hub, Kumpulan Doa & Dzikir, serta asisten AI interaktif dan sinkronisasi awan. Didesain dengan antarmuka elegan bertema **Emerald Green & Gold** dan efek **Ambient Light Glow** yang dinamis.

---

## 📱 Ringkasan Proyek
- **Nama Aplikasi**: Pedoman Hidup
- **Versi**: 2.0.0
- **Platform**: Android & iOS
- **Bahasa & Framework**: Dart (Flutter)
- **Tipe Penyimpanan**: Offline-First (Local Database SQLite v2, SharedPreferences, & Cloud Firestore Sync)

---

## 🛠️ Arsitektur & Teknologi

Aplikasi ini dibangun menggunakan prinsip **Clean Architecture** yang terbagi menjadi 3 lapisan utama pada setiap fiturnya:
1. **Data Layer**: Menangani interaksi sumber data eksternal (HTTP API, Local SQLite, SharedPreferences, & Firebase Firestore).
2. **Domain Layer**: Berisi entitas bisnis inti (Entities) dan kontrak repositori yang murni bebas dari framework.
3. **Presentation Layer**: UI widget, halaman, dan pengatur status tampilan menggunakan Riverpod Providers.

### Stack Teknologi Inti:
- **State Management**: [Riverpod](https://pub.dev/packages/flutter_riverpod) (Tunggal & terpusat)
- **Kecerdasan Buatan (AI)**: [Google Generative AI SDK](https://pub.dev/packages/google_generative_ai) (Gemini 1.5 Flash)
- **Otentikasi & Awan**: [Firebase Auth](https://pub.dev/packages/firebase_auth) & [Google Sign-In](https://pub.dev/packages/google_sign_in) untuk login, serta [Cloud Firestore](https://pub.dev/packages/cloud_firestore) untuk pencadangan data otomatis.
- **Penyimpanan Lokal**: 
  - `sqflite` (SQLite v2) untuk bookmark ayat, log riwayat ibadah harian, folder playlist kustom, dan relasi item doa.
  - `shared_preferences` untuk token user, API Key Gemini lokal, dan persistensi playlist terakhir.
- **Audio Engine**: `just_audio` & `audio_session` untuk memutar Murattal per ayat secara dinamis.
- **Render Aset**: `flutter_svg` untuk render asset berformat SVG secara tajam.

---

## ✨ Fitur Utama (v2.0.0)

### 1. Fitur Al-Quran & Pembelajaran
- **Daftar Surah & Detail**: Membaca Al-Quran 30 Juz secara offline dengan teks Arab (`Scheherazade New`) dan terjemahan bahasa Indonesia (`Plus Jakarta Sans`).
- **Tafsir Lengkap**: Penjelasan tafsir detail per ayat.
- **Audio Murattal**: Memutar lantunan ayat Al-Quran langsung per ayat dengan player controller yang mulus.
- **Tanda Baca Tajwid**: Panduan belajar tajwid terintegrasi.
- **Bookmark Ayat**: Menyimpan ayat favorit langsung ke database lokal.
- **Sinkronisasi Otomatis Tilawah (Quran ke Ibadah Hub)**: Menandai ayat sebagai posisi terakhir dibaca secara otomatis menghitung selisih halaman yang dibaca (Mushaf Madinah 604 halaman) dan menambahkannya ke log tracker harian `quran_pages` di Ibadah Hub.

### 2. Fitur Ibadah Hub
- **Checklist Ibadah Harian**: Melacak catatan ibadah wajib (Subuh, Dzuhur, Ashar, Maghrib, Isya) dan sunnah (Dhuha, Tahajjud, Sedekah) yang disimpan ke database lokal.
- **Lencana Istiqomah (Streak Badge)**: Menghitung secara real-time jumlah hari berturut-turut di mana pengguna menyelesaikan checklist ibadah wajib.
- **Jadwal Shalat**: Informasi waktu shalat harian terintegrasi berdasarkan lokasi kota terpilih.

### 3. Kumpulan Doa & Dzikir
- **Kategori Doa**: Doa harian lengkap yang dikelompokkan secara terstruktur.
- **Dzikir Setelah Shalat**: Panduan dzikir lengkap seturut sunnah Nabi SAW setelah shalat fardhu, lengkap dengan tasbih digital langsung di layar.
- **Fitur Playlist Doa Kustom**:
  - Membuat folder/playlist doa buatan sendiri (CRUD).
  - Pilihan playlist doa kustom bersifat persisten (*last pick*), secara otomatis disimpan di `SharedPreferences` sehingga pengguna tidak perlu memilih ulang setiap kali memulai sesi dzikir baru.

### 4. Asisten AI Spiritual (Chatbot)
- **Tanya AI Ustadz**: Chatbot spiritual berbasis Gemini AI untuk konsultasi seputar adab ibadah, doa harian, dan motivasi spiritual Islami.
- **Pemuatan API Key Otomatis**: Mencari API Key di Firestore `/config/chatbot` (field `apiKey`) terlebih dahulu. Jika kosong, mengalihkan ke layar onboarding dengan kotak input manual yang aman (disimpan di SharedPreferences) dan tautan ke Google AI Studio.

### 5. Akun & Sinkronisasi Cloud
- **Google Sign-In**: Masuk akun secara aman dan sinkronisasi otomatis dua arah (Offline-first) seluruh data SQLite lokal ke Cloud Firestore.

### 6. Tampilan Premium (UI/UX)
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
- **Tag**: `v2.0.0`
- **Tujuan**: Menandai rilis versi kedua (v2.0.0) yang stabil dengan penambahan autentikasi Google, sinkronisasi awan Firestore, playlist doa kustom, chatbot Gemini AI, dan auto-sync Quran-Ibadah harian.
