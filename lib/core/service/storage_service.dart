import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _box = GetStorage();

  static const String accessTokenKey = "access_token";

  Future<void> saveToken(String token) async {
    await _box.write(accessTokenKey, token);
  }

  String get token {
    return _box.read<String>(accessTokenKey) ?? "";
  }

  Future<void> clearToken() async {
    await _box.remove(accessTokenKey);
  }
}
