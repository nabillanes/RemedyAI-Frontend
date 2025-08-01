import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashsiswa_page.dart'; 


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _konfirmasiController = TextEditingController();

  String _selectedRole = 'Siswa';
  bool _isLoading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _konfirmasiController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Registrasi Gagal'),
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

  Future<void> _saveUserData(String uid, String email, String role, String nama) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
    await prefs.setString('email', email);
    await prefs.setString('role', role);
    await prefs.setString('nama', nama);
    await prefs.setBool('isLoggedIn', true);
  }
  Future<void> _handleRegistration() async {
  if (!_formKey.currentState!.validate()) return;

  if (_passwordController.text != _konfirmasiController.text) {
    _showErrorDialog('Password dan Konfirmasi Password tidak cocok!');
    return;
  }

  if (_passwordController.text.length < 6) {
    _showErrorDialog('Password minimal 6 karakter.');
    return;
  }

  setState(() => _isLoading = true);

  try {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    final String fullName = _namaController.text.trim();
    final String role = _selectedRole;

    // 1. Buat akun di Firebase Auth
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    String uid = userCredential.user!.uid;

    // 2. Tentukan collection sesuai role
    String collectionName = role.toLowerCase() == 'guru' ? 'guru' : 'siswa';

    // 3. Simpan data ke Firestore
    await FirebaseFirestore.instance.collection(collectionName).doc(uid).set({
      'nama': fullName,
      'email': email,
      'role': role,
      'tanggal_daftar': FieldValue.serverTimestamp(),
    });

    // 4. Simpan ke SharedPreferences
    await _saveUserData(uid, email, role, fullName);

    // 5. Tampilkan notifikasi berhasil
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Registrasi berhasil!")),
    );

    // 6. Arahkan ke dashboard sesuai role
    if (role == 'Siswa') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardSiswaPage(namaLengkap: fullName),
        ),
      );
    } else {
      // Tambahkan navigasi ke dashboard guru di sini jika ada
    }
  } on FirebaseAuthException catch (e) {
    String errorMsg;
    switch (e.code) {
      case 'weak-password':
        errorMsg = 'Password terlalu lemah.';
        break;
      case 'email-already-in-use':
        errorMsg = 'Email sudah terdaftar.';
        break;
      case 'invalid-email':
        errorMsg = 'Format email tidak valid.';
        break;
      default:
        errorMsg = 'Terjadi kesalahan: ${e.message ?? 'Tidak diketahui'}.';
    }
    _showErrorDialog(errorMsg);
  } catch (e) {
    _showErrorDialog('Terjadi kesalahan yang tidak terduga. Silakan coba lagi. ($e)');
  } finally {
    setState(() => _isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.4))),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Orbitron',
                      ),
                    ),
                    const SizedBox(height: 32),

                    SizedBox(
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTextField(
                            hint: 'Nama Lengkap',
                            controller: _namaController,
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Nama harus diisi' : null,
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            hint: 'Email',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Email harus diisi';
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                                return 'Masukkan email yang valid';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            hint: 'Password',
                            controller: _passwordController,
                            obscure: true,
                            validator: (v) =>
                                (v == null || v.length < 6) ? 'Minimal 6 karakter' : null,
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            hint: 'Konfirmasi Password',
                            controller: _konfirmasiController,
                            obscure: true,
                            validator: (v) => (v != _passwordController.text)
                                ? 'Password tidak cocok'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _selectedRole,
                              dropdownColor: Colors.black,
                              style: const TextStyle(color: Colors.white),
                              iconEnabledColor: Colors.white,
                              decoration: const InputDecoration(border: InputBorder.none),
                              items: ['Siswa', 'Guru']
                                  .map((role) =>
                                      DropdownMenuItem<String>(value: role, child: Text(role)))
                                  .toList(),
                              onChanged: (val) => setState(() => _selectedRole = val!),
                            ),
                          ),
                          const SizedBox(height: 32),

                          ElevatedButton(
                            onPressed: _isLoading ? null : _handleRegistration,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: const StadiumBorder(),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(color: Colors.white),
                                  )
                                : const Text(
                                    "Register",
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
                              const Text("Have an account? ",
                                  style: TextStyle(color: Colors.white70)),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(
                                    color: Colors.lightBlueAccent,
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
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
      validator: validator,
    );
  }
}
