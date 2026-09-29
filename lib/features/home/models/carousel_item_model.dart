import 'package:cloud_firestore/cloud_firestore.dart';

/// Carousel (afiş) modeli — Ana sayfadaki kaydırmalı banner.
///
/// Firestore koleksiyon yapısı (carousel_items):
/// ```
/// {
///   "title": "Kızkalesi Sahil Projesi",
///   "subtitle": "Yeni sahil düzenlemesi başladı",
///   "imageUrl": "https://...",
///   "tag": "ÖNE ÇIKAN",
///   "order": 1
/// }
/// ```
class CarouselItemModel {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String tag;
  final int order;

  CarouselItemModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.tag,
    required this.order,
  });

  factory CarouselItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CarouselItemModel(
      id: doc.id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      tag: data['tag'] ?? 'ÖNE ÇIKAN',
      order: data['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'tag': tag,
      'order': order,
    };
  }
}
