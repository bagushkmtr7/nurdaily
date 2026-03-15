import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/dua_model.dart';

class DuaService {
  // Endpoint utama sesuai screenshot lu
  static const String baseUrl = 'https://doa-doa-api-ahmadramadhan.fly.dev/api';

  Future<List<DuaModel>> getAllDuas() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      
      if (response.statusCode == 200) {
        // Kalau sukses dapet data, ubah jadi List of DuaModel
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => DuaModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data dari server');
      }
    } catch (e) {
      print('Error API Doa: $e');
      return [];
    }
  }
}
