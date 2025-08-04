import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user = FirebaseAuth.instance.currentUser;
  final List<String> kelasList = ['10 IPA', '11 IPA', '12 IPA'];

  String namaLengkap = '';
  String selectedKelas = '';
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();
        final data = doc.data();
        if (data != null) {
          setState(() {
            namaLengkap = data['nama'] ?? '';
            selectedKelas = data['kelas'] ?? kelasList.first;
          });
        }
      } catch (e) {
        print('Gagal memuat data: $e');
      }
    }
  }

  Future<void> _updateUserData() async {
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({'nama': namaLengkap, 'kelas': selectedKelas});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pengaturan berhasil disimpan.')),
        );

        Navigator.pop(context, true); // agar dashboard bisa refresh nama
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan pengaturan: $e')),
        );
      }
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/signin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Pengaturan'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_main.png'), // ganti sesuai background dashboard
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: SingleChildScrollView(
          child: Container(
            width: 400, // Biar tidak terlalu lebar
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Pengaturan Akun',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black87),
                ),
                SizedBox(height: 16),

                TextFormField(
                  initialValue: namaLengkap,
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) => namaLengkap = val,
                ),
                SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: selectedKelas.isEmpty ? kelasList.first : selectedKelas,
                  items: kelasList
                      .map((kelas) =>
                          DropdownMenuItem(value: kelas, child: Text(kelas)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedKelas = val!),
                  decoration: InputDecoration(
                    labelText: 'Kelas',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),

                SwitchListTile(
                  title: Text('Tema Gelap'),
                  value: isDarkMode,
                  onChanged: (val) => setState(() => isDarkMode = val),
                ),
                SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _updateUserData,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: Text('Simpan Perubahan'),
                ),
                SizedBox(height: 16),

                Divider(),
                ListTile(
                  title: Text('Ganti Kata Sandi'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => Navigator.pushNamed(context, '/change-password'),
                ),
                ListTile(
                  title: Text('Logout', style: TextStyle(color: Colors.red)),
                  trailing: Icon(Icons.logout, color: Colors.red),
                  onTap: _logout,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
