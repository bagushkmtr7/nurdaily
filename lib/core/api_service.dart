import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/surah_model.dart';
import '../data/prayer_model.dart';

class ApiService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  static const String _baseUrlQuran = 'https://equran.id/api/v2';
  static const String _baseUrlPrayer = 'https://api.aladhan.com/v1';

  // --- AUTH ---
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // --- PENGUMUMAN ---
  Future<List<Map<String, dynamic>>> getAnnouncements() async {
    try {
      QuerySnapshot snapshot = await _db.collection('announcements')
          .orderBy('created_at', descending: true)
          .get();
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        'title': doc['title'] ?? '',
        'content': doc['content'] ?? '',
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addAnnouncement(String title, String content) async {
    await _db.collection('announcements').add({
      'title': title,
      'content': content,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  // --- QURAN (Ditambahin biar gak error lagi) ---
  Future<List<Surah>> getSurahs() async {
    final res = await http.get(Uri.parse('$_baseUrlQuran/surat'));
    if (res.statusCode == 200) {
      List data = json.decode(res.body)['data'];
      return data.map((s) => Surah.fromJson(s)).toList();
    }
    throw Exception('Gagal');
  }

  Future<Map<String, dynamic>> getSurahDetail(int nomor) async {
    final res = await http.get(Uri.parse('$_baseUrlQuran/surat/$nomor'));
    if (res.statusCode == 200) return json.decode(res.body)['data'];
    throw Exception('Gagal');
  }

  Future<PrayerTime> getPrayerTimes(String city) async {
    final res = await http.get(Uri.parse('$_baseUrlPrayer/timingsByCity?city=$city&country=Indonesia&method=2'));
    if (res.statusCode == 200) return PrayerTime.fromJson(json.decode(res.body)['data']['timings']);
    throw Exception('Gagal');
  }
}
