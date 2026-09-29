import 'package:cloud_firestore/cloud_firestore.dart';

class NewsModel {
  final String title;
  final String date;
  final String link;
  final String summary;
  final String imageUrl;
  final String category;

  NewsModel({
    required this.title,
    required this.date,
    required this.link,
    required this.summary,
    required this.imageUrl,
    this.category = 'Haber',
  });
}

class NewsService {
  static String _fixImageUrl(String? url) {
    if (url == null || url.isEmpty) return 'https://www.erdemli.bel.tr/images/logo.png';
    if (url.startsWith('//')) return 'https:$url';
    if (url.startsWith('/')) return 'https://www.erdemli.bel.tr$url';
    if (url.startsWith('http://')) return url.replaceFirst('http://', 'https://');
    return url;
  }

  static Future<List<NewsModel>> fetchNews() async {
    List<NewsModel> list = [];
    try {
      final snapshot = await FirebaseFirestore.instance.collection('news').get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        list.add(NewsModel(
          title: data['title'] ?? 'Başlıksız Haber',
          date: data['date'] ?? 'Güncel',
          link: data['link'] ?? 'https://www.erdemli.bel.tr',
          // Akıllı arama: Hem summary hem description etiketini kontrol et
          summary: data['summary'] ?? data['description'] ?? '',
          imageUrl: _fixImageUrl(data['imageUrl']),
          category: data['category'] ?? 'Haber',
        ));
      }
    } catch (e) {
      print('Haberler çekilemedi: $e');
    }
    return list;
  }
}