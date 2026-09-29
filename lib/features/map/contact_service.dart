import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class ContactModel {
  final String address;
  final String phone;
  final String email;
  final String workingHours;

  ContactModel({
    required this.address,
    required this.phone,
    required this.email,
    required this.workingHours,
  });
}

class ContactService {
  static const String baseUrl = 'https://www.erdemli.bel.tr';

  static Future<ContactModel> fetchContactInfo() async {
    try {
      // Sitedeki iletişim sayfası
      final response = await http.get(Uri.parse('$baseUrl/iletisim')).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        var document = parser.parse(response.body);

        // NOT: '.adres', '.telefon' gibi class veya id'leri Erdemli Belediyesi
        // web sitesinin iletişim sayfasındaki gerçek HTML yapısına göre güncellemelisin.
        String address = document.querySelector('.adres')?.text ?? 'Merkez Mahallesi, Erdemli / Mersin';
        String phone = document.querySelector('.telefon')?.text ?? '0 (324) 515 10 26';
        String email = document.querySelector('.eposta')?.text ?? 'bilgi@erdemli.bel.tr';
        String workingHours = document.querySelector('.mesai')?.text ?? 'Pazartesi - Cuma: 08:00 - 17:00';

        return ContactModel(
          address: address.trim(),
          phone: phone.trim(),
          email: email.trim(),
          workingHours: workingHours.trim(),
        );
      } else {
        throw Exception('Sunucu hatası: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('İletişim bilgileri şu anda yüklenemiyor.');
    }
  }
}