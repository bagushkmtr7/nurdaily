import 'package:flutter/material.dart';
import '../../core/database/db_helper.dart';
import 'quran_detail_screen.dart';

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
    const Color goldColor = Color(0xFFBCA37F);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF8),
      appBar: AppBar(
        title: const Text('Baca Qur\'an', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: primaryGreen,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('SURAH', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('JUZ', style: TextStyle(color: Colors.white60)),
                Text('BOOKMARK', style: TextStyle(color: Colors.white60)),
              ],
            ),
          ),
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
                      leading: _buildSurahNumber(surah['no'].toString(), goldColor, primaryGreen),
                      title: Text('${surah['indonesia']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${surah['location'].toUpperCase()} | ${surah['total_verses']} AYAT', style: TextStyle(color: goldColor, fontSize: 10)),
                      onTap: () {
                        // NAVIGASI AKTIF KE DETAIL
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuranDetailScreen(
                              suraId: surah['no'],
                              suraName: surah['indonesia'],
                            ),
                          ),
                        );
                      },
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

  Widget _buildSurahNumber(String number, Color gold, Color green) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: 0.785,
            child: Container(
              width: 26, height: 26,
              decoration: BoxDecoration(border: Border.all(color: gold, width: 1.5), borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Text(number, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: green)),
        ],
      ),
    );
  }
}
