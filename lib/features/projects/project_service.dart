import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String title;
  final String category;
  final String status;
  final String location;
  final String imageUrl;
  final String description;
  final String link;
  final String date;

  ProjectModel({
    required this.title,
    required this.category,
    required this.status,
    required this.location,
    required this.imageUrl,
    required this.description,
    required this.link,
    required this.date,
  });
}

class ProjectService {
  static String _fixImageUrl(String? url) {
    if (url == null || url.isEmpty) return 'https://www.erdemli.bel.tr/images/logo.png';
    if (url.startsWith('//')) return 'https:$url';
    if (url.startsWith('/')) return 'https://www.erdemli.bel.tr$url';
    if (url.startsWith('http://')) return url.replaceFirst('http://', 'https://');
    return url;
  }

  static Future<List<ProjectModel>> fetchProjects() async {
    List<ProjectModel> list = [];
    try {
      final snapshot = await FirebaseFirestore.instance.collection('projects').get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        list.add(ProjectModel(
          title: data['title'] ?? 'Proje',
          category: data['category'] ?? 'Proje',
          status: data['status'] ?? 'Devam Eden Projeler',
          location: data['location'] ?? 'Erdemli',
          imageUrl: _fixImageUrl(data['imageUrl']),
          // Akıllı arama: Hem description hem summary etiketini kontrol et
          description: data['description'] ?? data['summary'] ?? '',
          link: data['link'] ?? 'https://www.erdemli.bel.tr',
          date: data['date'] ?? 'Güncel',
        ));
      }
    } catch (e) {
      print('Projeler çekilemedi: $e');
    }
    return list;
  }
}