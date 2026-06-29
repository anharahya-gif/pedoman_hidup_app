import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/ambient_lights.dart';
import '../controllers/chatbot_controller.dart';

class ChatbotPage extends ConsumerStatefulWidget {
  const ChatbotPage({super.key});

  @override
  ConsumerState<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends ConsumerState<ChatbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _keyController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _launchApiStudioUrl() async {
    final Uri url = Uri.parse('https://aistudio.google.com/');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      ref.read(chatbotControllerProvider.notifier).sendMessage(text);
      _messageController.clear();
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    }
  }

  void _showChangeKeyDialog(String currentKey) {
    _keyController.text = currentKey;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Pengaturan API Key',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Masukkan API Key Gemini baru Anda:',
              style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _keyController,
              decoration: const InputDecoration(
                hintText: 'AIzaSy...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(chatbotControllerProvider.notifier).deleteApiKey();
              Navigator.pop(context);
            },
            child: const Text('Hapus Key', style: TextStyle(color: Colors.redAccent)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final newKey = _keyController.text.trim();
              if (newKey.isNotEmpty) {
                ref.read(chatbotControllerProvider.notifier).saveApiKey(newKey);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff0b3b24),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatbotControllerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const primaryEmerald = Color(0xff0b3b24);
    const accentGold = Color(0xffd4af37);
    final bgColor = isDark ? const Color(0xff070c09) : const Color(0xfff3f6f4);
    final glassColor = isDark
        ? const Color(0xff121814).withValues(alpha: 0.8)
        : Colors.white.withValues(alpha: 0.9);

    final textPrimary = isDark ? Colors.white : Colors.black87;
    final textSecondary = isDark ? Colors.white60 : Colors.black54;

    // Trigger auto-scroll when a new message is received or loading state changes
    ref.listen(chatbotControllerProvider, (prev, next) {
      if (prev?.messages.length != next.messages.length || prev?.isLoading != next.isLoading) {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    });

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Asisten AI Spiritual',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        actions: null,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const AmbientLights(),
            _buildUnderDevelopmentView(context, isDark, textPrimary, textSecondary, glassColor, primaryEmerald, accentGold),
          ],
        ),
      ),
    );
  }

  Widget _buildUnderDevelopmentView(
    BuildContext context,
    bool isDark,
    Color textPrimary,
    Color textSecondary,
    Color glassColor,
    Color primaryEmerald,
    Color accentGold,
  ) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: glassColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.02),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryEmerald.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: accentGold.withOpacity(0.3), width: 1.5),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xffd4af37),
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Tanya AI Ustadz',
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'FITUR DALAM PENGEMBANGAN 🛠️',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xffd4af37),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Kami sedang menyiapkan integrasi mesin kecerdasan buatan terpusat (DeepSeek AI) untuk memberikan jawaban spiritual, fiqih, dan tuntunan ibadah yang lebih mendalam, cepat, dan responsif.\n\nDalam rilis pembaruan berikutnya, fitur ini akan langsung dapat diakses secara gratis oleh seluruh pengguna tanpa perlu memasukkan API Key secara mandiri. Nantikan rilis selanjutnya!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: Text(
                    'Kembali ke Utama',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryEmerald,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingView(
    BuildContext context,
    bool isDark,
    Color textPrimary,
    Color textSecondary,
    Color glassColor,
    Color primaryEmerald,
    Color accentGold,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: primaryEmerald.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: accentGold.withValues(alpha: 0.25), width: 1.5),
            ),
            child: Icon(
              Icons.psychology_rounded,
              color: accentGold,
              size: 64,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Tanya Asisten AI',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Konsultasikan seputar adab ibadah, doa harian, dan motivasi spiritual Islami secara gratis dan personal.',
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: glassColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black.withValues(alpha: 0.05), width: 1.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Masukkan API Key Gemini Anda:',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'API Key disimpan dengan aman secara lokal di memori perangkat Anda.',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _keyController,
                  style: TextStyle(color: textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'AIzaSy...',
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                    filled: true,
                    fillColor: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.03),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: accentGold),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      final key = _keyController.text.trim();
                      if (key.isNotEmpty) {
                        ref.read(chatbotControllerProvider.notifier).saveApiKey(key);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryEmerald,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Simpan & Mulai Chat',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: _launchApiStudioUrl,
            icon: Icon(Icons.open_in_new_rounded, size: 16, color: accentGold),
            label: Text(
              'Belum punya API Key? Dapatkan Gratis di Sini',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: accentGold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatView(
    BuildContext context,
    ChatbotState state,
    bool isDark,
    Color textPrimary,
    Color textSecondary,
    Color glassColor,
    Color primaryEmerald,
    Color accentGold,
  ) {
    return Column(
      children: [
        // Chat messages list
        Expanded(
          child: state.messages.isEmpty
              ? _buildWelcomeChatState(textPrimary, textSecondary, primaryEmerald)
              : ListView.separated(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  itemCount: state.messages.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    return _buildMessageBubble(context, message, isDark, textPrimary, textSecondary, glassColor, primaryEmerald, accentGold);
                  },
                ),
        ),

        // Typing indicator
        if (state.isLoading)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(accentGold),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Asisten sedang mengetik...',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Error message if any
        if (state.errorMessage.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
            ),
            child: Text(
              state.errorMessage,
              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),

        // Input bar
        _buildInputBar(context, state, isDark, glassColor, primaryEmerald, accentGold),
      ],
    );
  }

  Widget _buildWelcomeChatState(Color textPrimary, Color textSecondary, Color primaryEmerald) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryEmerald.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.forum_outlined, color: Color(0xffd4af37), size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              'Mulai Obrolan Spiritual',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tanyakan apa saja seputar ibadah fardhu/sunnah, bimbingan doa harian, atau tips keistiqomahan rohani. Asisten siap mendampingi Anda.',
              style: TextStyle(
                fontSize: 12,
                color: textSecondary,
                height: 1.45,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(
    BuildContext context,
    ChatMessage message,
    bool isDark,
    Color textPrimary,
    Color textSecondary,
    Color glassColor,
    Color primaryEmerald,
    Color accentGold,
  ) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: primaryEmerald.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: accentGold.withValues(alpha: 0.2), width: 1),
              ),
              child: Icon(Icons.psychology_rounded, color: accentGold, size: 18),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? primaryEmerald
                    : glassColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isUser ? const Radius.circular(20) : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(20),
                ),
                border: Border.all(
                  color: isUser
                      ? accentGold.withValues(alpha: 0.2)
                      : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05)),
                  width: 1,
                ),
                boxShadow: isUser
                    ? [
                        BoxShadow(
                          color: primaryEmerald.withValues(alpha: 0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      height: 1.45,
                      color: isUser ? Colors.white : textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                      style: GoogleFonts.outfit(
                        fontSize: 9,
                        color: isUser ? Colors.white60 : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: accentGold.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_rounded, color: accentGold, size: 18),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputBar(
    BuildContext context,
    ChatbotState state,
    bool isDark,
    Color glassColor,
    Color primaryEmerald,
    Color accentGold,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: glassColor,
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                ),
              ),
              child: TextField(
                controller: _messageController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13.5),
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Tanyakan panduan ibadah...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.5),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: state.isLoading ? null : _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: state.isLoading ? Colors.grey : primaryEmerald,
                shape: BoxShape.circle,
                border: Border.all(color: accentGold.withValues(alpha: 0.3), width: 1),
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
