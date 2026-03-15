import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _suraSearchDb;
  static Database? _alquranDb;
  static Database? _latinDb;
  static Database? _terjemahanDb;
  static Database? _jalalaynDb;
  static Database? _kataDb;

  Future<Database> _initDatabase(String fileName) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, fileName);

    // Paksa hapus file lama supaya bener-bener ke-update dari assets
    if (await File(path).exists()) {
      await deleteDatabase(path);
    }

    try {
      await Directory(dirname(path)).create(recursive: true);
      ByteData data = await rootBundle.load("assets/databases/$fileName");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } catch (e) {
      print("Gagal menyalin $fileName: $e");
    }

    return await openDatabase(path, readOnly: true);
  }

  // Getter masing-masing DB
  Future<Database> getSuraSearchDb() async => _suraSearchDb ??= await _initDatabase('sura-search.db');
  Future<Database> getAlquranDb() async => _alquranDb ??= await _initDatabase('alquran.db');
  Future<Database> getLatinDb() async => _latinDb ??= await _initDatabase('latin.db');
  Future<Database> getTerjemahanDb() async => _terjemahanDb ??= await _initDatabase('terjemahan.db');
  Future<Database> getJalalaynDb() async => _jalalaynDb ??= await _initDatabase('jalalayn.db');
  Future<Database> getKataDb() async => _kataDb ??= await _initDatabase('kata.db');

  // Ambil Daftar Surah dari tabel 'sura_search' (Sesuai foto 18669.jpg)
  Future<List<Map<String, dynamic>>> getSurahList() async {
    final db = await getSuraSearchDb();
    return await db.query('sura_search');
  }
}
