import 'package:flutter/material.dart';
import '../../services/library_services.dart';

class ManageMembersScreen extends StatefulWidget {
  const ManageMembersScreen({super.key});

  @override
  State<ManageMembersScreen> createState() => _ManageMembersScreenState();
}

class _ManageMembersScreenState extends State<ManageMembersScreen> {
  void _tambahAnggotaDialog() {
    final namaController = TextEditingController();
    final nisController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Anggota Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: namaController, decoration: const InputDecoration(labelText: 'Nama Siswa', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: nisController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'NIS (Password otomatis sama)', border: OutlineInputBorder())),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
            onPressed: () {
              if (namaController.text.isNotEmpty && nisController.text.isNotEmpty) {
                setState(() {
                  LibraryService.members.add(Member(
                    id: DateTime.now().toString(),
                    nama: namaController.text,
                    nis: nisController.text,
                  ));
                });
                Navigator.pop(context);
              }
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
      appBar: AppBar(title: const Text('Kelola Data Anggota Siswa'), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
      body: ListView.builder(
        itemCount: LibraryService.members.length,
        itemBuilder: (context, index) {
          var member = LibraryService.members[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.indigo, child: Icon(Icons.person, color: Colors.white)),
              title: Text(member.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('NIS: ${member.nis} | Pass: ${member.nis}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    LibraryService.members.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        tooltip: 'Tambah Anggota',
        onPressed: _tambahAnggotaDialog,
        child: const Icon(Icons.person_add),
      ),
    );
  }
}