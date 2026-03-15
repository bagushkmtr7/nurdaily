import 'package:flutter/material.dart';
import '../../main.dart'; // Buat nyambungin ke menu navigasi

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. BACKGROUND GAMBAR LOKAL LU
          Image.asset(
            'assets/images/imgmekah.png',
            fit: BoxFit.cover,
          ),
          
          // 2. KACA GELAP TAMPAN
          Container(
            color: Colors.black.withOpacity(0.65),
          ),
          
          // 3. KONTEN UTAMA
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.menu_book,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                const Text(
                  "AL-QUR'AN",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 50),
                
                // TOMBOL MENU
                _buildMenuButton(
                  context, 
                  "BACA QUR'AN", 
                  Icons.book, 
                  isPrimary: true,
                  onTap: () {
                    // Masuk ke tab Qur'an (Index 1)
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigation(initialIndex: 1)));
                  }
                ),
                _buildMenuButton(context, "TERAKHIR BACA", Icons.history, onTap: () {}),
                _buildMenuButton(context, "PENCARIAN", Icons.search, onTap: () {}),
                _buildMenuButton(
                  context, 
                  "JADWAL SHOLAT", 
                  Icons.access_time,
                  onTap: () {
                    // Masuk ke tab Sholat (Index 0)
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigation(initialIndex: 0)));
                  }
                ),
                _buildMenuButton(context, "PENGATURAN", Icons.settings, onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon, {bool isPrimary = false, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isPrimary ? Colors.teal.withOpacity(0.8) : Colors.white.withOpacity(0.1),
            border: Border.all(color: isPrimary ? Colors.tealAccent : Colors.white60, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
