import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class PlacesEnrichmentService {
  // Google Cloud Console API Anahtarın
  static const String _apiKey = 'AIzaSyD86BqLxgKfw0XMOViDMozaZLIFfU5J5OY';

  static Future<String> enrichAllPlaces() async {
    final metaDoc = FirebaseFirestore.instance.collection('meta').doc('placesEnrichment');
    final metaSnapshot = await metaDoc.get();
    if (metaSnapshot.exists && metaSnapshot.data()?['done'] == true) {
      return 'Zaten tamamlanmış';
    }

    final collection = FirebaseFirestore.instance.collection('places');
    final snapshot = await collection.get();

    int updated = 0;
    int skipped = 0;
    int failed = 0;

    for (final doc in snapshot.docs) {
      final data = doc.data();

      if (data['photoEnrichedAt'] != null) {
        skipped++;
        continue;
      }

      final String name = data['name'] ?? '';
      final String address = data['address'] ?? '';
      if (name.isEmpty) {
        failed++;
        continue;
      }

      try {
        final searchQuery = '$name $address';
        final uri = Uri.parse('https://places.googleapis.com/v1/places:searchText');

        final response = await http.post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': _apiKey,
            'X-Goog-FieldMask': 'places.id,places.location,places.photos',
          },
          body: jsonEncode({'textQuery': searchQuery}),
        );

        if (response.statusCode == 200) {
          final jsonBody = jsonDecode(response.body);
          final places = jsonBody['places'] as List<dynamic>?;

          if (places != null && places.isNotEmpty) {
            final place = places[0];
            final location = place['location'];
            final photos = place['photos'] as List<dynamic>?;

            final Map<String, dynamic> updateData = {
              'photoEnrichedAt': DateTime.now().toIso8601String(),
            };

            if (location != null) {
              updateData['latitude'] = location['latitude'];
              updateData['longitude'] = location['longitude'];
            }

            if (photos != null && photos.isNotEmpty) {
              final photoName = photos[0]['name'];
              updateData['imageUrl'] = 'https://places.googleapis.com/v1/$photoName/media?maxWidthPx=800&key=$_apiKey';
            }

            await doc.reference.update(updateData);
            updated++;
          } else {
            failed++;
          }
        } else {
          failed++;
        }
      } catch (e) {
        failed++;
      }
      // Google API kota sınırına takılmamak için 300ms bekleme
      await Future.delayed(const Duration(milliseconds: 300));
    }

    await metaDoc.set({'done': true, 'completedAt': DateTime.now().toIso8601String()});
    return 'Güncellenen: $updated, Atlanan: $skipped, Başarısız: $failed';
  }
}