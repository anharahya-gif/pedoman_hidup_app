# 🌙 Pedoman Hidup

[![Flutter Version](https://img.shields.io/badge/Flutter-^3.12.0-blue.svg)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-lightgrey.svg)](#)
[![Version](https://img.shields.io/badge/Version-1.0.0-gold.svg)](#)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](#)

Aplikasi Islami Lengkap modern dan premium yang dirancang untuk membantu umat Islam menjaga kualitas ibadah harian. Menggabungkan fitur **Al-Quran**, **Ibadah Hub** (Checklist Ibadah Harian & Jadwal Shalat), serta **Kumpulan Doa & Dzikir** di bawah satu antarmuka bertema **Emerald Green & Gold** yang elegan dengan efek pendaran cahaya (**Ambient Light Glow**) yang menawan.

---

## 🎨 Antarmuka & Desain Premium
Aplikasi ini menerapkan standar estetika **Islamic Premium Dark Theme**:
*   **Warna Utama**: Hijau Forest Emerald (`#0A4128`) dan Emas Murni (`#D4AF37`).
*   **Ambient Light**: Efek cahaya berpendar lembut di belakang konten untuk kenyamanan mata saat membaca di malam hari.
*   **Logo Resmi**: Desain geometri Bintang 16 Sudut (Islamic Geometric Star) konsentris tebal berlapis gradasi emas bersinar.

---

## ✨ Fitur Utama

### 1. 📖 Al-Quran Al-Karim
*   **Baca Offline**: Teks Arab (`Scheherazade New`) dan Terjemahan Indonesia (`Plus Jakarta Sans`) lengkap 30 Juz secara offline.
*   **Tafsir**: Penjelasan tafsir mendalam untuk tiap-tiap ayat.
*   **Audio Murattal**: Pemutar audio per ayat yang responsif menggunakan engine `just_audio`.
*   **Bookmark**: Simpan ayat-ayat favorit langsung ke penyimpanan lokal.
*   **Pelajaran Tajwid**: Panduan tanda baca tajwid terintegrasi untuk menyempurnakan bacaan.

### 2. 🕌 Ibadah Hub
*   **Log Ibadah Harian**: Checklist pelacakan ibadah harian wajib dan sunnah (Shalat 5 waktu, Dhuha, Tahajjud, dll.) berbasis database lokal.
*   **Jadwal Shalat**: Waktu shalat harian akurat berdasarkan zonasi wilayah pengguna.
*   **Kumpulan Doa & Dzikir**:
    *   Kumpulan doa harian populer lengkap dengan teks Arab, transliterasi, dan terjemahan.
    *   Panduan Dzikir dan Doa setelah Shalat Fardhu.

### 3. ⚙️ Pengaturan & Kustomisasi
*   Pengaturan ukuran teks ayat Al-Quran.
*   Pemberitahuan waktu shalat.
*   Penyimpanan aman berbasis database SQLite offline (`sqflite`).

---

## 🛠️ Stack Teknologi

Aplikasi ini dikembangkan dengan pendekatan **Clean Architecture** (Data, Domain, Presentation) untuk kode yang terstruktur, mudah diuji, dan dipelihara:
*   **Framework**: [Flutter SDK](https://flutter.dev) (Dart)
*   **State Management**: [Riverpod (flutter_riverpod)](https://pub.dev/packages/flutter_riverpod)
*   **Local Database**: [sqflite](https://pub.dev/packages/sqflite) (SQLite untuk data bookmark & checklist ibadah)
*   **Key-Value Storage**: [shared_preferences](https://pub.dev/packages/shared_preferences)
*   **Audio Engine**: [just_audio](https://pub.dev/packages/just_audio) & [audio_session](https://pub.dev/packages/audio_session)
*   **Vector Engine**: [flutter_svg](https://pub.dev/packages/flutter_svg)

---

## 📂 Struktur Direktori Proyek

```text
lib/
├── core/
│   ├── database/         # Pengaturan SQLite & Helper
│   ├── theme/            # Desain Sistem & Tema Ambient Glow
│   └── utils/            # Audio Player & Notification Helper
├── features/
│   ├── dashboard/        # Halaman Beranda Utama
│   ├── quran/            # Fitur Membaca Al-Quran, Tafsir, & Tajwid
│   ├── ibadah/           # Ibadah Hub, Jadwal Shalat, & Doa
│   ├── navigation/       # Main Notched Navigation Bar
│   └── settings/         # Pengaturan & Kustomisasi App
├── shared/               # Providers & Widget Bersama
└── main.dart             # Entry Point Aplikasi
```

---

## 🚀 Cara Memulai

### Prasyarat
*   [Flutter SDK](https://flutter.dev/docs/get-started/install) versi terbaru (Direkomendasikan versi `^3.12.0`).
*   Android Studio / Xcode beserta Emulator/Simulator terinstal.

### Instalasi Langkah Demi Langkah

1.  **Clone Repositori**
    ```bash
    git clone https://github.com/anharahya-gif/pedoman_hidup_app.git
    cd pedoman_hidup_app
    ```

2.  **Unduh Dependensi**
    ```bash
    flutter pub get
    ```

3.  **Generate Launcher Icon (Opsional)**
    Jika kamu memodifikasi aset logo dan ingin memperbarui icon aplikasi:
    ```bash
    flutter pub run flutter_launcher_icons
    ```

4.  **Jalankan Aplikasi**
    ```bash
    flutter run
    ```

---

## 📄 Lisensi
Hak cipta dilindungi undang-undang. Didistribusikan di bawah lisensi MIT. Lihat file `LICENSE` untuk informasi lebih lanjut.

## 👥 Kontributor
*   **Anhar Ahya** — *Inisiator & Lead Developer*
