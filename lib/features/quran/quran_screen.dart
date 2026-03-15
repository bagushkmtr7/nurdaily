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
    const Color primaryGreen = Color(0xFF1B4D3E);
    const Color goldText = Color(0xFFBCA37F);
    const Color bgColor = Color(0xFFFDFBF8);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Baca Qur\'an', style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.playlist_play, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // TAB BAR FIX: Pake Container buat garis bawah
          Container(
            color: primaryGreen,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 4),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: goldText, width: 3)),
                    ),
                    child: const Text('SURAH', 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                    ),
                  ),
                  const Text('JUZ', style: TextStyle(color: Colors.white70)),
                  const Text('BOOKMARK', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),
          // List Surah
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _dbHelper.getFullSurahData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: primaryGreen));
                
                final surahs = snapshot.data ?? [];
                return ListView.separated(
                  itemCount: surahs.length,
                  separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
                  itemBuilder: (context, index) {
                    final surah = surahs[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: SizedBox(
                        width: 45,
                        height: 45,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(Icons.brightness_7_outlined, color: goldText, size: 40),
                            Text('${surah['no']}', 
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryGreen)
                            ),
                          ],
                        ),
                      ),
                      title: Text(
                        '${surah['indonesia']}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(
                        '${surah['location'].toUpperCase()} | ${surah['total_verses']} AYAT',
                        style: const TextStyle(color: goldText, fontSize: 11),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${surah['arabic']}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(width: 15),
                          const Icon(Icons.download_for_offline_outlined, color: Color(0xFF609966), size: 22),
                        ],
                      ),
                      onTap: () {},
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
