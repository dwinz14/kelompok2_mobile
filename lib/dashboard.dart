import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_controller.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  String? username, fullName, email, dateOfBirth, gender, religion;

  void fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
    fullName = prefs.getString("fullName");
    email = prefs.getString("email");
    dateOfBirth = prefs.getString("dateOfBirth");
    gender = prefs.getString("gender");
    religion = prefs.getString("religion");
    setState(() {});
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

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
                  Get.find<AuthController>().logout();
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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Welcome, $fullName!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              Text("Username: $username"),
              Text("Email: $email"),
              Text("Date of Birth: $dateOfBirth"),
              Text("Gender: $gender"),
              Text("Religion: $religion"),
            ],
          ),
        ),
      ),
    );
  }
}
