import 'package:cloud_firestore/cloud_firestore.dart';

// 1. DUYURU MODELİ (Veritabanından gelen verilerin kalıbı)
class AnnouncementModel {
  final String title;
  final String summary;
  final String imageUrl;
  final String date;
  final String link;
  final String category;

  AnnouncementModel({
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.date,
    required this.link,
    required this.category,
  });

  factory AnnouncementModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return AnnouncementModel(
      title: data['title'] ?? '',
      summary: data['summary'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      date: data['date'] ?? 'Güncel',
      link: data['link'] ?? '',
      category: data['category'] ?? 'Duyuru',
    );
  }
}

// 2. DUYURU SERVİSİ (Firebase'den verileri çeken motor)
class AnnouncementService {
  static Future<List<AnnouncementModel>> fetchAnnouncements() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('announcements')
          .orderBy('scrapedAt', descending: true) // En son çekilenler en üstte
          .get();

      return snapshot.docs
          .map((doc) => AnnouncementModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("Duyuru çekme hatası: $e");
      return [];
    }
  }
}