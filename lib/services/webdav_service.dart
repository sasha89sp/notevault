import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:notevault/config/app_config.dart';
import 'package:path/path.dart' as p;

class WebdavService {
  String? _username;
  String? _password;
  final http.Client _http = http.Client();

  String get _baseUrl => '${AppConfig.webdavBase}${AppConfig.webdavDavPath}';
  String get _authHeader {
    final creds = base64Encode(utf8.encode('$_username:$_password'));
    return 'Basic $creds';
  }
  Map<String, String> get _headers => {'Authorization': _authHeader, 'Depth': '1'};
  bool get isConfigured => _username != null && _password != null;

  void configure(String username, String password) { _username = username; _password = password; }
  void clear() { _username = null; _password = null; }

  String _fullUrl(String remotePath) {
    final clean = remotePath.startsWith('/') ? remotePath.substring(1) : remotePath;
    return '$_baseUrl$clean';
  }

  Future<List<String>> listDir(String remotePath) async {
    final url = Uri.parse(_fullUrl(remotePath));
    final req = http.Request('PROPFIND', url)
      ..headers.addAll({'Authorization': _authHeader, 'Depth': '1', 'Content-Type': 'application/xml'})
      ..body = '''<?xml version="1.0" encoding="utf-8"?>
<d:propfind xmlns:d="DAV:"><d:prop><d:getetag/><d:getlastmodified/><d:getcontentlength/><d:resourcetype/></d:prop></d:propfind>''';
    final resp = await _http.send(req);
    if (resp.statusCode != 207) throw WebdavException('PROPFIND failed: ${resp.statusCode}', resp.statusCode);
    final xml = await resp.stream.bytesToString();
    return _parsePropfind(xml, remotePath);
  }

  List<String> _parsePropfind(String xml, String basePath) {
    final hrefs = <String>[];
    final re = RegExp(r'<[a-z]+:href[^>]*>([^<]+)</[a-z]+:href>', caseSensitive: false);
    for (final m in re.allMatches(xml)) {
      var href = Uri.decodeFull(m.group(1)!);
      if (href.startsWith(AppConfig.webdavDavPath)) href = href.substring(AppConfig.webdavDavPath.length - 1);
      if (href != basePath && href.startsWith(basePath)) hrefs.add(href);
    }
    return hrefs;
  }

  Future<Uint8List> download(String remotePath) async {
    final url = Uri.parse(_fullUrl(remotePath));
    final resp = await _http.get(url, headers: {'Authorization': _authHeader});
    if (resp.statusCode != 200) throw WebdavException('GET failed: ${resp.statusCode}', resp.statusCode);
    return resp.bodyBytes;
  }

  Future<DownloadResult?> downloadWithEtag(String remotePath, String? localEtag) async {
    final url = Uri.parse(_fullUrl(remotePath));
    final headers = <String, String>{'Authorization': _authHeader};
    if (localEtag != null) headers['If-None-Match'] = '"$localEtag"';
    final resp = await _http.get(url, headers: headers);
    if (resp.statusCode == 304) return null;
    if (resp.statusCode != 200) throw WebdavException('GET failed: ${resp.statusCode}', resp.statusCode);
    return DownloadResult(bytes: resp.bodyBytes, etag: resp.headers['etag']?.replaceAll('"', ''));
  }

  Future<String?> upload(String remotePath, Uint8List bytes, {String? etag}) async {
    final url = Uri.parse(_fullUrl(remotePath));
    final headers = <String, String>{'Authorization': _authHeader, 'Content-Type': 'application/octet-stream'};
    if (etag != null) headers['If-Match'] = '"$etag"';
    final resp = await _http.put(url, headers: headers, body: bytes);
    if (resp.statusCode != 200 && resp.statusCode != 201 && resp.statusCode != 204)
      throw WebdavException('PUT failed: ${resp.statusCode}', resp.statusCode);
    return resp.headers['etag']?.replaceAll('"', '');
  }

  Future<void> delete(String remotePath) async {
    final url = Uri.parse(_fullUrl(remotePath));
    final resp = await _http.delete(url, headers: {'Authorization': _authHeader});
    if (resp.statusCode != 204 && resp.statusCode != 200 && resp.statusCode != 404)
      throw WebdavException('DELETE failed: ${resp.statusCode}', resp.statusCode);
  }

  Future<void> mkdir(String remotePath) async {
    final url = Uri.parse(_fullUrl(remotePath));
    final resp = await http.Client().send(http.Request('MKCOL', url)..headers['Authorization'] = _authHeader);
    if (resp.statusCode != 201 && resp.statusCode != 405)
      throw WebdavException('MKCOL failed: ${resp.statusCode}', resp.statusCode);
  }

  Future<bool> exists(String remotePath) async {
    try {
      final url = Uri.parse(_fullUrl(remotePath));
      final resp = await _http.head(url, headers: {'Authorization': _authHeader});
      return resp.statusCode == 200;
    } catch (_) { return false; }
  }

  void dispose() => _http.close();
}

class WebdavEntry {
  final String path; final String name; final bool isDirectory;
  final String? etag; final int size; final DateTime? modified;
  const WebdavEntry({required this.path, required this.name, required this.isDirectory,
    this.etag, required this.size, this.modified});
}

class DownloadResult {
  final Uint8List bytes; final String? etag;
  const DownloadResult({required this.bytes, this.etag});
}

class WebdavException implements Exception {
  final String message; final int statusCode;
  WebdavException(this.message, this.statusCode);
  @override String toString() => 'WebdavException($statusCode): $message';
}
