import 'package:flutter/material.dart';
import '../../core/database/db_helper.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final DbHelper _dbHelper = DbHelper();
  late Future<List<Map<String, dynamic>>> _surahFuture;

  @override
  void initState() {
    super.initState();
    _surahFuture = _getSurahData();
  }

  Future<List<Map<String, dynamic>>> _getSurahData() async {
    // Kita panggil database sura-search.db
    final db = await _dbHelper.getSuraSearchDb();
    // PAKAI TABEL 'data' SESUAI SCREENSHOT LU
    return await db.query('data');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('AL-QUR\'AN', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _surahFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.teal));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final surahs = snapshot.data ?? [];

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: surahs.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade100),
            itemBuilder: (context, index) {
              final surah = surahs[index];
              return ListTile(
                leading: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text('${surah['id']}', style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                title: Text(
                  surah['latin'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text('${surah['location']} • ${surah['ayah']} Ayat', style: const TextStyle(fontSize: 12)),
                trailing: Text(
                  surah['arabic'] ?? '',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                onTap: () {
                  // Navigasi ke detail ayat akan kita buat setelah ini
                },
              );
            },
          );
        },
      ),
    );
  }
}
