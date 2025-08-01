import 'package:flutter/material.dart';
import 'package:remedyai/subjectselect_page.dart';
import 'dashsiswa_page.dart';

class RemedialStartPage extends StatelessWidget {
  final String namaLengkap; // Untuk kembali ke dashboard siswa

  const RemedialStartPage({super.key, required this.namaLengkap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
          ),
          // Overlay gelap
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          // Tombol Back (Panah)
          Positioned(
            top: 40, // Beri jarak agar tidak bentrok dengan status bar
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DashboardSiswaPage(namaLengkap: namaLengkap),
                  ),
                );
              },
            ),
          ),
          // Konten utama
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo RemedyAI
                  Image.asset(
                    'assets/images/logo.png',
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  const SizedBox(height: 30),

                  const Text(
                    'RemedyAI',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SubjectSelectionPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'MULAI REMEDIAL',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
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
