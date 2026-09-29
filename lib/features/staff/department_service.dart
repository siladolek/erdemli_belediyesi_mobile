import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class DepartmentModel {
  final String name;
  final String description;
  final String phone;
  final String email;
  final String workingHours;
  final String link; // UI kodlarıyla uyumlu olması için 'link' olarak güncellendi

  DepartmentModel({
    required this.name,
    required this.description,
    required this.phone,
    required this.email,
    required this.workingHours,
    required this.link,
  });
}

class DepartmentService {
  static const String baseUrl = 'https://www.erdemli.bel.tr';

  static Future<List<DepartmentModel>> fetchDepartments() async {
    List<DepartmentModel> departmentsList = [];
    final url = '$baseUrl/mudurlukler';

    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Türkçe karakter bozulmalarını önlemek için UTF-8 decode kullanıldı
        var document = parser.parse(utf8.decode(response.bodyBytes));

        // Gerçek web sitesinde olabilecek olası class isimleri genişletildi
        var elements = document.querySelectorAll('.birim-item, .department-card, article, li, .box, .list-group-item');

        for (var element in elements) {
          String name = element.querySelector('h3, h4, h2, a, .title, strong')?.text.trim() ?? '';

          if (name.length >= 3) {
            String link = element.querySelector('a')?.attributes['href'] ?? '';
            if (link.isNotEmpty) {
              if (link.startsWith('http')) {
                // Tam adres
              } else if (link.startsWith('/')) {
                link = '$baseUrl$link';
              } else {
                link = '$baseUrl/$link';
              }
            } else {
              link = url;
            }

            String description = element.querySelector('.aciklama, p, .desc')?.text.trim() ?? 'Birim hakkında detaylı bilgi için web sitesini ziyaret ediniz.';
            String phone = element.querySelector('.telefon, .phone, a[href^="tel:"]')?.text.trim() ?? '0 (324) 515 10 26';
            String email = element.querySelector('.eposta, .email, a[href^="mailto:"]')?.text.trim() ?? 'bilgi@erdemli.bel.tr';
            String workingHours = element.querySelector('.mesai, .saat, .hours')?.text.trim() ?? 'Pazartesi - Cuma: 08:00 - 17:00';

            if (!departmentsList.any((d) => d.name == name)) {
              departmentsList.add(DepartmentModel(
                name: name,
                description: description,
                phone: phone,
                email: email,
                workingHours: workingHours,
                link: link,
              ));
            }
          }
        }

        // MASTER PROMPT KURALI: GÜVENLİ LOGLAMA
        print("=========================================");
        print("[BİRİMLER_DEBUG] YÜKLEME BAŞARILI");
        print("[BİRİMLER_DEBUG] URL: $url");
        print("[BİRİMLER_DEBUG] HTTP STATUS: ${response.statusCode}");
        print("[BİRİMLER_DEBUG] PARSED ITEMS: ${departmentsList.length}");
        print("=========================================");

      } else {
        print("[BİRİMLER_DEBUG] HTTP HATA STATUS: ${response.statusCode}");
      }
    } catch (e) {
      print("[BİRİMLER_DEBUG] BAĞLANTI/PARSE HATASI: $e");
    }

    // Veri gelmezse exception fırlatmak yerine boş liste dönüyoruz.
    // UI tarafındaki `snapshot.data!.isEmpty` kontrolü bunu yakalayarak Empty State (Veri Bulunamadı) ekranını gösterecektir.
    return departmentsList;
  }
}