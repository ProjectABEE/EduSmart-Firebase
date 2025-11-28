import 'package:edusmart/constant/appimage.dart';
import 'package:edusmart/preferences/preferences_handler.dart';
import 'package:edusmart/view/admin/bottom_navigation_admin.dart';
import 'package:edusmart/view/auth/loginedu.dart';
import 'package:edusmart/view/guru/bottomnav.dart';
import 'package:edusmart/view/siswa/bottomnav.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    isLoginFunction();
  }

  isLoginFunction() async {
    await Future.delayed(const Duration(seconds: 1));

    var isLogin = await PreferenceHandler.getLogin();
    var role = await PreferenceHandler.getRole();

    if (isLogin == true) {
      // Arahkan sesuai role
      if (role == "admin") {
        goTo(const BottomNavigationAdmin());
      } else if (role == "guru") {
        goTo(const BottomNavGuru());
      } else {
        goTo(const BottomNavigationEDU()); // siswa default
      }
    } else {
      goTo(const LoginEdu());
    }
  }

  goTo(Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff256BE8), Color(0xff1CE2DA)],
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.logoEdu, width: 120),
            const SizedBox(height: 15),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
