import 'package:get_storage/get_storage.dart';

class StorageService {
  final _box = GetStorage();

  // Save token and role securely
  Future<void> writeTokenAndRole(String token, String role) async {
    await _box.write("auth_token", token);
    await _box.write("user_role", role);
  }

  String? readToken() {
    return _box.read("auth_token");
  }

  String? readRole() {
    return _box.read("user_role");
  }

  Future<void> removeTokenAndRole() async {
    await _box.remove("auth_token");
    await _box.remove("user_role");
  }
}
