import 'package:cloud_firestore/cloud_firestore.dart';

/// Haber modeli — Firestore'dan okunan haber verisi.
///
/// Firestore koleksiyon yapısı (news):
/// ```
/// {
///   "title": "Sahil Yolu Yenilendi",
///   "summary": "Erdemli sahil yolu projesi tamamlandı...",
///   "imageUrl": "https://...",
///   "date": Timestamp,
///   "category": "Belediye Haberleri",
///   "link": "https://..."
/// }
/// ```
class NewsModel {
  final String id;
  final String title;
  final String summary;
  final String imageUrl;
  final DateTime date;
  final String category;
  final String link;

  NewsModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.date,
    required this.category,
    required this.link,
  });

  /// Firestore DocumentSnapshot'tan model oluşturur.
  factory NewsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NewsModel(
      id: doc.id,
      title: data['title'] ?? '',
      summary: data['summary'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      category: data['category'] ?? 'Genel',
      link: data['link'] ?? '',
    );
  }

  /// Modeli Firestore'a yazılabilir Map'e çevirir.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'summary': summary,
      'imageUrl': imageUrl,
      'date': Timestamp.fromDate(date),
      'category': category,
      'link': link,
    };
  }

  /// Tarihi "dd.MM.yyyy" formatında döner.
  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }
}
