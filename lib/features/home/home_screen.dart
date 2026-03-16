import 'package:flutter/material.dart';
import '../quran/quran_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF1B4D3E);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.menu_book, size: 80, color: primaryGreen),
            const SizedBox(height: 20),
            const Text('Al-Qur\'anul Karim', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryGreen)),
            const SizedBox(height: 40),
            _buildMenuButton(context, 'BACA QUR\'AN', const QuranScreen()),
            _buildMenuButton(context, 'TERAKHIR BACA', null),
            _buildMenuButton(context, 'PENCARIAN', null),
            _buildMenuButton(context, 'JADWAL SHOLAT', null),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, Widget? target) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(bottom: 15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B4D3E),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        onPressed: target == null ? null : () => Navigator.push(context, MaterialPageRoute(builder: (context) => target)),
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
