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
      'http://192.168.0.127/api/api.php'; // Ganti dengan IP URL API Anda

  Future<void> login(String username, String password) async {
    try {
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
          prefs.setString("fullName", data['fullName'] ?? '');
          prefs.setString("email", data['email'] ?? '');
          prefs.setString("dateOfBirth", data['dateOfBirth'] ?? '');
          prefs.setString("gender", data['gender'] ?? '');
          prefs.setString("religion", data['religion'] ?? '');

          isLoggedIn.value = true;
          this.username.value = username;
          this.fullName.value = data['fullName'] ?? '';
          this.email.value = data['email'] ?? '';
          this.dateOfBirth.value = data['dateOfBirth'] ?? '';
          this.gender.value = data['gender'] ?? '';
          this.religion.value = data['religion'] ?? '';

          print('Login successful. User data:');
          print('Username: $username');
          print('FullName: ${this.fullName.value}');
          print('Email: ${this.email.value}');
          print('DateOfBirth: ${this.dateOfBirth.value}');
          print('Gender: ${this.gender.value}');
          print('Religion: ${this.religion.value}');
        } else {
          // Handle login error
          // ...
        }
      } else {
        // Handle HTTP error
        // ...
      }
    } catch (e) {
      // Handle other errors
      print('Error during login: $e');
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

    final profileResponse = await http.get(
      Uri.parse('$apiBaseUrl?action=get_user_data&username=${username.value}'),
    );

    if (profileResponse.statusCode == 200) {
      final Map<String, dynamic> profileData = jsonDecode(profileResponse.body);
      if (profileData['success'] == true) {
        fullName.value = profileData['user']['fullName'];
        email.value = profileData['user']['email'];
        dateOfBirth.value = profileData['user']['dateOfBirth'];
        gender.value = profileData['user']['gender'];
        religion.value = profileData['user']['religion'];
      } else {
        // Handle error while fetching profile
      }
    } else {
      // Handle HTTP error
    }
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
