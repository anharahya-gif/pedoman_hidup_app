import '../../../../core/network/api_client.dart';
import '../models/surah_model.dart';
import '../models/ayat_model.dart';
import '../models/tafsir_model.dart';

class QuranRemoteDataSource {
  final ApiClient _apiClient;

  QuranRemoteDataSource(this._apiClient);

  Future<List<SurahModel>> getSurahList() async {
    final List<dynamic> data = await _apiClient.get('/surat');
    return data.map((json) => SurahModel.fromJson(json)).toList();
  }

  Future<List<AyatModel>> getSurahDetail(int surahNumber) async {
    final Map<String, dynamic> data = await _apiClient.get('/surat/$surahNumber');
    final List<dynamic> ayatList = data['ayat'] ?? [];
    return ayatList.map((json) => AyatModel.fromJson(json)).toList();
  }

  Future<List<TafsirModel>> getSurahTafsir(int surahNumber) async {
    final Map<String, dynamic> data = await _apiClient.get('/tafsir/$surahNumber');
    final List<dynamic> tafsirList = data['tafsir'] ?? [];
    return tafsirList.map((json) => TafsirModel.fromJson(json)).toList();
  }
}
