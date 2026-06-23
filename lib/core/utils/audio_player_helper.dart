import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class AudioPlayerHelper {
  static final AudioPlayerHelper _instance = AudioPlayerHelper._internal();
  factory AudioPlayerHelper() => _instance;
  
  AudioPlayerHelper._internal();

  final AudioPlayer _player = AudioPlayer();
  String? _currentPlayingUrl;
  bool _isPlaying = false;
  
  // Callback when state changes (useful for UI updates)
  Function(String? url, bool isPlaying)? onStateChanged;

  AudioPlayer get player => _player;
  String? get currentPlayingUrl => _currentPlayingUrl;
  bool get isPlaying => _isPlaying;

  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    
    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      if (state.processingState == ProcessingState.completed) {
        _isPlaying = false;
        _currentPlayingUrl = null;
      }
      if (onStateChanged != null) {
        onStateChanged!(_currentPlayingUrl, _isPlaying);
      }
    });
  }

  Future<void> play(String url) async {
    try {
      if (_currentPlayingUrl == url && _isPlaying) {
        await pause();
        return;
      }

      if (_currentPlayingUrl == url && !_isPlaying) {
        await _player.play();
        return;
      }

      _currentPlayingUrl = url;
      if (onStateChanged != null) onStateChanged!(url, true);
      
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      stop();
      rethrow;
    }
  }

  Future<void> pause() async {
    await _player.pause();
    _isPlaying = false;
    if (onStateChanged != null) onStateChanged!(_currentPlayingUrl, false);
  }

  Future<void> stop() async {
    await _player.stop();
    _currentPlayingUrl = null;
    _isPlaying = false;
    if (onStateChanged != null) onStateChanged!(null, false);
  }

  void dispose() {
    _player.dispose();
  }
}
