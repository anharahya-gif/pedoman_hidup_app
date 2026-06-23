# Rujukan Migrasi & Penggabungan Aplikasi (Pedoman Hidup)

Dokumen ini dibuat sebagai panduan rujukan untuk Agen AI di Antigravity IDE untuk melanjutkan pengembangan proyek ini.

## 1. Latar Belakang & Tujuan
Menggabungkan dua aplikasi Flutter yang berada di `H:\Flutter Project\` menjadi satu aplikasi Islami besar bernama **Pedoman Hidup**:
1. **[LearningAlQuranApp](file:///H:/Flutter%20Project/LearningAlQuranApp)**: Memiliki fitur utama membaca Al-Quran, audio murattal (`just_audio`), tafsir, dan bookmark (semula menggunakan **BLoC**).
2. **[HabitTrackerApp](file:///H:/Flutter%20Project/HabitTrackerApp)**: Memiliki fitur **Ibadah Hub** (jadwal shalat berdasarkan lokasi, log checklist ibadah harian, dan kumpulan doa/dzikir) (semula menggunakan **Riverpod**).

## 2. Keputusan Arsitektur Utama (Hasil Diskusi)
- **State Management**: **Riverpod** dipilih sebagai satu-satunya state management di aplikasi baru karena fleksibilitasnya.
  * *Konsekuensi*: Fitur Al-Quran yang sebelumnya menggunakan BLoC (`QuranBloc`, dll.) akan ditulis ulang/dimigrasikan ke Riverpod Providers. Fitur Ibadah yang sudah menggunakan Riverpod dapat langsung diintegrasikan.
- **Strategi Data & Autentikasi**: Memulai secara **Offline-First** menggunakan SQLite (`sqflite`) lokal dan `shared_preferences`. Autentikasi Firebase ditunda terlebih dahulu agar integrasi fitur inti berjalan lebih cepat.
- **Penyederhanaan Fitur**: Sistem gamifikasi (poin/level) dari HabitTrackerApp untuk sementara **dihapus/tidak disertakan** agar aplikasi baru lebih fokus pada esensi ibadah murni.

## 3. Status Terkini Proyek
- Proyek baru telah diinisialisasi menggunakan Flutter CLI di folder: [pedoman_hidup_app](file:///H:/Flutter%20Project/pedoman_hidup_app/).
- Repositori Git lokal telah diinisialisasi (`git init`) dan telah dilakukan commit pertama (*Initial commit*).
- File pelacak tugas tersedia di [task.md](file:///C:/Users/Anhar%20Ahya/.gemini/antigravity/brain/57cd2009-cfbb-43c1-b4ae-e69d2e070783/task.md) dan catatan perubahan awal di [walkthrough.md](file:///C:/Users/Anhar%20Ahya/.gemini/antigravity/brain/57cd2009-cfbb-43c1-b4ae-e69d2e070783/walkthrough.md).

## 4. Langkah Selanjutnya (Untuk Agen Antigravity IDE)

### Langkah 1: Hubungkan ke GitHub
Pengguna akan menjalankan perintah berikut secara manual di folder [pedoman_hidup_app](file:///H:/Flutter%20Project/pedoman_hidup_app/):
```powershell
git remote add origin <URL_REPO_GITHUB_ANDA>
git push -u origin main
```

### Langkah 2: Menggabungkan `pubspec.yaml`
Gabungkan paket dependencies dari kedua proyek lama ke [pubspec.yaml proyek baru](file:///H:/Flutter%20Project/pedoman_hidup_app/pubspec.yaml):
- Dari Quranify: `just_audio`, `audio_session`, `shimmer`, `flutter_svg`, `http`
- Dari HabitTracker: `flutter_riverpod`, `sqflite`, `path`, `uuid`, `share_plus`, `google_fonts`, `flutter_local_notifications`, `timezone`, `flutter_timezone`

### Langkah 3: Gabungkan Database Lokal
Buat `DatabaseHelper` tunggal di `lib/core/database/` yang menangani skema gabungan (tabel bookmark ayat dari Quranify & tabel log ibadah serta doa favorit dari HabitTracker).

### Langkah 4: Migrasikan Fitur Quran ke Riverpod
Konversikan logika bisnis Quran (semula di `quran/presentation/bloc/`) menjadi Riverpod providers.

### Langkah 5: Migrasikan Fitur Ibadah
Salin folder `features/ibadah` dari HabitTrackerApp ke proyek baru, sesuaikan referensi kodenya dan hapus ketergantungan pada controller dashboard/gamifikasi.

### Langkah 6: UI & Navigasi Utama
Buat halaman navigasi utama menggunakan `BottomNavigationBar` untuk menghubungkan Dashboard, Al-Quran, Ibadah Hub, Doa/Dzikir, dan Settings.
