import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final AuthController authController = Get.find();

  @override
  void initState() {
    super.initState();
    authController.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil Akun',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Montserrat',
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 1,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/background.png'), // Ganti dengan path logo atau gambar yang sesuai
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage(
                    'assets/images/logo.png'), // Ganti dengan path foto profil yang sesuai
              ),
              SizedBox(height: 16),
              Text(
                'Nama Pengguna: ${authController.username.value}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Email: ${authController.email.value}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Tambahkan aksi yang diinginkan, misalnya logout
                  authController.logout();
                  Get.offAllNamed('/login');
                },
                child: Text('Logout'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 2,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.qr_code_scanner_rounded, size: 50),
          Icon(Icons.account_circle_outlined, size: 30),
        ],
        color: Color.fromARGB(255, 167, 201, 252),
        buttonBackgroundColor: Colors.blue[50],
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          if (index == 0) {
            // Navigate to dashboard
            Get.toNamed('/dashboard');
          } else if (index == 1) {
            // Navigate to transaksi
            Get.toNamed('/transaksi');
          } else if (index == 2) {
            // Navigate to profil
            Get.toNamed('/profil');
          }
        },
      ),
    );
  }
}
