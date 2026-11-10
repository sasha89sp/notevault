import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart' as crypto;
import 'package:crypto/crypto.dart' as std_crypto;
import 'package:convert/convert.dart';
import 'package:notevault/config/app_config.dart';

class CryptoService {
  final _aesGcm = crypto.AesGcm.with256bits();
  final _random = Random.secure();

  Future<crypto.SecretKey> deriveKey(String password, String saltHex) async {
    final salt = hex.decode(saltHex);
    final algorithm = crypto.Pbkdf2(
      macAlgorithm: crypto.Hmac.sha256(),
      iterations: AppConfig.pbkdf2Iterations,
      bits: AppConfig.aesKeyLength * 8,
    );
    return algorithm.deriveKey(secretKey: crypto.SecretKey(utf8.encode(password)), nonce: salt);
  }

  String generateSalt({int bytes = 16}) {
    final salt = List<int>.generate(bytes, (_) => _random.nextInt(256));
    return hex.encode(salt);
  }

  Future<String> hashPassword(String password, String saltHex) async {
    final salt = Uint8List.fromList(hex.decode(saltHex));
    final key = utf8.encode(password);
    final mac = std_crypto.Hmac(std_crypto.sha256, salt);
    final digest = mac.convert(key);
    final second = std_crypto.Hmac(std_crypto.sha256, digest.bytes).convert(key);
    return hex.encode(second.bytes);
  }

  Future<bool> verifyPassword(String password, String saltHex, String storedHash) async {
    final computed = await hashPassword(password, saltHex);
    return computed == storedHash;
  }

  Future<Uint8List> encrypt(Uint8List data, crypto.SecretKey key) async {
    final nonce = _aesGcm.newNonce();
    final secretBox = await _aesGcm.encrypt(data, secretKey: key, nonce: nonce);
    final result = Uint8List(nonce.length + secretBox.mac.bytes.length + secretBox.cipherText.length);
    result.setRange(0, nonce.length, nonce);
    result.setRange(nonce.length, nonce.length + secretBox.mac.bytes.length, secretBox.mac.bytes);
    result.setRange(nonce.length + secretBox.mac.bytes.length, result.length, secretBox.cipherText);
    return result;
  }

  Future<Uint8List> decrypt(Uint8List packed, crypto.SecretKey key) async {
    const nonceLen = AppConfig.gcmNonceLength;
    const tagLen = AppConfig.gcmTagLength;
    if (packed.length < nonceLen + tagLen) throw Exception('Invalid encrypted payload');
    final nonce = packed.sublist(0, nonceLen);
    final mac = crypto.Mac(packed.sublist(nonceLen, nonceLen + tagLen));
    final cipherText = packed.sublist(nonceLen + tagLen);
    final secretBox = crypto.SecretBox(cipherText, nonce: nonce, mac: mac);
    return await _aesGcm.decrypt(secretBox, secretKey: key);
  }

  Future<Uint8List> encryptString(String text, crypto.SecretKey key) =>
      encrypt(Uint8List.fromList(utf8.encode(text)), key);

  Future<String> decryptString(Uint8List data, crypto.SecretKey key) async {
    final bytes = await decrypt(data, key);
    return utf8.decode(bytes);
  }
}
