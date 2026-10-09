import 'package:flutter/material.dart';
import '../../services/library_services.dart';
import '../../models/book.dart';
import '../main_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String keyword = '';
  String selectedKategori = 'Semua';

  @override
  Widget build(BuildContext context) {
    List<String> categories = ['Semua', 'Teknologi', 'Edukasi'];

    List<Book> filteredBooks = LibraryService.books.where((b) {
      bool matchesKeyword = b.judul.toLowerCase().contains(keyword.toLowerCase()) ||
                            b.pengarang.toLowerCase().contains(keyword.toLowerCase());
      bool matchesCategory = selectedKategori == 'Semua' || b.kategori == selectedKategori;
      return matchesKeyword && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog & Pengajuan Buku (Anggota)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Riwayat & Pengingat',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => const MemberHistoryScreen()));
            },
          ),
          // Tombol Logout untuk Siswa
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Cari Judul atau Pengarang Buku...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => keyword = value),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((kat) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: Text(kat),
                  selected: selectedKategori == kat,
                  onSelected: (selected) => setState(() => selectedKategori = kat),
                ),
              )).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                Book book = filteredBooks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(book.judul, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Pengarang: ${book.pengarang} | Rak: ${book.rak}\nStok: ${book.stok} | Kategori: ${book.kategori}'),
                    isThreeLine: true,
                    trailing: ElevatedButton(
                      child: const Text('Ajukan Pinjam'),
                      onPressed: () {
                        setState(() {
                          LibraryService.transactions.add(LoanTransaction(
                            id: DateTime.now().toString(),
                            bookTitle: book.judul,
                            memberName: 'Siswa Login',
                            tanggalPinjam: DateTime.now(),
                            tanggalHarusKembali: DateTime.now().add(const Duration(days: 7)),
                          ));
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Pengajuan peminjaman "${book.judul}" berhasil dikirim ke Petugas!')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Halaman Riwayat & Pengingat Anggota
class MemberHistoryScreen extends StatelessWidget {
  const MemberHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Peminjaman & Pengingat')),
      body: ListView.builder(
        itemCount: LibraryService.transactions.length,
        itemBuilder: (context, index) {
          var trx = LibraryService.transactions[index];
          bool isTerlambat = DateTime.now().isAfter(trx.tanggalHarusKembali) && trx.status == 'Dipinjam';

          return Card(
            margin: const EdgeInsets.all(8),
            color: isTerlambat ? Colors.red[50] : Colors.white,
            child: ListTile(
              title: Text(trx.bookTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                'Status: ${trx.status}\nTenggat: ${trx.tanggalHarusKembali.toLocal().toString().split(' ')[0]}\n${isTerlambat ? "⚠️ PERINGATAN: Batas waktu pengembalian telah terlewati!" : "✅ Masa peminjaman aman."}',
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}