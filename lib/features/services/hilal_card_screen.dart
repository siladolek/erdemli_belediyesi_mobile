import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HilalCardScreen extends StatelessWidget {
  const HilalCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // HİLAL KART ÖZEL RENK PALETİ (Menüdeki ikon rengine uyumlu: Kahverengi tonları)
    final Color anaRenk = const Color(0xFF6D4C41);
    final Color koyuRenk = const Color(0xFF4E342E);
    final Color arkaPlan = const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: arkaPlan,
      appBar: AppBar(
        backgroundColor: arkaPlan,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Hilal Kart Başvurusu',
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
                    child: const Icon(Icons.credit_card_rounded, color: Colors.white, size: 36),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Sosyal Destek Kartı", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 4),
                        Text(
                          "İhtiyaç sahibi vatandaşlarımız için Erdemli Belediyesi sosyal destek projesi.",
                          style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 13, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // İÇERİK KARTI: HİLAL KART NEDİR?
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
                      Icon(Icons.info_outline_rounded, color: anaRenk, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        "Hilal Kart Nedir?",
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: koyuRenk),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Hilal Kart, Erdemli Belediyesi Sosyal Yardım İşleri Müdürlüğü tarafından, ilçemizde ikamet eden ihtiyaç sahibi vatandaşlarımıza verilen ön ödemeli bir alışveriş kartıdır.",
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Bu kart ile vatandaşlarımız, anlaşmalı yerel marketlerden temel gıda ve ihtiyaç malzemelerini kendi tercihleri doğrultusunda rahatça alabilmektedir.",
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // İÇERİK KARTI: GEREKLİ BELGELER
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
                      Icon(Icons.document_scanner_rounded, color: Colors.orange.shade500, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        "Başvuru İçin Gerekli Evraklar",
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: koyuRenk),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRequirementItem("Başvuru Dilekçesi (Müdürlükten temin edilecek)", anaRenk),
                  _buildRequirementItem("Kimlik Fotokopisi", anaRenk),
                  _buildRequirementItem("İkametgah Belgesi (E-Devlet üzerinden alınabilir)", anaRenk),
                  _buildRequirementItem("Vukuatlı Nüfus Kayıt Örneği (Tüm aileyi gösterir)", anaRenk),
                  _buildRequirementItem("Gelir Durumunu Gösterir Belge (Varsa maaş bordrosu veya SGK dökümü)", anaRenk),
                  _buildRequirementItem("Fakirlik İlmuhaberi (Mahalle Muhtarlığından onaylı)", anaRenk),
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