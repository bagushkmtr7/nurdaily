import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/database/db_helper.dart';

class QuranDetailScreen extends StatelessWidget {
  final int suraId;
  final String suraName;

  const QuranDetailScreen({super.key, required this.suraId, required this.suraName});

  @override
  Widget build(BuildContext context) {
    final DbHelper dbHelper = DbHelper();
    const Color primaryGreen = Color(0xFF1B4D3E);
    const Color latinColor = Color(0xFF358B8B); 
    const Color goldColor = Color(0xFFBCA37F);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF8),
      appBar: AppBar(
        title: Text(suraName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.getSurahDetail(suraId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: primaryGreen));
          
          final ayats = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ayats.length,
            itemBuilder: (context, index) {
              final ayat = ayats[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAyahNumber(ayat['aya'].toString(), goldColor),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            ayat['arabic'],
                            textAlign: TextAlign.right,
                            style: GoogleFonts.amiri(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              height: 1.8,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      ayat['latin'],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: latinColor,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      ayat['translation'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAyahNumber(String number, Color gold) {
    return SizedBox(
      width: 35,
      height: 35,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(angle: 0.785, child: Icon(Icons.square, color: gold.withOpacity(0.15), size: 28)),
          Icon(Icons.brightness_7_outlined, color: gold, size: 30),
          Text(number, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
