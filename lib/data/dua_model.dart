class DuaModel {
  final String id;
  final String title;
  final String arabic;
  final String latin;
  final String translation;

  DuaModel({
    required this.id,
    required this.title,
    required this.arabic,
    required this.latin,
    required this.translation,
  });

  // Convert data dari API JSON ke bentuk yang dimengerti Flutter
  factory DuaModel.fromJson(Map<String, dynamic> json) {
    return DuaModel(
      id: json['id']?.toString() ?? '',
      title: json['doa'] ?? '', // API pake key 'doa' buat judul
      arabic: json['ayat'] ?? '', // API pake key 'ayat' buat tulisan arab
      latin: json['latin'] ?? '',
      translation: json['artinya'] ?? '',
    );
  }
}
