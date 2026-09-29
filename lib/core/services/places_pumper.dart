import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class PlacesPumper {
  // TODO: Google'dan aldığın anahtarı buraya yapıştır
  static const String apiKey = "AIzaSyD86BqLxgKfw0XMOViDMozaZLIFfU5J5OY";

  static const Map<String, String> searchQueries = {
    "plaj": "Erdemli plajları",
    "tarihi_yer": "Erdemli tarihi yerler ve müzeler",
    "park": "Erdemli parklar ve mesire alanları",
    "kafe": "Erdemli kafeler",
    "restoran": "Erdemli restoranlar",
    "avm": "Erdemli alışveriş merkezleri"
  };

  static Future<void> fetchAndUploadPlaces() async {
    final firestore = FirebaseFirestore.instance;
    print("🚀 Veri çekme işlemi başlatılıyor...");

    for (var entry in searchQueries.entries) {
      String categoryId = entry.key;
      String query = entry.value;

      final url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey&language=tr';

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final results = data['results'] as List;

          for (var place in results) {
            String address = place['formatted_address'] ?? '';
            if (address.toLowerCase().contains("erdemli") || address.toLowerCase().contains("mersin")) {

              await firestore.collection('places').doc(place['place_id']).set({
                'id': place['place_id'],
                'name': place['name'],
                'category': categoryId,
                'address': address,
                'rating': place['rating']?.toDouble() ?? 0.0,
                'userRatingsTotal': place['user_ratings_total'] ?? 0,
                'latitude': place['geometry']['location']['lat'],
                'longitude': place['geometry']['location']['lng'],
                'photoReference': (place['photos'] != null && place['photos'].isNotEmpty)
                    ? place['photos'][0]['photo_reference']
                    : '',
              });
            }
          }
          print("✅ [$categoryId] kategorisi Firebase'e başarıyla yüklendi!");
        }
      } catch (e) {
        print("❌ Hata ($categoryId): $e");
      }
    }
    print("🎉 TÜM VERİLER FIREBASE'E BAŞARIYLA AKTARILDI!");
  }
}