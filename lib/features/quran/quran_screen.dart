import 'package:flutter/material.dart';
import '../../core/database/db_helper.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final DbHelper _dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('AL-QUR\'AN', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dbHelper.getSurahList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.teal));
          }
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

          final surahs = snapshot.data ?? [];
          return ListView.separated(
            itemCount: surahs.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade100),
            itemBuilder: (context, index) {
              final surah = surahs[index];
              return ListTile(
                // Menggunakan kolom 'no' dan 'indonesia' dari sura_search.db
                leading: CircleAvatar(
                  backgroundColor: Colors.teal.shade50,
                  child: Text('${surah['no']}', style: const TextStyle(color: Colors.teal, fontSize: 12)),
                ),
                title: Text(
                  '${surah['indonesia']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Bahasa: ${surah['melayu'] ?? '-'}'),
                trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                onTap: () {
                   // Navigasi ke detail ayat nanti di sini
                },
              );
            },
          );
        },
      ),
    );
  }
}
