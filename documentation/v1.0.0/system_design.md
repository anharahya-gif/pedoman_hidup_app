# 📐 Dokumen Perancangan Sistem (System Design Document)
## 🌙 Pedoman Hidup App — Versi 1.0.0

Dokumen ini berisi spesifikasi perancangan sistem formal untuk **Pedoman Hidup App** versi 1.0.0 yang mencakup **Use Case Diagram & Spesifikasi**, **Data Flow Diagram (DFD) Level 0 & 1**, serta **Entity Relationship Diagram (ERD)** detail.

---

## 🎭 1. Use Case Diagram (v1.0.0)

Pada versi 1.0.0, aplikasi berjalan sepenuhnya offline tanpa fitur autentikasi cloud.

```mermaid
usecaseDiagram
    %% Actors
    actor Pengguna as "Pengguna (Muslim)"

    %% Use Cases
    usecase UC01 as "UC01: Membaca Al-Quran & Tafsir"
    usecase UC02 as "UC02: Memutar Audio Murattal per Ayat"
    usecase UC03 as "UC03: Bookmark Ayat Terpilih"
    usecase UC04 as "UC04: Belajar Huruf Hijaiyah & Tajwid"
    usecase UC05 as "UC05: Mengikuti Kuis Pemahaman"
    usecase UC06 as "UC06: Mencatat Log Checklist Ibadah"
    usecase UC07 as "UC07: Membaca Doa & Dzikir Harian"

    %% Relationships
    Pengguna --> UC01
    Pengguna --> UC02
    Pengguna --> UC03
    Pengguna --> UC04
    Pengguna --> UC05
    Pengguna --> UC06
    Pengguna --> UC07
```

---

## 🔄 2. Data Flow Diagram (DFD v1.0.0)

### 2.1 DFD Level 0 (Diagram Konteks)
Diagram konteks awal hanya berinteraksi dengan satu entitas luar (Pengguna) karena pengoperasian yang bersifat lokal.

```mermaid
graph LR
    User["Aktor: Pengguna (Muslim)"]
    App("(Proses 0.0)<br/>Aplikasi Pedoman Hidup v1.0.0")

    User -->|Input Log Ibadah, Simpan Bookmark, Reset Dzikir| App
    App -->|Tampilan Quran, Jadwal Shalat, Statistik Ibadah, Doa Harian| User
```

### 2.2 DFD Level 1
DFD Level 1 menjabarkan modul fungsional utama versi 1.0.0.

```mermaid
graph TD
    User[Pengguna]

    %% Data Stores
    subcopy["Data Store: SharedPreferences"]
    subdb[("Data Store: SQLite (pedoman_hidup.db v1)")]

    %% Processes
    P1["(Proses 1.0)<br/>Manajemen Al-Quran & Belajar"]
    P2["(Proses 2.0)<br/>Tracker Ibadah Hub"]
    P3["(Proses 3.0)<br/>Kumpulan Doa & Dzikir"]

    %% Flows P1
    User -->|Pencarian Surah & Baca| P1
    P1 -->|Simpan Bookmark & Last Read| subdb
    subdb -->|Kueri Surah & Tafsir| P1
    P1 -->|Tampilan Quran & Suara Qari| User

    %% Flows P2
    User -->|Centang Checklist Ibadah| P2
    P2 -->|Simpan Log Harian| subdb
    subdb -->|Kueri Log & Streak| P2
    P2 -->|Indikator Dots & Streak Dashboard| User

    %% Flows P3
    User -->|Akses Doa & Tasbih Digital| P3
    P3 -->|Simpan Doa Favorit| subdb
    subdb -->|Ambil Doa Harian| P3
    P3 -->|Tampilan Doa & Hitungan Tasbih| User
```

---

## 🗄️ 3. Entity Relationship Diagram (ERD v1.0.0)

### 3.1 Logical ERD (Diagram Mermaid)

```mermaid
erDiagram
    BOOKMARK {
        int id PK
        int surah_number
        string surah_name
        int verse_number
        string created_at
    }

    LAST_READ {
        int id PK
        int surah_number
        string surah_name
        int verse_number
        string verse_text_latin
        string created_at
    }

    PRAYER_TIME {
        string id PK
        string date
        string city
        string fajr
        string dhuhr
        string asr
        string maghrib
        string isha
        string updated_at
    }

    IBADAH_LOG {
        string id PK
        string date UK
        string subuh
        string dzuhur
        string ashar
        string maghrib
        string isya
        int quran_pages
        int dhikr_count
        int duha
        int tahajjud
        int sedekah
        string updated_at
    }

    FAVORITE_DOA {
        string doa_id PK
        string saved_at
    }
```
Dokumen perancangan awal (v1.0.0) diarsipkan dengan aman untuk melacak sejarah struktural sistem.
