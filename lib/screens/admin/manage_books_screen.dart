import 'package:flutter/material.dart';
import '../../services/library_services.dart';
import '../../models/book.dart';
import '../main_screen.dart';
import 'circulation_screen.dart';
import 'manage_member_screen.dart';
import 'report_screen.dart';

class ManageBooksScreen extends StatefulWidget {
  const ManageBooksScreen({super.key});

  @override
  State<ManageBooksScreen> createState() => _ManageBooksScreenState();
}

class _ManageBooksScreenState extends State<ManageBooksScreen> {
  void _tambahBukuDialog() {
    final judulController = TextEditingController();
    final pengarangController = TextEditingController();
    final penerbitController = TextEditingController();
    final kategoriController = TextEditingController();
    final stokController = TextEditingController();
    final rakController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Buku Baru'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: judulController, decoration: const InputDecoration(labelText: 'Judul Buku')),
              TextField(controller: pengarangController, decoration: const InputDecoration(labelText: 'Pengarang')),
              TextField(controller: penerbitController, decoration: const InputDecoration(labelText: 'Penerbit')),
              TextField(controller: kategoriController, decoration: const InputDecoration(labelText: 'Kategori')),
              TextField(controller: stokController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stok')),
              TextField(controller: rakController, decoration: const InputDecoration(labelText: 'Rak')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                LibraryService.books.add(Book(
                  id: DateTime.now().toString(),
                  judul: judulController.text,
                  pengarang: pengarangController.text,
                  penerbit: penerbitController.text,
                  kategori: kategoriController.text,
                  stok: int.tryParse(stokController.text) ?? 1,
                  rak: rakController.text,
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Petugas Perpustakaan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: 'Kelola Anggota',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ManageMembersScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Sirkulasi Transaksi',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const CirculationScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Laporan',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ReportScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: LibraryService.books.length,
        itemBuilder: (context, index) {
          Book book = LibraryService.books[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(book.judul, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Pengarang: ${book.pengarang} | Penerbit: ${book.penerbit}\nKategori: ${book.kategori} | Stok: ${book.stok} | Rak: ${book.rak}'),
              isThreeLine: true,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah Buku',
        onPressed: _tambahBukuDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}