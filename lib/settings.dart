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
      appBar: AppBar(title: Text('Pengaturan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Pengaturan Akun',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                  .map(
                    (kelas) =>
                        DropdownMenuItem(value: kelas, child: Text(kelas)),
                  )
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
    );
  }
}
