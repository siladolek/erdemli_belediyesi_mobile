import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String title;
  final String description;
  final String imageUrl;
  final String date;
  final String detailUrl;
  final String category;
  final String location;

  EventModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.detailUrl,
    required this.category,
    required this.location,
  });

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return EventModel(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      date: data['date'] ?? '',
      detailUrl: data['detailUrl'] ?? '',
      category: data['category'] ?? 'Etkinlik',
      location: data['location'] ?? 'Erdemli',
    );
  }
}

class EventService {
  static Future<List<EventModel>> fetchEvents() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('events')
          .get(); // Firebase'den tüm etkinlikleri ham haliyle alıyoruz

      List<EventModel> events = snapshot.docs
          .map((doc) => EventModel.fromFirestore(doc))
          .toList();

      // Türkçe tarihleri anlayan (Örn: "17 Mayıs 2026, 12:00") ve en günceli en üste koyan sıralama algoritması
      events.sort((a, b) {
        int dateA = _parseTurkishDate(a.date);
        int dateB = _parseTurkishDate(b.date);
        return dateB.compareTo(dateA); // Büyükten küçüğe sıralar (En yeni en üstte)
      });

      return events;
    } catch (e) {
      print("Etkinlik çekme hatası: $e");
      return [];
    }
  }

  // Metin halindeki Türkçe tarihi, sıralanabilir bir rakama (Örn: 202605171200) dönüştürür
  static int _parseTurkishDate(String dateStr) {
    if (dateStr.isEmpty) return 0;

    final months = {
      'Ocak': '01', 'Şubat': '02', 'Mart': '03', 'Nisan': '04',
      'Mayıs': '05', 'Haziran': '06', 'Temmuz': '07', 'Ağustos': '08',
      'Eylül': '09', 'Ekim': '10', 'Kasım': '11', 'Aralık': '12'
    };

    try {
      // "17 Mayıs 2026, 12:00" formatındaki virgülü temizleyip boşluklardan bölüyoruz
      String cleanDate = dateStr.replaceAll(',', '');
      List<String> parts = cleanDate.split(' ');

      if (parts.length >= 4) {
        String day = parts[0].padLeft(2, '0');
        String month = months[parts[1]] ?? '01';
        String year = parts[2];
        String time = parts[3].replaceAll(':', ''); // "12:00" -> "1200"

        // 202605171200 gibi matematiksel olarak büyüklüğü kıyaslanabilir bir tam sayı oluşturuyoruz
        return int.parse('$year$month$day$time');
      }
    } catch (e) {
      return 0; // Tarih okunamıyorsa en alta atar
    }
    return 0;
  }
}