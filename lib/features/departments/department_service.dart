import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class DepartmentModel {
  final String name;
  final String description;
  final String link;

  DepartmentModel({
    required this.name,
    required this.description,
    required this.link,
  });
}

class DepartmentService {
  static Future<List<DepartmentModel>> fetchDepartments() async {
    List<DepartmentModel> departmentList = [];
    final url = 'https://www.erdemli.bel.tr/mudurlukler'; // Gerçek URL

    try {
      final uri = Uri.parse(url);
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        var document = parser.parse(utf8.decode(response.bodyBytes));

        // Müdürlüklerin listelendiği muhtemel menü veya grid class'ları
        var elements = document.querySelectorAll('.mudurluk-item, .department-box, .mudurlukler li, .kurumsal-menu li a');

        for (var element in elements) {
          String name = element.text.trim();

          // "Müdürlüğü" kelimesi geçenleri filtreleyip temiz bir liste alıyoruz
          if (name.isNotEmpty && name.toLowerCase().contains('müdürlüğü')) {

            String detailLink = element.attributes['href'] ?? element.querySelector('a')?.attributes['href'] ?? '';
            if (detailLink.isNotEmpty && !detailLink.startsWith('http')) {
              detailLink = detailLink.startsWith('/') ? 'https://www.erdemli.bel.tr$detailLink' : 'https://www.erdemli.bel.tr/$detailLink';
            }

            departmentList.add(DepartmentModel(
              name: name,
              description: 'Birim görev ve yetkileri için tıklayın.',
              link: detailLink,
            ));
          }
        }

        // MASTER PROMPT KURALI: LOGLAMA
        print("=========================================");
        print("[BİRİMLER] YÜKLEME BAŞARILI");
        print("URL: $url");
        print("HTTP STATUS: ${response.statusCode}");
        print("PARSED ITEMS: ${departmentList.length}");
        print("=========================================");

      } else {
        print("[BİRİMLER] HTTP HATA STATUS: ${response.statusCode}");
      }
    } catch (e) {
      print("[BİRİMLER] BAĞLANTI/PARSE HATASI: $e");
    }

    return departmentList;
  }
}