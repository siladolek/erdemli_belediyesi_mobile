import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'e_zoning_screen.dart';
import 'duty_pharmacies_screen.dart';
import 'mukhtars_screen.dart';
import 'e_belediye_screen.dart';
import 'building_usage_screen.dart';
import 'construction_permit_screen.dart';
import 'numbering_screen.dart';
import 'tax_operations_screen.dart';
import 'business_license_screen.dart';
import 'marriage_services_screen.dart' hide BusinessLicenseScreen;
import 'hilal_card_screen.dart';
import 'enterprises_screen.dart'; // İŞLETME VE İŞTİRAKLER EKLENDİ

class OnlineHizmetlerScreen extends StatelessWidget {
  const OnlineHizmetlerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color denizMavisi = const Color(0xFF154360);
    final Color acikMavi = const Color(0xFF2980B9);
    final Color arkaPlan = const Color(0xFFF8F9FA);

    // Bütün modüller artık Native (yerel) ekran oldu!
    final List<Map<String, dynamic>> services = [
      {
        'title': 'Nöbetçi Eczaneler',
        'subtitle': 'Güncel nöbetçi eczane listesi',
        'icon': Icons.local_pharmacy_rounded,
        'color': const Color(0xFFE53935),
        'type': 'screen',
      },
      {
        'title': 'Muhtarlıklar',
        'subtitle': 'Mahalle muhtarları ve iletişim',
        'icon': Icons.badge_rounded,
        'color': const Color(0xFF43A047),
        'type': 'screen',
      },
      {
        'title': 'İmar İşleri',
        'subtitle': 'E-İmar sorgulama ve belgeler',
        'icon': Icons.architecture_rounded,
        'color': acikMavi,
        'type': 'screen',
      },
      {
        'title': 'Yapı Kullanım',
        'subtitle': 'İskan ve kullanım izinleri',
        'icon': Icons.fact_check_rounded,
        'color': denizMavisi,
        'type': 'screen',
      },
      {
        'title': 'İnşaat Ruhsatı',
        'subtitle': 'Ruhsat başvuru evrakları',
        'icon': Icons.handyman_rounded,
        'color': const Color(0xFF8D6E63),
        'type': 'screen',
      },
      {
        'title': 'Numarataj',
        'subtitle': 'Adres tespit işlemleri',
        'icon': Icons.location_on_rounded,
        'color': const Color(0xFF5C6BC0),
        'type': 'screen',
      },
      {
        'title': 'Vergi İşlemleri',
        'subtitle': 'Emlak ve çevre vergisi sorgulama',
        'icon': Icons.receipt_long_rounded,
        'color': const Color(0xFF00897B),
        'type': 'screen',
      },
      {
        'title': 'İşyeri Açma Ruhsatı',
        'subtitle': 'İşyeri ruhsat başvuru bilgileri',
        'icon': Icons.storefront_rounded,
        'color': const Color(0xFFFB8C00),
        'type': 'screen',
      },
      {
        'title': 'Evlilik Hizmetleri',
        'subtitle': 'Nikah başvuru ve evrak bilgileri',
        'icon': Icons.favorite_rounded,
        'color': const Color(0xFFD81B60),
        'type': 'screen',
      },
      {
        'title': 'Hilal Kart Başvurusu',
        'subtitle': 'İhtiyaç sahiplerine sosyal destek kartı',
        'icon': Icons.credit_card_rounded,
        'color': const Color(0xFF6D4C41),
        'type': 'screen',
      },
      {
        'title': 'İşletme ve İştiraklerimiz',
        'subtitle': 'Belediyeye bağlı işletmeler',
        'icon': Icons.apartment_rounded,
        'color': const Color(0xFF3949AB),
        'type': 'screen',
      },
    ];

    return Scaffold(
      backgroundColor: arkaPlan,
      appBar: AppBar(
        backgroundColor: arkaPlan,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Online Hizmetler',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: denizMavisi),
        ),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final item = services[index];
          final Color itemColor = item['color'] as Color;

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                BoxShadow(color: itemColor.withOpacity(0.18), blurRadius: 22, spreadRadius: -4, offset: const Offset(0, 8)),
              ],
              border: Border.all(color: itemColor.withOpacity(0.12), width: 1),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  if (item['type'] == 'screen') {
                    switch (item['title']) {
                      case 'Nöbetçi Eczaneler':
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const DutyPharmaciesScreen()));
                        break;
                      case 'Muhtarlıklar':
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MukhtarsScreen()));
                        break;
                      case 'İmar İşleri':
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const EZoningScreen()));
                        break;
                      case 'Yapı Kullanım':
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const BuildingUsageScreen()));
                        break;
                      case 'İnşaat Ruhsatı':
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ConstructionPermitScreen()));
                        break;
                      case 'Numarataj':
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NumberingScreen()));
                        break;
                      case 'Vergi İşlemleri':
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const TaxOperationsScreen()));
                        break;
                      case 'İşyeri Açma Ruhsatı':
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const BusinessLicenseScreen()));
                        break;
                      case 'Evlilik Hizmetleri':
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MarriageServicesScreen()));
                        break;
                      case 'Hilal Kart Başvurusu':
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HilalCardScreen()));
                        break;
                      case 'İşletme ve İştiraklerimiz':
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const EnterprisesScreen()));
                        break;
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [itemColor, itemColor.withOpacity(0.7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(color: itemColor.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 3))],
                        ),
                        child: Icon(item['icon'] as IconData, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['title'] as String, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: denizMavisi)),
                            const SizedBox(height: 4),
                            Text(item['subtitle'] as String, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade500)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: itemColor.withOpacity(0.08), shape: BoxShape.circle),
                        child: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: itemColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}