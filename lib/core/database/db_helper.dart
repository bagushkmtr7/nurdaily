import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _suraSearchDb;
  static Database? _alquranDb;
  static Database? _latinDb;
  static Database? _terjemahanDb;
  static Database? _surahInfoDb;

  Future<Database> _getDb(String fileName) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, fileName);
    return await openDatabase(path, readOnly: true);
  }

  Future<Database> getSuraSearchDb() async => _suraSearchDb ??= await _getDb('sura-search.db');
  Future<Database> getAlquranDb() async => _alquranDb ??= await _getDb('alquran.db');
  Future<Database> getLatinDb() async => _latinDb ??= await _getDb('latin.db');
  Future<Database> getTerjemahanDb() async => _terjemahanDb ??= await _getDb('terjemahan.db');
  Future<Database> getSurahInfoDb() async => _surahInfoDb ??= await _getDb('surah_info.db');

  Future<List<Map<String, dynamic>>> getFullSurahData() async {
    final searchDb = await getSuraSearchDb();
    final quranDb = await getAlquranDb();
    final infoDb = await getSurahInfoDb();
    List<Map<String, dynamic>> surahNames = await searchDb.query('sura_search');
    List<Map<String, dynamic>> locations = await infoDb.query('info');
    List<Map<String, dynamic>> counts = await quranDb.rawQuery('SELECT sura, COUNT(*) as total FROM quran GROUP BY sura');
    return surahNames.map((s) {
      int no = s['no'];
      var locData = locations.firstWhere((l) => l['no'] == no, orElse: () => {'location': 'Mekkah'});
      var countData = counts.firstWhere((c) => c['sura'] == no, orElse: () => {'total': 0});
      return {...s, 'location': locData['location'], 'total_verses': countData['total']};
    }).toList();
  }

  // AMBIL DETAIL AYAT (Tabel: quran, Kolom: sura, aya, text)
  Future<List<Map<String, dynamic>>> getSurahDetail(int suraId) async {
    final arDb = await getAlquranDb();
    final ltDb = await getLatinDb();
    final trDb = await getTerjemahanDb();

    // Pastikan pakai 'sura' (bukan surah) dan diurutkan berdasarkan 'aya'
    List<Map<String, dynamic>> arAyats = await arDb.query('quran', where: 'sura = ?', whereArgs: [suraId], orderBy: 'aya');
    List<Map<String, dynamic>> ltAyats = await ltDb.query('quran', where: 'sura = ?', whereArgs: [suraId], orderBy: 'aya');
    List<Map<String, dynamic>> trAyats = await trDb.query('quran', where: 'sura = ?', whereArgs: [suraId], orderBy: 'aya');

    return List.generate(arAyats.length, (i) {
      return {
        'aya': arAyats[i]['aya'],
        'arabic': arAyats[i]['text'],
        'latin': ltAyats[i]['text'],
        'translation': trAyats[i]['text'],
      };
    });
  }
}
