import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String category;
  final double rating;
  final String address;
  final double? latitude;  // YOL TARİFİ İÇİN GEREKLİ
  final double? longitude; // YOL TARİFİ İÇİN GEREKLİ

  PlaceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.address,
    this.latitude,
    this.longitude,
  });

  factory PlaceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // GÖRSEL ÇÖZÜMÜ: 'imageUrls' (liste) varsa ilkini al, yoksa 'imageUrl' (string) al.
    String parsedImageUrl = '';
    if (data.containsKey('imageUrls') && data['imageUrls'] is List && (data['imageUrls'] as List).isNotEmpty) {
      parsedImageUrl = data['imageUrls'][0];
    } else if (data.containsKey('imageUrl') && data['imageUrl'] != null) {
      parsedImageUrl = data['imageUrl'];
    }

    return PlaceModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: parsedImageUrl,
      category: data['category'] ?? 'Genel',
      rating: (data['rating'] ?? 0.0).toDouble(),
      address: data['address'] ?? '',
      latitude: data['latitude'] != null ? double.tryParse(data['latitude'].toString()) : null,
      longitude: data['longitude'] != null ? double.tryParse(data['longitude'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}