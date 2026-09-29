import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BusinessLicenseScreen extends StatelessWidget {
  const BusinessLicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // İŞYERİ AÇMA RUHSATI ÖZEL RENK PALETİ (Menüdeki ikon rengine uyumlu: Turuncu tonları)
    final Color anaRenk = const Color(0xFFFB8C00);
    final Color koyuRenk = const Color(0xFFE65100);
    final Color arkaPlan = const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: arkaPlan,
      appBar: AppBar(
        backgroundColor: arkaPlan,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'İşyeri Açma Ruhsatı',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: koyuRenk),
        ),
        iconTheme: IconThemeData(color: koyuRenk),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ÜST BİLGİ KARTI (HERO BANNER)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [koyuRenk, anaRenk],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: anaRenk.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 36),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ruhsat Başvurusu", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 4),
                        Text(
                          "İşyeri açma ve çalışma ruhsatı için gerekli evraklar ve başvuru süreçleri.",
                          style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 13, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // İÇERİK KARTI: UMUMA AÇIK İSTİRAHAT VE EĞLENCE YERİ
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.assignment_turned_in_rounded, color: anaRenk, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Umuma Açık İstirahat ve Eğlence Yeri İçin İstenen Belgeler",
                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: koyuRenk),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRequirementItem("1- Tapu fotokopisi", anaRenk),
                  _buildRequirementItem("2- Kira kontratı Aslı (mal sahibi ile yapılmamış ise vekaletname, tapuda hisseli ise muvafakatname)", anaRenk),
                  _buildRequirementItem("3- Yapı kullanma izin belgesi (Belediye imar müdürlüğünden onaylı)", anaRenk),
                  _buildRequirementItem("4- Vergi levhası fotokopisi", anaRenk),
                  _buildRequirementItem("5- Kimlik fotokopisi", anaRenk),
                  _buildRequirementItem("6- Ustalık belgesi (gerekli işyerleri için)", anaRenk),
                  _buildRequirementItem("7- Esnaf Sicil Tasdiknamesi - Oda Üyelik belgesi veya Ticaret odası üyelik belgesi", anaRenk),
                  _buildRequirementItem("8- Şirket ise Ticaret Sicili Gazetesi ana şirket sözleşmesi ve imza sirküleri", anaRenk),
                  _buildRequirementItem("9- İtfaiye raporu", anaRenk),
                  _buildRequirementItem("10- Bulaşıcı hastalık olmadığına dair sağlık raporu (Çalışanlardan)", anaRenk),
                  _buildRequirementItem("11- 1 adet Renkli fotoğraf ve bir adet plastik dosya", anaRenk),
                  _buildRequirementItem("12- Devir ise devir dilekçesi ve eski ruhsat", anaRenk),
                  _buildRequirementItem("13- Adli sicil belgesi", anaRenk),
                  _buildRequirementItem("14- Kolluk kuvveti görüş yazısı", anaRenk),
                  _buildRequirementItem("15- Mesafe krokisi", anaRenk),
                ],
              ),
            ),

            const SizedBox(height: 20), // Ekranın en altına yapışmaması için minik bir boşluk
          ],
        ),
      ),
    );
  }

  // Liste elemanları için yardımcı tasarım fonksiyonu
  Widget _buildRequirementItem(String text, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(Icons.arrow_forward_ios_rounded, color: iconColor, size: 10),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}