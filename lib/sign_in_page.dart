import 'package:flutter/material.dart';
import 'package:remedyai/dashsiswa_page.dart';
import 'package:remedyai/dashguru_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remedyai/register_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Login Gagal'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
  String email = _emailController.text.trim();
  String password = _passwordController.text;

  if (email.isEmpty || password.isEmpty) {
    _showErrorDialog('Email dan password tidak boleh kosong.');
    return;
  }

  setState(() => _isLoading = true);

  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    String uid = userCredential.user!.uid;

    // Ambil role dari Firestore
    String role = '';
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('siswa').doc(uid).get();
    if (snapshot.exists) {
      role = 'Siswa';
    } else {
      snapshot = await FirebaseFirestore.instance.collection('guru').doc(uid).get();
      if (snapshot.exists) {
        role = 'Guru';
      }
    }

    if (role.isEmpty) {
      throw FirebaseAuthException(code: 'data-tidak-ada', message: 'Akun tidak ditemukan di database.');
    }

    final userData = snapshot.data() as Map<String, dynamic>;
    String namaLengkap = userData['nama'] ?? 'User';

    // Simpan ke SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userName', namaLengkap);
    await prefs.setString('userUid', uid);
    await prefs.setString('userRole', role);

    // Navigasi
    if (role == 'Siswa') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardSiswaPage(namaLengkap: namaLengkap)));
    } else if (role == 'Guru') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardGuruPage(namaLengkap: namaLengkap)));
    }
  } on FirebaseAuthException catch (e) {
    String errorMsg;
    switch (e.code) {
      case 'user-not-found':
        errorMsg = 'Akun tidak ditemukan. Silakan periksa email Anda.';
        break;
      case 'wrong-password':
        errorMsg = 'Password salah. Silakan coba lagi.';
        break;
      case 'invalid-credential':
        errorMsg = 'Email atau password salah.';
        break;
      case 'invalid-email':
        errorMsg = 'Format email tidak valid.';
        break;
      default:
        errorMsg = 'Terjadi kesalahan: ${e.message ?? 'Tidak diketahui'}.';
    }
    _showErrorDialog(errorMsg);
  } catch (e) {
    _showErrorDialog('Terjadi kesalahan: $e');
  } finally {
    setState(() => _isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "RemedyAI",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Orbitron',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.lightBlueAccent,
                                ),
                              )
                            : ElevatedButton(
                                onPressed: _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlueAccent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: const StadiumBorder(),
                                ),
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Orbitron',
                                  ),
                                ),
                              ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(color: Colors.white70),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
