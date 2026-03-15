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

  Future<Database> _getDb(String fileName) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, fileName);

    // JURUS PAMUNGKAS: Hapus file lama di sistem HP supaya diganti yang baru dari assets
    // Nanti kalau udah stabil, bagian 'delete' ini bisa kita hapus
    if (await File(path).exists()) {
      await deleteDatabase(path);
    }

    // Proses copy dari Assets ke HP
    try {
      await Directory(dirname(path)).create(recursive: true);
      ByteData data = await rootBundle.load("assets/databases/$fileName");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      print("Berhasil menyalin $fileName ke sistem.");
    } catch (e) {
      print("Gagal menyalin database: $e");
    }

    return await openDatabase(path, readOnly: true);
  }

  Future<Database> getSuraSearchDb() async => _suraSearchDb ??= await _getDb('sura-search.db');
  Future<Database> getAlquranDb() async => _alquranDb ??= await _getDb('alquran.db');
  Future<Database> getLatinDb() async => _latinDb ??= await _getDb('latin.db');
  Future<Database> getTerjemahanDb() async => _terjemahanDb ??= await _getDb('terjemahan.db');
  Future<Database> getJalalaynDb() async => _jalalaynDb ??= await _getDb('jalalayn.db');
  Future<Database> getKataDb() async => _kataDb ??= await _getDb('kata.db');

  // Fungsi ambil daftar surah
  Future<List<Map<String, dynamic>>> getSurahList() async {
    final db = await getSuraSearchDb();
    // Berdasarkan screenshot lu, nama tabelnya adalah 'data'
    return await db.query('data');
  }
}
