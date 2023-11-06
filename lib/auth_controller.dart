import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthController extends GetxController {
  final RxBool isLoggedIn = false.obs;
  final RxString username = ''.obs;
  final RxString fullName = ''.obs;
  final RxString email = ''.obs;
  final RxString dateOfBirth = ''.obs;
  final RxString gender = ''.obs;
  final RxString religion = ''.obs;

  final String apiBaseUrl =
      'http://192.168.100.169/api/api.php'; // Ganti dengan IP URL API Anda

  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(apiBaseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'action': 'login',
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("username", username);
        final storedUsername = prefs.getString("username");
        isLoggedIn.value = true;
        this.username.value = storedUsername ?? '';
      } else {
        // Handle login error
      }
    } else {
      // Handle HTTP error
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
