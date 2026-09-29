import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class ServiceModel {
  final String title;
  final String description;
  final String link;
  final String category;

  ServiceModel({
    required this.title,
    required this.description,
    required this.link,
    required this.category,
  });
}

class ServiceService {
  static Future<List<ServiceModel>> fetchServices() async {
    List<ServiceModel> serviceList = [];
    final url = 'https://www.erdemli.bel.tr/hizmetlerimiz'; // Gerçek URL

    try {
      final uri = Uri.parse(url);
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        var document = parser.parse(utf8.decode(response.bodyBytes));

        // Belediyelerin hizmet listesini tuttuğu muhtemel class'lar
        var elements = document.querySelectorAll('.hizmet-item, .service-box, .hizmetlerimiz .col-md-4, .card-service');

        for (var element in elements) {
          String title = element.querySelector('h3, h4, .title, strong')?.text.trim() ?? '';

          if (title.isNotEmpty) {
            String detailLink = element.querySelector('a')?.attributes['href'] ?? '';
            if (detailLink.isNotEmpty && !detailLink.startsWith('http')) {
              detailLink = detailLink.startsWith('/') ? 'https://www.erdemli.bel.tr$detailLink' : 'https://www.erdemli.bel.tr/$detailLink';
            }

            String description = element.querySelector('p, .desc, .summary')?.text.trim() ?? 'Hizmet detayı için tıklayın.';

            serviceList.add(ServiceModel(
              title: title,
              description: description,
              link: detailLink,
              category: 'E-Belediye', // Varsayılan kategori
            ));
          }
        }

        // MASTER PROMPT KURALI: LOGLAMA
        print("=========================================");
        print("[HİZMETLER] YÜKLEME BAŞARILI");
        print("URL: $url");
        print("HTTP STATUS: ${response.statusCode}");
        print("PARSED ITEMS: ${serviceList.length}");
        print("=========================================");

      } else {
        print("[HİZMETLER] HTTP HATA STATUS: ${response.statusCode}");
      }
    } catch (e) {
      print("[HİZMETLER] BAĞLANTI/PARSE HATASI: $e");
    }

    return serviceList;
  }
}