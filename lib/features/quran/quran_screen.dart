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
      appBar: AppBar(
        title: const Text('AL-QUR\'AN', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dbHelper.getSurahList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

          final surahs = snapshot.data ?? [];
          return ListView.builder(
            itemCount: surahs.length,
            itemBuilder: (context, index) {
              final surah = surahs[index];
              return ListTile(
                leading: Text('${surah['id']}'),
                title: Text('${surah['latin']}'),
                trailing: Text('${surah['arabic']}', style: TextStyle(fontSize: 20)),
              );
            },
          );
        },
      ),
    );
  }
}
