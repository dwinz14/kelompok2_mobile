import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Dashboard"),
        actions: [
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                title: "Logout Confirmation",
                content: Text("Are you sure you want to logout?"),
                textConfirm: "Logout",
                onConfirm: () {
                  authController.logout();
                  Get.offAllNamed('/login');
                },
                textCancel: "Cancel",
              );
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to Your Dashboard",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
