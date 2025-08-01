import 'package:flutter/material.dart';

class SubjectSelectionPage extends StatelessWidget {
  const SubjectSelectionPage({super.key});

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

          // Konten utama
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tombol Back
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // Kembali ke dashboard
                    },
                  ),
                  const SizedBox(height: 10),

                  const Text(
                    'RemedyAI',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Orbitron',
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Tulisan di tengah
                  const Center(
                    child: Text(
                      'Pilih Mata Pelajaran',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Tombol di tengah dan tidak terlalu lebar
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: Column(
                        children: [
                          SubjectButton(
                            title: 'Matematika',
                            onTap: () {
                              // Navigasi ke soal Matematika
                            },
                          ),
                          const SizedBox(height: 20),
                          SubjectButton(
                            title: 'B. Indonesia',
                            onTap: () {
                              // Navigasi ke soal Bahasa Indonesia
                            },
                          ),
                        ],
                      ),
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

class SubjectButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SubjectButton({required this.title, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.indigo,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
