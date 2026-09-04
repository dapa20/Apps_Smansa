import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

/// Exception khusus untuk error API dengan pesan yang bisa ditampilkan.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? code;

  ApiException(this.message, {this.statusCode, this.code});

  @override
  String toString() => message;
}

/// Klien HTTP untuk memanggil API backend.
///
/// Mengirim token pada header `Authorization: Bearer <token>` (jika ada).
/// Semua method mengembalikan `Map<String, dynamic>` hasil parsing JSON.
class ApiClient {
  ApiClient({String? token}) : _token = token;

  String? _token;

  /// Token aktif (null jika belum login).
  String? get token => _token;

  /// Ganti token aktif (dipakai saat login/logout).
  set token(String? value) => _token = value;

  Map<String, String> get _headers {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Uri _uri(String path, [Map<String, String>? query]) {
    return Uri.parse(
      '${ApiConfig.apiPath}$path',
    ).replace(queryParameters: query);
  }

  /// GET request.
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? query,
  }) async {
    final res = await http.get(_uri(path, query), headers: _headers);
    return _decode(res);
  }

  /// POST request (JSON body).
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? query,
  }) async {
    final res = await http.post(
      _uri(path, query),
      headers: _headers,
      body: jsonEncode(body ?? {}),
    );
    return _decode(res);
  }

  /// POST request dengan multipart (untuk upload file tugas).
  Future<Map<String, dynamic>> postMultipart(
    String path, {
    Map<String, String>? fields,
    Map<String, http.MultipartFile>? files,
  }) async {
    final request = http.MultipartRequest('POST', _uri(path));
    request.headers.addAll(_headers);
    fields?.forEach((k, v) => request.fields[k] = v);
    files?.forEach((k, v) => request.files.add(v));
    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    return _decode(res);
  }

  Map<String, dynamic> _decode(http.Response res) {
    Map<String, dynamic>? json;
    try {
      json = jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {
      json = null;
    }

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return json ?? {'success': true, 'data': null};
    }

    final message = json?['message'] ?? 'Terjadi kesalahan pada server.';
    throw ApiException(
      message as String,
      statusCode: res.statusCode,
      code: json?['code'] as String?,
    );
  }
}
