import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class EBelediyeScreen extends StatelessWidget {
  const EBelediyeScreen({super.key});

  Future<void> _launchSecureUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppBrowserView);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bağlantı açılamadı.', style: GoogleFonts.poppins()),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color denizMavisi = const Color(0xFF154360);
    final Color acikMavi = const Color(0xFF2980B9);
    final Color arkaPlan = const Color(0xFFF8F9FA);

    // BÜTÜN LİNKLER DOĞRUDAN HEDEF SAYFAYA GİDECEK ŞEKİLDE GÜNCELLENDİ
    const String eBelediyeGiris = 'https://ebelediye.erdemli.bel.tr/Giris'; // Doğrudan giriş ekranı
    const String eDevletErdemli = 'https://www.turkiye.gov.tr/erdemli-belediyesi'; // Doğrudan e-devlet Erdemli sayfası

    const String hizliOdemeUrl = 'https://ebelediye.erdemli.bel.tr/HizliOdeme'; // Doğrudan hızlı ödeme
    const String borcSorgulamaUrl = 'https://ebelediye.erdemli.bel.tr/BorcSorgulama'; // Doğrudan borç ekranı
    const String makbuzDogrulamaUrl = 'https://ebelediye.erdemli.bel.tr/MakbuzDogrulama'; // Doğrudan makbuz
    const String sicilSorgulamaUrl = 'https://ebelediye.erdemli.bel.tr/SicilSorgulama'; // Doğrudan sicil
    const String rayicUrl = 'https://ebelediye.erdemli.bel.tr/RayicBedel'; // Doğrudan rayiç bedel
    const String ebysDogrulamaUrl = 'https://www.turkiye.gov.tr/icisleri-belediye-ebys';

    final List<Map<String, dynamic>> items = [
      {
        'title': 'Hızlı Ödeme',
        'subtitle': 'Üye olmadan hızlıca ödemenizi yapın',
        'icon': Icons.flash_on_rounded,
        'color': const Color(0xFF00897B),
        'url': hizliOdemeUrl,
      },
      {
        'title': 'Borç Sorgulama ve Ödeme',
        'subtitle': 'Güncel borç ve geçmiş dönem listesi',
        'icon': Icons.fact_check_rounded,
        'color': const Color(0xFFFB8C00),
        'url': borcSorgulamaUrl,
      },
      {
        'title': 'Makbuz Doğrulama',
        'subtitle': 'Geçmiş ödeme makbuzunuzu doğrulayın',
        'icon': Icons.receipt_long_rounded,
        'color': const Color(0xFF43A047),
        'url': makbuzDogrulamaUrl,
      },
      {
        'title': 'Üyelik ve Sicil Sorgulama',
        'subtitle': 'Emlak ve mükellefiyet bilgileri',
        'icon': Icons.badge_rounded,
        'color': const Color(0xFF3949AB),
        'url': sicilSorgulamaUrl,
      },
      {
        'title': 'Rayiçler ve Tarifeler',
        'subtitle': 'Güncel emlak rayiç bedelleri',
        'icon': Icons.real_estate_agent_rounded,
        'color': const Color(0xFF8E24AA),
        'url': rayicUrl,
      },
      {
        'title': 'EBYS Evrak Doğrulama',
        'subtitle': 'Resmi evrak doğrulama sistemi',
        'icon': Icons.verified_rounded,
        'color': const Color(0xFF546E7A),
        'url': ebysDogrulamaUrl,
      },
    ];

    return Scaffold(
      backgroundColor: arkaPlan,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: denizMavisi),
        title: Text(
          'E-Belediye İşlemleri',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: denizMavisi),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        children: [
          // --- GIRIS KARTLARI ---
          Row(
            children: [
              Expanded(
                child: _buildPremiumLoginBtn(
                  context: context,
                  title: 'Kullanıcı Girişi',
                  icon: Icons.person_rounded,
                  colors: [denizMavisi, acikMavi],
                  url: eBelediyeGiris,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildPremiumLoginBtn(
                  context: context,
                  title: 'e-Devlet ile Giriş',
                  icon: Icons.account_balance_rounded,
                  colors: [const Color(0xFFC62828), const Color(0xFFE53935)],
                  url: eDevletErdemli,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          Text('Hizmetler', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: denizMavisi)),
          const SizedBox(height: 14),

          ...items.map((item) {
            final Color itemColor = item['color'] as Color;
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                  BoxShadow(color: itemColor.withOpacity(0.15), blurRadius: 20, spreadRadius: -6, offset: const Offset(0, 8)),
                ],
                border: Border.all(color: itemColor.withOpacity(0.1)),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _launchSecureUrl(context, item['url'] as String),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [itemColor, itemColor.withOpacity(0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [BoxShadow(color: itemColor.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 3))],
                          ),
                          child: Icon(item['icon'] as IconData, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['title'] as String, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: denizMavisi)),
                              const SizedBox(height: 3),
                              Text(item['subtitle'] as String, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: itemColor.withOpacity(0.08), shape: BoxShape.circle),
                          child: Icon(Icons.arrow_forward_ios_rounded, size: 13, color: itemColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildPremiumLoginBtn({required BuildContext context, required String title, required IconData icon, required List<Color> colors, required String url}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _launchSecureUrl(context, url),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: colors.first.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 5))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(height: 10),
              Text(title, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}