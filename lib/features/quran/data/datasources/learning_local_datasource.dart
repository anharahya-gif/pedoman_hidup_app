class HijaiyahModel {
  final String name;
  final String arabic;
  final String makhraj;
  final String audioUrl;
  final String isolated;
  final String initial;
  final String medial;
  final String finalForm;

  const HijaiyahModel({
    required this.name,
    required this.arabic,
    required this.makhraj,
    required this.audioUrl,
    required this.isolated,
    required this.initial,
    required this.medial,
    required this.finalForm,
  });
}

class TajweedLessonModel {
  final String title;
  final String category;
  final String content;
  final String examples;

  const TajweedLessonModel({
    required this.title,
    required this.category,
    required this.content,
    required this.examples,
  });
}

class QuizQuestionModel {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  const QuizQuestionModel({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}

class LearningLocalDataSource {
  static const List<HijaiyahModel> hijaiyahList = [
    HijaiyahModel(
      name: 'Alif',
      arabic: 'ا',
      makhraj: 'Keluar dari rongga mulut (Jauf), dibaca sebagai suara panjang.',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/1_alif.mp3',
      isolated: 'ا',
      initial: 'ا',
      medial: 'ـا',
      finalForm: 'ـا',
    ),
    HijaiyahModel(
      name: 'Baa',
      arabic: 'ب',
      makhraj: 'Keluar dari pertemuan kedua bibir (atas dan bawah) dengan rapat.',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/2_baa.mp3',
      isolated: 'ب',
      initial: 'بـ',
      medial: 'ـbـ',
      finalForm: 'ـb',
    ),
    HijaiyahModel(
      name: 'Taa',
      arabic: 'ت',
      makhraj: 'Keluar dari ujung lidah bertemu dengan pangkal gigi seri atas.',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/3_taa.mp3',
      isolated: 'ت',
      initial: 'تـ',
      medial: 'ـtـ',
      finalForm: 'ـت',
    ),
    HijaiyahModel(
      name: 'Thaa',
      arabic: 'ث',
      makhraj: 'Keluar dari ujung lidah bertemu dengan ujung gigi seri atas. Dibaca lembut dan agak berdesis.',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/4_thaa.mp3',
      isolated: 'ث',
      initial: 'ثـ',
      medial: 'ـثـ',
      finalForm: 'ـث',
    ),
    HijaiyahModel(
      name: 'Jeem',
      arabic: 'ج',
      makhraj: 'Keluar dari tengah lidah bertemu dengan langit-langit mulut atas.',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/5_jeem.mp3',
      isolated: 'ج',
      initial: 'جـ',
      medial: 'ـجـ',
      finalForm: 'ـج',
    ),
    HijaiyahModel(
      name: 'Haa',
      arabic: 'ح',
      makhraj: 'Keluar dari tenggorokan bagian tengah (Wastul Halqi). Dibaca bersih dan mengalir napas.',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/6_haa.mp3',
      isolated: 'ح',
      initial: 'حـ',
      medial: 'ـحـ',
      finalForm: 'ـح',
    ),
    HijaiyahModel(
      name: 'Khaa',
      arabic: 'خ',
      makhraj: 'Keluar dari tenggorokan bagian atas dekat rongga mulut (Adnal Halqi). Terdengar seperti suara ngorok halus.',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/7_khaa.mp3',
      isolated: 'خ',
      initial: 'خـ',
      medial: 'ـخـ',
      finalForm: 'ـخ',
    ),
    HijaiyahModel(
      name: 'Daal',
      arabic: 'د',
      makhraj: 'Keluar dari ujung lidah bertemu dengan pangkal gigi seri atas (seperti huruf Taa, namun bersuara/bergetar).',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/8_daal.mp3',
      isolated: 'د',
      initial: 'د',
      medial: 'ـd',
      finalForm: 'ـd',
    ),
    HijaiyahModel(
      name: 'Thaal',
      arabic: 'ذ',
      makhraj: 'Keluar dari ujung lidah bertemu dengan ujung gigi seri atas (seperti Thaa, namun bersuara).',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/9_zaal.mp3',
      isolated: 'ذ',
      initial: 'ذ',
      medial: 'ـذ',
      finalForm: 'ـذ',
    ),
    HijaiyahModel(
      name: 'Raa',
      arabic: 'ر',
      makhraj: 'Keluar dari ujung lidah sedikit ke punggung lidah bertemu gusi gigi seri atas. Dibaca getar ringan.',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/10_raa.mp3',
      isolated: 'ر',
      initial: 'ر',
      medial: 'ـر',
      finalForm: 'ـر',
    ),
    HijaiyahModel(
      name: 'Zaay',
      arabic: 'ز',
      makhraj: 'Keluar dari ujung lidah yang diletakkan sejajar di belakang gigi seri bawah. Dibaca mendengung kuat seperti lebah.',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/11_zaa.mp3',
      isolated: 'ز',
      initial: 'ز',
      medial: 'ـز',
      finalForm: 'ـz',
    ),
    HijaiyahModel(
      name: 'Seen',
      arabic: 'س',
      makhraj: 'Keluar dari ujung lidah sejajar di belakang gigi seri bawah (seperti Zaay, namun berdesis tanpa getar).',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/12_seen.mp3',
      isolated: 'س',
      initial: 'سـ',
      medial: 'ـsـ',
      finalForm: 'ـs',
    ),
    HijaiyahModel(
      name: 'Sheen',
      arabic: 'ش',
      makhraj: 'Keluar dari tengah lidah bertemu dengan langit-langit mulut. Dibaca menyebar desis napasnya.',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/13_sheen.mp3',
      isolated: 'ش',
      initial: 'شـ',
      medial: 'ـshـ',
      finalForm: 'ـش',
    ),
    HijaiyahModel(
      name: 'Saad',
      arabic: 'ص',
      makhraj: 'Keluar dari ujung lidah sejajar belakang gigi seri bawah dengan menaikkan pangkal lidah sehingga terdengar tebal.',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/14_saad.mp3',
      isolated: 'ص',
      initial: 'صـ',
      medial: 'ـصـ',
      finalForm: 'ـص',
    ),
    HijaiyahModel(
      name: 'Daad',
      arabic: 'ض',
      makhraj: 'Keluar dari salah satu atau kedua sisi/samping lidah bertemu dengan gigi geraham atas.',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/15_daad.mp3',
      isolated: 'ض',
      initial: 'ضـ',
      medial: 'ـضـ',
      finalForm: 'ـض',
    ),
    HijaiyahModel(
      name: 'Tah',
      arabic: 'ط',
      makhraj: 'Keluar dari ujung lidah bertemu pangkal gigi seri atas dengan menaikkan pangkal lidah (Qalqalah paling tebal).',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/16_taah.mp3',
      isolated: 'ط',
      initial: 'طـ',
      medial: 'ـطـ',
      finalForm: 'ـط',
    ),
    HijaiyahModel(
      name: 'Zah',
      arabic: 'ظ',
      makhraj: 'Keluar dari ujung lidah bertemu ujung gigi seri atas dengan menaikkan pangkal lidah sehingga terdengar tebal.',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/17_zhaa.mp3',
      isolated: 'ظ',
      initial: 'ظـ',
      medial: 'ـظـ',
      finalForm: 'ـظ',
    ),
    HijaiyahModel(
      name: 'Ayn',
      arabic: 'ع',
      makhraj: 'Keluar dari tengah tenggorokan (Wastul Halqi), seperti suara tertekan/bersih.',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/18_ain.mp3',
      isolated: 'ع',
      initial: 'عـ',
      medial: 'ـعـ',
      finalForm: 'ـع',
    ),
    HijaiyahModel(
      name: 'Ghayn',
      arabic: 'غ',
      makhraj: 'Keluar dari tenggorokan bagian atas dekat rongga mulut (Adnal Halqi), dibaca tebal/mengalir.',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/19_ghain.mp3',
      isolated: 'غ',
      initial: 'غـ',
      medial: 'ـغـ',
      finalForm: 'ـg',
    ),
    HijaiyahModel(
      name: 'Faa',
      arabic: 'ف',
      makhraj: 'Keluar dari ujung gigi seri atas bertemu dengan bagian dalam bibir bawah.',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/20_faa.mp3',
      isolated: 'ف',
      initial: 'فـ',
      medial: 'ـfـ',
      finalForm: 'ـf',
    ),
    HijaiyahModel(
      name: 'Qaaf',
      arabic: 'ق',
      makhraj: 'Keluar dari pangkal lidah terdalam bertemu dengan langit-langit mulut yang lunak (dekat tenggorokan).',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/21_qaaf.mp3',
      isolated: 'ق',
      initial: 'قـ',
      medial: 'ـqـ',
      finalForm: 'ـq',
    ),
    HijaiyahModel(
      name: 'Kaaf',
      arabic: 'ك',
      makhraj: 'Keluar dari pangkal lidah sedikit di depan posisi Qaaf, disertai desis napas (Hams).',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/22_kaaf.mp3',
      isolated: 'ك',
      initial: 'كـ',
      medial: 'ـكـ',
      finalForm: 'ـك',
    ),
    HijaiyahModel(
      name: 'Laam',
      arabic: 'ل',
      makhraj: 'Keluar dari ujung tepi lidah hingga akhir ujungnya bertemu gusi gigi seri atas.',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/23_laam.mp3',
      isolated: 'ل',
      initial: 'لـ',
      medial: 'ـلـ',
      finalForm: 'ـل',
    ),
    HijaiyahModel(
      name: 'Meem',
      arabic: 'م',
      makhraj: 'Keluar dari pertemuan bibir atas dan bawah secara ringan disertai dengung hidung (Ghunnah).',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/24_meem.mp3',
      isolated: 'م',
      initial: 'مـ',
      medial: 'ـmـ',
      finalForm: 'ـm',
    ),
    HijaiyahModel(
      name: 'Noon',
      arabic: 'ن',
      makhraj: 'Keluar dari ujung lidah bertemu gusi gigi seri atas (di bawah makhraj Laam) disertai dengung hidung.',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/25_noon.mp3',
      isolated: 'ن',
      initial: 'نـ',
      medial: 'ـnـ',
      finalForm: 'ـn',
    ),
    HijaiyahModel(
      name: 'Waw',
      arabic: 'و',
      makhraj: 'Keluar dari antara dua bibir atas dan bawah dengan membulatkan bibir ke depan.',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/27_waw.mp3',
      isolated: 'و',
      initial: 'و',
      medial: 'ـو',
      finalForm: 'ـو',
    ),
    HijaiyahModel(
      name: 'Haa',
      arabic: 'ه',
      makhraj: 'Keluar dari pangkal tenggorokan terdalam (Aqsal Halqi), dibaca longgar dan mengalir napas.',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/26_haah.mp3',
      isolated: 'ه',
      initial: 'هـ',
      medial: 'ـheـ',
      finalForm: 'ـhe',
    ),
    HijaiyahModel(
      name: 'Yaa',
      arabic: 'ي',
      makhraj: 'Keluar dari tengah lidah bertemu langit-langit mulut (dalam keadaan sukun/berharakat).',
      audioUrl: 'https://raw.githubusercontent.com/adnan/Arabic-Alphabet/master/sounds/30_yaa.mp3',
      isolated: 'ي',
      initial: 'يـ',
      medial: 'ـyـ',
      finalForm: 'ـي',
    ),
  ];

  static const List<TajweedLessonModel> lessons = [
    TajweedLessonModel(
      title: 'Hukum Nun Sakinah & Tanwin',
      category: 'Nun Sakinah & Tanwin',
      content: 'Hukum ini berlaku jika Nun Sukun (نْ) atau Tanwin (ً ٍ ٌ) bertemu dengan salah satu huruf hijaiyah. Hukum ini terbagi menjadi 5 jenis utama:\n\n'
          '1. **Izhar Halqi**: Dibaca secara jelas dan terang tanpa dengung sedikit pun ketika bertemu 6 huruf tenggorokan (ء, ه, ع, ح, غ, خ).\n'
          '2. **Idgham Bighunnah**: Memasukkan suara Nun/Tanwin ke huruf berikutnya disertai dengung yang ditahan 2 harakat saat bertemu huruf (ي, ن, m, و).\n'
          '3. **Idgham Bilaghunnah**: Memasukkan suara Nun/Tanwin ke huruf berikutnya tanpa dengung saat bertemu huruf (ل, ر).\n'
          '4. **Iqlab**: Mengubah bunyi Nun/Tanwin menjadi suara Mim sukun disertai dengung ketika bertemu huruf Ba (ب).\n'
          '5. **Ikhfa Haqiqi**: Menyamarkan bunyi Nun/Tanwin di tenggorokan disertai dengung yang ditahan 2 harakat saat bertemu 15 huruf ikhfa.',
      examples: 'مِنْ عِلْمٍ (Izhar), مَنْ يَقُولُ (Idgham Bighunnah), مِنْ رَبِّهِمْ (Idgham Bilaghunnah), مِنْ بَعْدِ (Iqlab), مِنْ تَحْتِهَا (Ikhfa)',
    ),
    TajweedLessonModel(
      title: 'Hukum Mim Sakinah',
      category: 'Mim Sakinah',
      content: 'Hukum ini berlaku jika Mim Sukun (مْ) bertemu dengan salah satu huruf hijaiyah. Hukum ini terbagi menjadi 3 jenis:\n\n'
          '1. **Ikhfa Syafawi**: Menyamarkan bunyi Mim sukun disertai dengung saat bertemu huruf Ba (ب).\n'
          '2. **Idgham Mimi (Mutamatsilain)**: Memasukkan Mim sukun ke Mim berikutnya secara sempurna disertai dengung saat bertemu huruf Mim (م).\n'
          '3. **Izhar Syafawi**: Membaca bunyi Mim sukun secara jelas dan terang tanpa dengung saat bertemu seluruh huruf hijaiyah selain Mim dan Ba.',
      examples: 'تَرْمِيهِمْ بِحِجَارَةٍ (Ikhfa Syafawi), لَهُمْ مَا (Idgham Mimi), أَمْ لَمْ تُن&amp;durh&amp; (Izhar Syafawi)',
    ),
    TajweedLessonModel(
      title: 'Hukum Mad (Panjang Bacaan)',
      category: 'Hukum Mad',
      content: 'Hukum Mad mengatur panjang pendeknya bacaan huruf Al-Quran. Secara umum terbagi menjadi:\n\n'
          '1. **Mad Thabi\'i (Mad Asli)**: Dibaca panjang 2 harakat (Alif setelah Fatha, Waw sukun setelah Damma, Ya sukun setelah Kasra).\n'
          '2. **Mad Wajib Muttasil**: Mad Thabi\'i bertemu Hamza dalam satu kata yang sama. Wajib dibaca panjang 5-6 harakat.\n'
          '3. **Mad Jaiz Munfasil**: Mad Thabi\'i bertemu Hamza di lain kata. Boleh dibaca panjang 2, 4, atau 5 harakat.\n'
          '4. **Mad Lazim**: Mad Thabi\'i bertemu sukun asli atau tasydid dalam satu kata. Wajib dibaca panjang 6 harakat.',
      examples: 'نُوحِيهَا (Mad Thabi\'i), جَاءَ (Mad Wajib), يَا أَيُّهَا (Mad Jaiz), وَلَا الضَّالِّينَ (Mad Lazim)',
    ),
    TajweedLessonModel(
      title: 'Hukum Alif Lam (ال)',
      category: 'Hukum Lam',
      content: 'Hukum Alif Lam berlaku ketika huruf Alif Lam (ال) bertemu dengan huruf Syamsiyah atau Qamariyah:\n\n'
          '1. **Lam Syamsiyah (Idgham Syamsiyah)**: Huruf Lam melebur masuk ke huruf berikutnya dan tidak dibaca. Ditandai dengan tanda tasydid (ّ) pada huruf berikutnya.\n'
          '2. **Lam Qamariyah (Izhar Qamariyah)**: Huruf Lam dibaca secara jelas dan terang. Ditandai dengan tanda sukun (ْ) di atas huruf Lam.',
      examples: 'النَّاس (Lam Syamsiyah), الْحَمْدُ (Lam Qamariyah)',
    ),
    TajweedLessonModel(
      title: 'Hukum Qalqalah (Memantulkan Bunyi)',
      category: 'Qalqalah',
      content: 'Qalqalah adalah memantulkan bunyi huruf qalqalah yang berharakat sukun (baik sukun asli maupun sukun karena waqaf/berhenti). Huruf qalqalah ada 5 yaitu: ق, ط, ب, ج, د (disingkat: Baju Di Toko):\n\n'
          '1. **Qalqalah Sugra (Kecil)**: Pantulan suara ringan/kecil yang terletak di tengah-tengah kata (sukun asli).\n'
          '2. **Qalqalah Kubra (Besar)**: Pantulan suara kuat/besar yang terletak di akhir ayat atau karena berhenti (waqaf).',
      examples: 'يَجْعَلُونَ (Qalqalah Sugra), فَلَقٍ / الْفَلَقِ (Qalqalah Kubra)',
    ),
    TajweedLessonModel(
      title: 'Hukum Ra\' (Tebal & Tipis)',
      category: 'Hukum Ra\'',
      content: 'Membaca huruf Ra (ر) terbagi menjadi dua cara pelafalan utama:\n\n'
          '1. **Tafkhim (Tebal)**: Dibaca tebal dengan menaikkan pangkal lidah. Berlaku jika Ra berharakat Fatha (َ), Damma (ُ), atau Ra sukun didahului Fatha/Damma.\n'
          '2. **Tarqiq (Tipis)**: Dibaca tipis dengan menurunkan pangkal lidah. Berlaku jika Ra berharakat Kasra (ِ), atau Ra sukun didahului Kasra.',
      examples: 'رَبَّنَا (Ra\' Tafkhim), رِجَالٌ (Ra\' Tarqiq)',
    ),
  ];

  static const List<QuizQuestionModel> quizQuestions = [
    QuizQuestionModel(
      questionText: 'Hukum Nun Sukun atau Tanwin ketika bertemu huruf Ba (ب) disebut...',
      options: ['Izhar Halqi', 'Idgham Mimi', 'Iqlab', 'Ikhfa Haqiqi'],
      correctAnswerIndex: 2,
      explanation: 'Iqlab terjadi ketika Nun Sukun atau Tanwin bertemu huruf Ba. Suara nun melebur menjadi suara Mim disertai dengung.',
    ),
    QuizQuestionModel(
      questionText: 'Ada berapa huruf Izhar Halqi?',
      options: ['4 huruf', '6 huruf', '15 huruf', '2 huruf'],
      correctAnswerIndex: 1,
      explanation: 'Ada 6 huruf Izhar Halqi, yaitu Hamzah (ء), Ha (ه), \'Ain (ع), Hah (ح), Ghain (غ), dan Khah (khah/خ).',
    ),
    QuizQuestionModel(
      questionText: 'Hukum bacaan pada penggalan kata \'وَلَا الضَّالِّينَ\' adalah...',
      options: ['Mad Thabi\'i', 'Mad Lazim', 'Mad Jaiz Munfasil', 'Mad Wajib Muttasil'],
      correctAnswerIndex: 1,
      explanation: 'Mad Lazim terjadi karena Mad Thabi\'i bertemu dengan huruf bertasydid dalam satu kata. Harus dibaca panjang 6 harakat.',
    ),
    QuizQuestionModel(
      questionText: 'Huruf Qalqalah ada 5, yang disingkat menjadi...',
      options: ['Baju Di Toko (ب ج د ط ق)', 'Yarmalun (ي ر م ل و ن)', 'Halqi (ء ه ع ح غ خ)', 'Idgham Bilaghunnah'],
      correctAnswerIndex: 0,
      explanation: 'Huruf Qalqalah terdiri dari Ba, Jeem, Dal, Tah, dan Qaf (ب, ج, د, ط, ق).',
    ),
    QuizQuestionModel(
      questionText: 'Bagaimanakah cara membaca Hukum Idgham Bilaghunnah?',
      options: ['Dibaca jelas tanpa mendengung', 'Menyamarkan bacaan', 'Memasukkan bunyi tanpa dengung', 'Memasukkan bunyi dengan dengung'],
      correctAnswerIndex: 2,
      explanation: 'Idgham Bilaghunnah meleburkan Nun Sukun/Tanwin ke huruf Lam atau Ra tanpa dengung sedikit pun.',
    ),
    QuizQuestionModel(
      questionText: 'Jika Mim Sukun bertemu huruf Ba (ب), hukum bacaannya adalah...',
      options: ['Ikhfa Syafawi', 'Izhar Syafawi', 'Idgham Mimi', 'Iqlab'],
      correctAnswerIndex: 0,
      explanation: 'Mim Sukun bertemu Ba disebut Ikhfa Syafawi. Dibaca dengan menyamarkan bunyi Mim dan disertai dengung.',
    ),
    QuizQuestionModel(
      questionText: 'Lam Ta\'rif Qamariyah ditandai dengan...',
      options: ['Adanya tasydid pada huruf berikutnya', 'Huruf Lam berharakat sukun', 'Huruf Lam tidak dibaca', 'Ra bertasydid'],
      correctAnswerIndex: 1,
      explanation: 'Lam Qamariyah dibaca jelas dan ditandai dengan tanda sukun (ْ) di atas huruf Lam (الْ).',
    ),
    QuizQuestionModel(
      questionText: 'Pantulan bunyi huruf Qalqalah yang berada di tengah kata (sukun asli) disebut...',
      options: ['Qalqalah Kubra', 'Qalqalah Akbar', 'Qalqalah Sugra', 'Ghunnah'],
      correctAnswerIndex: 2,
      explanation: 'Qalqalah Sugra adalah pantulan kecil/ringan pada huruf Qalqalah berharakat sukun asli di tengah-tengah kata.',
    ),
    QuizQuestionModel(
      questionText: 'Mad Wajib Muttasil terjadi jika Mad Thabi\'i bertemu Hamza...',
      options: ['Dalam kata yang berbeda', 'Di awal kalimat saja', 'Dalam satu kata yang sama', 'Setelah tanda waqaf'],
      correctAnswerIndex: 2,
      explanation: 'Mad Wajib Muttasil terjadi ketika Mad Thabi\'i bertemu dengan Hamza dalam satu kata. Wajib dibaca panjang 5-6 harakat.',
    ),
    QuizQuestionModel(
      questionText: 'Ra berharakat Kasrah (رِ) dibaca secara...',
      options: ['Tafkhim (Tebal)', 'Tarqiq (Tipis)', 'Dengung', 'Samar'],
      correctAnswerIndex: 1,
      explanation: 'Huruf Ra berharakat Kasra dibaca tipis (Tarqiq) dengan menurunkan pangkal lidah.',
    ),
  ];
}
