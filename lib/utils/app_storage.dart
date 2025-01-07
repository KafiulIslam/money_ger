import 'package:flutter_secure_storage/flutter_secure_storage.dart';


AndroidOptions _getAndroidOptions() => const AndroidOptions(
  encryptedSharedPreferences: true,
);

final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

class AppStorage{

  /// for acessToken  ///
  // static Future<void> setAccessToken(String value) async {
  //   await storage?.write(key: 'token', value: value);
  // }

  static Future<String?> getSessionId() async {
    String? sessionId = await storage.read(key: 'sessionId');
    return sessionId;
  }

  static Future<String?> getUserId() async {
    String? userId = await storage.read(key: 'userId');
    return userId;
  }

  static Future<String?> getCurrency() async {
    String? currency = await storage.read(key: 'currency');
    return currency;
  }

  static Future<String?> getImageUrl() async {
    String? imageUrl = await storage.read(key: 'imageUrl');
    return imageUrl;
  }

}