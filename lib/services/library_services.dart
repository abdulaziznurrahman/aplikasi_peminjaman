import '../models/book.dart';

class Member {
  final String id;
  final String nama;
  final String nis;
  Member({required this.id, required this.nama, required this.nis});
}

class LoanTransaction {
  final String id;
  final String bookTitle;
  final String memberName;
  final DateTime tanggalPinjam;
  final DateTime tanggalHarusKembali;
  DateTime? tanggalKembali;
  String status; // 'Dipinjam', 'Dikembalikan'
  int denda;

  LoanTransaction({
    required this.id,
    required this.bookTitle,
    required this.memberName,
    required this.tanggalPinjam,
    required this.tanggalHarusKembali,
    this.tanggalKembali,
    this.status = 'Dipinjam',
    this.denda = 0,
  });
}

class LibraryService {
  static List<Book> books = [
    Book(id: '1', judul: 'Belajar Flutter & Dart', pengarang: 'Tim RPL', penerbit: 'Media Pustaka', kategori: 'Teknologi', stok: 5, rak: 'R-01'),
    Book(id: '2', judul: 'Pemrograman Web Laravel', pengarang: 'Ahmad Developer', penerbit: 'Informatika', kategori: 'Teknologi', stok: 3, rak: 'R-02'),
    Book(id: '3', judul: 'Algoritma & Pemrograman Dasar', pengarang: 'Budi Santoso', penerbit: 'Erlangga', kategori: 'Edukasi', stok: 4, rak: 'R-03'),
  ];

  static List<Member> members = [
    Member(id: 'M1', nama: 'Andi Pratama', nis: '1001'),
    Member(id: 'M2', nama: 'Siti Aminah', nis: '1002'),
  ];

  static List<LoanTransaction> transactions = [
    LoanTransaction(
      id: 'T1',
      bookTitle: 'Belajar Flutter & Dart',
      memberName: 'Andi Pratama',
      tanggalPinjam: DateTime.now().subtract(const Duration(days: 5)),
      tanggalHarusKembali: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  // Hitung Denda Otomatis (Rp 2.000 / hari terlambat)
  static int hitungDenda(DateTime harusKembali, DateTime dikembalikan) {
    if (dikembalikan.isAfter(harusKembali)) {
      int selisihHari = dikembalikan.difference(harusKembali).inDays;
      return selisihHari * 2000;
    }
    return 0;
  }
}