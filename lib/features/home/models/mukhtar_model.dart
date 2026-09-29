class MukhtarModel {
  final String id;
  final String mahalleAdi;
  final String muhtarAdi;
  final String telefon;

  MukhtarModel({
    required this.id,
    required this.mahalleAdi,
    required this.muhtarAdi,
    required this.telefon,
  });

  factory MukhtarModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return MukhtarModel(
      id: documentId,
      mahalleAdi: data['mahalleAdi'] ?? 'Bilinmeyen Mahalle',
      muhtarAdi: data['muhtarAdi'] ?? 'İsimsiz Muhtar',
      telefon: data['telefon'] ?? '-',
    );
  }
}