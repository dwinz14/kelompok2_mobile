import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_page.dart';
import 'registration_page.dart';
import 'dashboard.dart';
import 'auth_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(AuthController()); // Inisialisasi AuthController

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App Name',
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/registration', page: () => RegistrationPage()),
        GetPage(name: '/dashboard', page: () => DashboardPage()),
      ],
    );
  }
}
