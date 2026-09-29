import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class MayorModel {
  final String name;
  final String title;
  final String imageUrl;
  final String message;
  final String biography;
  final String vision;

  MayorModel({
    required this.name,
    required this.title,
    required this.imageUrl,
    required this.message,
    required this.biography,
    required this.vision,
  });
}

class MayorService {
  static const String baseUrl = 'https://www.erdemli.bel.tr';

  static Future<MayorModel> fetchMayorInfo() async {
    final url = '$baseUrl/baskan';

    try {
      final uri = Uri.parse(url);
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Türkçe karakter bozulmalarını önlemek için UTF-8 decode
        var document = parser.parse(utf8.decode(response.bodyBytes));

        // Genişletilmiş seçiciler (Gerçek web sitesine daha uyumlu ve esnek)
        String name = document.querySelector('.baskan-adi, .baskan-ismi, h1, h2')?.text.trim() ?? '';
        String title = document.querySelector('.baskan-unvani, .title, .unvan')?.text.trim() ?? 'Erdemli Belediye Başkanı';

        // Görsel URL birleştirme işlemleri
        String imgUrl = document.querySelector('.baskan-foto img, .baskan-resim img, img.baskan')?.attributes['src'] ?? '';
        if (imgUrl.isNotEmpty) {
          if (imgUrl.startsWith('//')) {
            imgUrl = 'https:$imgUrl';
          } else if (!imgUrl.startsWith('http')) {
            if (!imgUrl.startsWith('/')) imgUrl = '/$imgUrl';
            imgUrl = '$baseUrl$imgUrl';
          }
        }

        String message = document.querySelector('.baskan-mesaj, .mesaj, .quote')?.text.trim() ?? '';
        String biography = document.querySelector('.ozgecmis, .biography, p')?.text.trim() ?? '';
        String vision = document.querySelector('.vizyon, .misyon, .hedef')?.text.trim() ?? '';

        // MASTER PROMPT KURALI: GÜVENLİ LOGLAMA
        print("=========================================");
        print("[BAŞKAN_DEBUG] YÜKLEME BAŞARILI");
        print("[BAŞKAN_DEBUG] URL: $url");
        print("[BAŞKAN_DEBUG] HTTP STATUS: ${response.statusCode}");
        print("[BAŞKAN_DEBUG] RESPONSE SIZE: ${response.bodyBytes.length} bytes");
        print("=========================================");

        return MayorModel(
          name: name.isNotEmpty ? name : 'M. Mustafa Turgut', // Webden çekilemezse isim
          title: title,
          imageUrl: imgUrl,
          message: message,
          biography: biography,
          vision: vision,
        );
      } else {
        print("[BAŞKAN_DEBUG] HTTP HATA STATUS: ${response.statusCode}");
        throw Exception('Sunucu hatası: ${response.statusCode}');
      }
    } catch (e) {
      print("[BAŞKAN_DEBUG] BAĞLANTI/PARSE HATASI: $e");
      // UI tarafındaki FutureBuilder'ın hasError durumuna düşmesi için hatayı fırlatıyoruz
      throw Exception('Başkan bilgileri şu anda yüklenemiyor.');
    }
  }
}