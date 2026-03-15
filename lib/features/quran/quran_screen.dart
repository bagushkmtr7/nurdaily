import "quran_detail_screen.dart";
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
    const Color primaryGreen = Color(0xFF1B4D3E); // Hijau Tua
    const Color goldColor = Color(0xFFBCA37F);    // Warna Emas/Cokelat
    const Color bgColor = Color(0xFFFDFBF8);     // Background krem halus

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Baca Qur\'an', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: primaryGreen,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Navigasi Tab (SURAH, JUZ, BOOKMARK)
          Container(
            color: primaryGreen,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTabItem("SURAH", true, goldColor),
                  _buildTabItem("JUZ", false, goldColor),
                  _buildTabItem("BOOKMARK", false, goldColor),
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
                  separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.withOpacity(0.08)),
                  itemBuilder: (context, index) {
                    final surah = surahs[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      leading: _buildSurahNumber(surah['no'].toString(), goldColor, primaryGreen),
                      title: Text(
                        '${surah['indonesia']}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                      ),
                      subtitle: Text(
                        '${surah['location'].toUpperCase()} | ${surah['total_verses']} AYAT',
                        style: const TextStyle(color: goldColor, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                      ),
                      // Trailing dihapus total biar bersih (Gak ada null, gak ada download)
                      onTap: () {
                        // Navigasi detail nanti di sini
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

  // Widget buat bikin Nomor Surah yang mulus (Rub el Hizb)
  Widget _buildSurahNumber(String number, Color gold, Color green) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Kotak 1
          Transform.rotate(
            angle: 0,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                border: Border.all(color: gold, width: 1.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Kotak 2 (Dirotasi 45 derajat)
          Transform.rotate(
            angle: 0.785398, // 45 derajat
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                border: Border.all(color: gold, width: 1.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(number, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: green)),
        ],
      ),
    );
  }

  // Helper buat Tab Item
  Widget _buildTabItem(String title, bool isActive, Color activeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isActive ? activeColor : Colors.transparent, width: 3)),
      ),
      child: Text(
        title,
        style: TextStyle(color: isActive ? Colors.white : Colors.white60, fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}
