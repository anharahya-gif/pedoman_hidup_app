import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _client;
  static const String baseUrl = 'https://equran.id/api/v2';

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<dynamic> get(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    try {
      final response = await _client.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['code'] == 200) {
          return body['data'];
        } else {
          throw ApiException(body['message'] ?? 'Gagal mengambil data dari API');
        }
      } else {
        throw ApiException('Koneksi server error (Status: ${response.statusCode})');
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Koneksi internet bermasalah. Harap periksa jaringan Anda.');
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
