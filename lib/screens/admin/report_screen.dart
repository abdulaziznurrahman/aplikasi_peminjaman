import 'package:flutter/material.dart';
import '../../services/library_services.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan & Buku Terfavorit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rekapitulasi Peminjaman Buku', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.assessment, color: Colors.blue),
                title: const Text('Total Transaksi Tercatat'),
                trailing: Text('${LibraryService.transactions.length}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Buku Terfavorit (Sering Dipinjam)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: LibraryService.books.length,
                itemBuilder: (context, index) {
                  var book = LibraryService.books[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(book.judul),
                    subtitle: Text('Kategori: ${book.kategori}'),
                    trailing: const Text('Favorit Tinggi', style: TextStyle(color: Colors.purple)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}