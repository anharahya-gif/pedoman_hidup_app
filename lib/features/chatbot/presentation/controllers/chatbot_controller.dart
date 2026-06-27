import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../../shared/providers.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatbotState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? apiKey;
  final String errorMessage;

  ChatbotState({
    this.messages = const [],
    this.isLoading = true,
    this.apiKey,
    this.errorMessage = '',
  });

  ChatbotState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? apiKey,
    String? errorMessage,
  }) {
    return ChatbotState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      apiKey: apiKey ?? this.apiKey,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ChatbotController extends StateNotifier<ChatbotState> {
  final Ref _ref;

  ChatbotController(this._ref) : super(ChatbotState()) {
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    try {
      // 1. Coba dari SharedPreferences
      final prefs = _ref.read(sharedPreferencesProvider);
      final savedKey = prefs.getString('gemini_api_key');
      if (savedKey != null && savedKey.trim().isNotEmpty) {
        state = state.copyWith(apiKey: savedKey.trim(), isLoading: false);
        return;
      }

      // 2. Coba fetch dari Firestore /config/chatbot
      final doc = await FirebaseFirestore.instance.collection('config').doc('chatbot').get();
      if (doc.exists) {
        final data = doc.data();
        final firestoreKey = data?['apiKey'] as String?;
        if (firestoreKey != null && firestoreKey.trim().isNotEmpty) {
          state = state.copyWith(apiKey: firestoreKey.trim(), isLoading: false);
          return;
        }
      }
    } catch (e) {
      print('Error loading API Key from Firestore: $e');
    }
    state = state.copyWith(isLoading: false);
  }

  Future<void> saveApiKey(String key) async {
    final cleaned = key.trim();
    if (cleaned.isEmpty) return;

    try {
      final prefs = _ref.read(sharedPreferencesProvider);
      await prefs.setString('gemini_api_key', cleaned);
      state = state.copyWith(apiKey: cleaned, errorMessage: '');
    } catch (e) {
      state = state.copyWith(errorMessage: 'Gagal menyimpan API Key: $e');
    }
  }

  Future<void> deleteApiKey() async {
    try {
      final prefs = _ref.read(sharedPreferencesProvider);
      await prefs.remove('gemini_api_key');
      state = ChatbotState(); // Reset state completely
    } catch (e) {
      state = state.copyWith(errorMessage: 'Gagal menghapus API Key: $e');
    }
  }

  void clearChatHistory() {
    state = state.copyWith(messages: const []);
  }

  Future<void> sendMessage(String text) async {
    final messageText = text.trim();
    if (messageText.isEmpty || state.apiKey == null) return;

    final userMessage = ChatMessage(
      text: messageText,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // Append user message and trigger loading
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      errorMessage: '',
    );

    try {
      // Initialize Gemini Model with System Instructions
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: state.apiKey!,
        systemInstruction: Content.system(
          "Anda adalah 'Asisten Islami Pedoman Hidup', sebuah chatbot spiritual digital yang ramah, sopan, bijaksana, dan menyejukkan. "
          "Tugas Anda adalah membantu pengguna menjawab pertanyaan seputar ibadah sehari-hari (seperti shalat, puasa, zakat, dzikir, doa), memberikan motivasi beribadah, "
          "menyarankan doa-doa dari Al-Qur'an dan Hadits, serta memberikan nasihat spiritual yang damai dan menyejukkan hati. "
          "Gunakan bahasa Indonesia yang santun, bersahabat, penuh empati, dan menyejukkan. "
          "Selalu kutip referensi dari Al-Qur'an (nama Surah dan Ayat) atau Hadits (nama Periwayat seperti Bukhari, Muslim, Tirmidzi, dll) secara jelas bila Anda memberikan kutipan atau dalil. "
          "Bila ditanya di luar topik agama Islam, adab kehidupan, atau motivasi ibadah, arahkan percakapan secara halus kembali ke ranah spiritual dan ibadah harian."
        ),
      );

      // Map chat messages to Gemini's format to maintain context
      final history = state.messages.map((msg) {
        return Content(
          msg.isUser ? 'user' : 'model',
          [TextPart(msg.text)],
        );
      }).toList();

      // Start chat session with historical context
      final chat = model.startChat(history: history.sublist(0, history.length - 1));
      final response = await chat.sendMessage(Content.text(messageText));

      if (response.text != null && response.text!.isNotEmpty) {
        final assistantMessage = ChatMessage(
          text: response.text!,
          isUser: false,
          timestamp: DateTime.now(),
        );

        state = state.copyWith(
          messages: [...state.messages, assistantMessage],
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal memproses jawaban dari AI.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Terjadi kesalahan saat menghubungi AI. Periksa koneksi internet atau validitas API Key Anda.',
      );
    }
  }
}

final chatbotControllerProvider = StateNotifierProvider<ChatbotController, ChatbotState>((ref) {
  return ChatbotController(ref);
});
