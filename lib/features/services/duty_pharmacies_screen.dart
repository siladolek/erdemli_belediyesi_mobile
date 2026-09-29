import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // GERÇEK HARİTA VE ARAMA İÇİN

class DutyPharmaciesScreen extends StatefulWidget {
  const DutyPharmaciesScreen({super.key});

  @override
  State<DutyPharmaciesScreen> createState() => _DutyPharmaciesScreenState();
}

class _DutyPharmaciesScreenState extends State<DutyPharmaciesScreen> {
  final Color denizMavisi = const Color(0xFF154360);
  final Color arkaPlan = const Color(0xFFF8F9FA);

  List<Map<String, dynamic>> _pharmacies = [];
  bool _isLoading = true;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _fetchDutyPharmacies();
  }

  // İsimleri Düzelten Fonksiyon
  String _toTurkishTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.toLowerCase().split(' ').map((word) {
      if (word.isEmpty) return word;
      String firstChar = word[0];
      if (firstChar == 'i') firstChar = 'İ';
      else if (firstChar == 'ı') firstChar = 'I';
      else if (firstChar == 'ş') firstChar = 'Ş';
      else if (firstChar == 'ç') firstChar = 'Ç';
      else if (firstChar == 'ğ') firstChar = 'Ğ';
      else if (firstChar == 'ö') firstChar = 'Ö';
      else if (firstChar == 'ü') firstChar = 'Ü';
      else firstChar = firstChar.toUpperCase();
      return firstChar + word.substring(1);
    }).join(' ');
  }

  // GERÇEK HARİTALAR UYGULAMASINI AÇAN FONKSİYON
  Future<void> _launchMap(String? loc, String? address) async {
    // Önce koordinat (loc) varsa onu deniyoruz, çok daha kesindir.
    if (loc != null && loc.isNotEmpty) {
      final coords = loc.split(','); // "36.602,34.305" formatını ayırır
      if (coords.length == 2) {
        final lat = coords[0];
        final lng = coords[1];
        final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
        if (await canLaunchUrl(googleMapsUrl)) {
          await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
          return;
        }
      }
    }

    // Koordinat yoksa adresten aratıyoruz
    if (address != null && address.isNotEmpty) {
      final encodedAddress = Uri.encodeComponent(address);
      final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encodedAddress');
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
        return;
      }
    }

    // İkisi de başarısız olursa uyarı ver
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harita açılamadı.')));
    }
  }

  // GERÇEK TELEFON ARAMASI YAPAN FONKSİYON
  Future<void> _makePhoneCall(String? phone) async {
    if (phone != null && phone.isNotEmpty) {
      // Telefon numarasındaki boşlukları vs. temizle
      final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
      final Uri telUrl = Uri.parse('tel:$cleanPhone');
      if (await canLaunchUrl(telUrl)) {
        await launchUrl(telUrl);
        return;
      }
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Arama başlatılamadı. Geçersiz numara.')));
    }
  }

  Future<void> _fetchDutyPharmacies() async {
    const String apiKey = 'apikey 7k5mjVbGxSZYJODjf6U8Eg:1PL6slVhf0oLN7QQJFpjIa';

    try {
      final response = await http.get(
        Uri.parse('https://api.collectapi.com/health/dutyPharmacy?ilce=Erdemli&il=Mersin'),
        headers: {
          'authorization': apiKey,
          'content-type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        if (decodedData['success'] == true && mounted) {
          setState(() {
            _pharmacies = List<Map<String, dynamic>>.from(decodedData['result']);
            _isLoading = false;
          });
        } else {
          if (mounted) setState(() { _errorMessage = "Eczane verileri alınamadı."; _isLoading = false; });
        }
      } else {
        if (mounted) setState(() { _errorMessage = "Sunucu Hatası veya API Anahtarı eksik."; _isLoading = false; });
      }
    } catch (e) {
      if (mounted) setState(() { _errorMessage = "Bağlantı hatası. İnternetinizi kontrol edin."; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final List<String> aylar = ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"];
    final String bugunTarih = "${now.day} ${aylar[now.month - 1]} ${now.year}";

    return Scaffold(
      backgroundColor: arkaPlan,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Nöbetçi Eczaneler',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: denizMavisi),
        ),
        iconTheme: IconThemeData(color: denizMavisi),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SADE VE ZARİF BAŞLIK
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.calendar_month_rounded, color: Colors.red.shade500, size: 24),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Erdemli Nöbetçi Eczaneleri",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: denizMavisi, fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      bugunTarih,
                      style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // LİSTE ALANI
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.red.shade400))
                : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage, style: GoogleFonts.poppins(color: Colors.red.shade600)))
                : _pharmacies.isEmpty
                ? Center(child: Text('Şu an için nöbetçi eczane bilgisi bulunmuyor.', style: GoogleFonts.poppins(color: Colors.grey)))
                : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: _pharmacies.length,
              itemBuilder: (context, index) {
                final eczane = _pharmacies[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // Sol taraftaki şık kırmızı çizgi detayı
                        border: Border(left: BorderSide(color: Colors.red.shade400, width: 6)),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ÜST KISIM: ECZANE ADI VE MESAFE
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  _toTurkishTitleCase(eczane['name'] ?? 'İsimsiz Eczane'),
                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: denizMavisi),
                                ),
                              ),
                              if (eczane['dist'] != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                                  child: Text(eczane['dist'], style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // ORTA KISIM: ADRES
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.location_on_outlined, size: 18, color: Colors.grey.shade500),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  eczane['address'] ?? 'Adres bilgisi yok',
                                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600, height: 1.4),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // ALT KISIM: GERÇEK ÇALIŞAN BUTONLAR
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: denizMavisi,
                                    side: BorderSide(color: Colors.grey.shade300),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  icon: const Icon(Icons.directions_outlined, size: 18),
                                  label: Text('Yol Tarifi', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                                  onPressed: () => _launchMap(eczane['loc'], eczane['address']),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade500,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  icon: const Icon(Icons.phone_outlined, size: 18),
                                  label: Text('Hemen Ara', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                                  onPressed: () => _makePhoneCall(eczane['phone']),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}