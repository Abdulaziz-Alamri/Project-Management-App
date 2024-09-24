import 'package:project_management_app/models/auth_model.dart';
import 'package:get_storage/get_storage.dart';

class DataLayer {
  AuthModel? auth;
  final box = GetStorage();

  DataLayer() {
    loadDataAuth();
  }

  Future<void> saveAuth({required AuthModel authData}) async {
    auth = authData;
    await box.write("auth", authData.toJson());
  }

  Future<void> loadDataAuth() async {
    if (box.hasData('auth')) {
      auth = AuthModel.fromJson(
          Map.from(await box.read("auth")).cast<String, dynamic>());
    }
  }

  Future<void> logOut() async {
    box.erase();
    auth = null;
  }
}
