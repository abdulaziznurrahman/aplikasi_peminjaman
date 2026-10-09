import 'package:flutter/material.dart';
import 'package:aplikasi_peminjaman_buku/services/library_services.dart';
import 'member/catalog_screen.dart';
import 'admin/manage_books_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _nisController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Anggota'; // 'Anggota' atau 'Petugas'

  void _login() {
    String inputId = _nisController.text.trim();
    String inputPass = _passwordController.text.trim();

    if (inputId.isEmpty || inputPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID/NIS dan Password tidak boleh kosong!')),
      );
      return;
    }

    if (_selectedRole == 'Anggota') {
      var foundMember = LibraryService.members.firstWhere(
        (m) => m.nis == inputId,
        orElse: () => Member(id: '', nama: '', nis: ''),
      );

      if (foundMember.nis.isNotEmpty && inputPass == foundMember.nis) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CatalogScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Gagal! NIS tidak ditemukan atau Password salah.')),
        );
      }
    } else {
      // Kredensial Petugas
      if (inputId == 'petugas' && inputPass == 'petugas123') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ManageBooksScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Petugas Gagal! Gunakan ID: petugas & Password: petugas123')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login - Aplikasi Peminjaman Buku')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.library_books, size: 80, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                'Silakan Login',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ToggleButtons(
                isSelected: [_selectedRole == 'Anggota', _selectedRole == 'Petugas'],
                onPressed: (index) {
                  setState(() {
                    _selectedRole = index == 0 ? 'Anggota' : 'Petugas';
                    _nisController.clear();
                    _passwordController.clear();
                  });
                },
                borderRadius: BorderRadius.circular(8),
                children: const [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text('Anggota (Siswa)')),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text('Petugas')),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nisController,
                decoration: InputDecoration(
                  labelText: _selectedRole == 'Anggota' ? 'Masukkan NIS (Contoh: 1001)' : 'ID Petugas (petugas)',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: _selectedRole == 'Anggota' ? 'Password (Sama dengan NIS)' : 'Password (petugas123)',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _login,
                  child: Text('Masuk sebagai $_selectedRole', style: const TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 12),
              if (_selectedRole == 'Anggota')
                const Text(
                  'Demo Siswa -> NIS: 1001 | Pass: 1001',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                )
              else
                const Text(
                  'Demo Petugas -> ID: petugas | Pass: petugas123',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }
}