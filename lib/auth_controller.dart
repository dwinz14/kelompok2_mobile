import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final RxBool isLoggedIn = false.obs;
  final RxString username = ''.obs;
  final RxString fullName = ''.obs;
  final RxString email = ''.obs;
  final RxString dateOfBirth = ''.obs;
  final RxString gender = ''.obs;
  final RxString religion = ''.obs;

  void login(String username, String password) async {
    // Disini tambahkan logika login sesuai dengan data yang telah diregistrasikan
    // Misalnya, Anda dapat memeriksa username dan password dengan data yang disimpan.
    if (username == "username" && password == "password") {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("username", username);
      final storedUsername = prefs.getString("username");
      isLoggedIn.value = true;
      this.username.value = storedUsername ?? '';
    }
  }

  void logout() async {
    isLoggedIn.value = false;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("username");
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString("username") ?? '';
    fullName.value = prefs.getString("fullName") ?? '';
    email.value = prefs.getString("email") ?? '';
    dateOfBirth.value = prefs.getString("dateOfBirth") ?? '';
    gender.value = prefs.getString("gender") ?? '';
    religion.value = prefs.getString("religion") ?? '';
  }

  void clearData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("username");
    prefs.remove("fullName");
    prefs.remove("email");
    prefs.remove("dateOfBirth");
    prefs.remove("gender");
    prefs.remove("religion");
  }
}
