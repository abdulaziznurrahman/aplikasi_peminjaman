import 'package:flutter/material.dart';
import '../../services/library_services.dart';

class CirculationScreen extends StatefulWidget {
  const CirculationScreen({super.key});

  @override
  State<CirculationScreen> createState() => _CirculationScreenState();
}

class _CirculationScreenState extends State<CirculationScreen> {
  void _tambahTransaksiDialog() {
    String? selectedBook = LibraryService.books.isNotEmpty ? LibraryService.books[0].judul : null;
    String? selectedMember = LibraryService.members.isNotEmpty ? LibraryService.members[0].nama : null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Form Transaksi Pinjam Buku'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: selectedBook,
              items: LibraryService.books.map((b) => DropdownMenuItem(value: b.judul, child: Text(b.judul))).toList(),
              onChanged: (val) => selectedBook = val,
              decoration: const InputDecoration(labelText: 'Pilih Buku', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedMember,
              items: LibraryService.members.map((m) => DropdownMenuItem(value: m.nama, child: Text(m.nama))).toList(),
              onChanged: (val) => selectedMember = val,
              decoration: const InputDecoration(labelText: 'Pilih Anggota Siswa', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
            onPressed: () {
              if (selectedBook != null && selectedMember != null) {
                setState(() {
                  LibraryService.transactions.add(LoanTransaction(
                    id: DateTime.now().toString(),
                    bookTitle: selectedBook!,
                    memberName: selectedMember!,
                    tanggalPinjam: DateTime.now(),
                    tanggalHarusKembali: DateTime.now().add(const Duration(days: 7)), // Tempo 7 hari
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Proses Pinjam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sirkulasi & Denda Otomatis'), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
      body: ListView.builder(
        itemCount: LibraryService.transactions.length,
        itemBuilder: (context, index) {
          var trx = LibraryService.transactions[index];
          int calculatedDenda = LibraryService.hitungDenda(trx.tanggalHarusKembali, DateTime.now());
          bool isTerlambat = DateTime.now().isAfter(trx.tanggalHarusKembali) && trx.status == 'Dipinjam';

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: isTerlambat ? Colors.red[50] : Colors.white,
            child: ListTile(
              title: Text('${trx.bookTitle}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                'Peminjam: ${trx.memberName}\nStatus: ${trx.status}\nTempo: ${trx.tanggalHarusKembali.toLocal().toString().split(' ')[0]}\n${trx.status == 'Dipinjam' ? "Denda Berjalan: Rp $calculatedDenda" : "Denda Dibayar: Rp ${trx.denda}"}',
              ),
              isThreeLine: true,
              trailing: trx.status == 'Dipinjam'
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                      onPressed: () {
                        setState(() {
                          trx.status = 'Dikembalikan';
                          trx.tanggalKembali = DateTime.now();
                          trx.denda = LibraryService.hitungDenda(trx.tanggalHarusKembali, trx.tanggalKembali!);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Buku dikembalikan. Total Denda: Rp ${trx.denda}')),
                        );
                      },
                      child: const Text('Kembalikan'),
                    )
                  : const Chip(label: Text('Selesai', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        tooltip: 'Tambah Transaksi',
        onPressed: _tambahTransaksiDialog,
        child: const Icon(Icons.add_card),
      ),
    );
  }
}