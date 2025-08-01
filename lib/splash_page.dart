import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashsiswa_page.dart';
import 'dashguru_page.dart';
import 'sign_in_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final nama = prefs.getString('userName') ?? '';
    final role = prefs.getString('userRole') ?? '';

    await Future.delayed(const Duration(seconds: 2)); // Untuk efek loading splash

    if (isLoggedIn && nama.isNotEmpty) {
      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          // Coba refresh token agar session tetap aktif
          await user.getIdToken(true);

          // Arahkan sesuai role
          if (role == 'Siswa') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => DashboardSiswaPage(namaLengkap: nama)),
            );
          } else if (role == 'Guru') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => DashboardGuruPage(namaLengkap: nama)),
            );
          } else {
            _goToLogin();
          }
        } else {
          _goToLogin();
        }
      } catch (e) {
        // Jika gagal refresh token (token kadaluarsa), logout
        await FirebaseAuth.instance.signOut();
        await prefs.clear();
        _goToLogin();
      }
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignInPage()));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
