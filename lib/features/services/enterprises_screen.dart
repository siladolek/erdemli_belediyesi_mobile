import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnterprisesScreen extends StatelessWidget {
  const EnterprisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // İŞLETME VE İŞTİRAKLER ÖZEL RENK PALETİ (Menüdeki ikon rengine uyumlu: Indigo tonları)
    final Color anaRenk = const Color(0xFF3949AB);
    final Color koyuRenk = const Color(0xFF283593);
    final Color arkaPlan = const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: arkaPlan,
      appBar: AppBar(
        backgroundColor: arkaPlan,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'İşletme ve İştiraklerimiz',
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
                    child: const Icon(Icons.apartment_rounded, color: Colors.white, size: 36),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Belediye Tesisleri", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 4),
                        Text(
                          "Erdemli Belediyesi bünyesinde halkımıza hizmet veren işletme ve tesisler.",
                          style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 13, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // İÇERİK KARTI: SOSYAL TESİSLER
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
                      Icon(Icons.coffee_rounded, color: anaRenk, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        "Sosyal Tesisler ve Kafeteryalar",
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: koyuRenk),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Vatandaşlarımızın aileleriyle birlikte güvenle ve huzurla vakit geçirebileceği, uygun fiyatlı ve kaliteli hizmet sunan tesislerimiz bulunmaktadır.",
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
                  ),
                  const SizedBox(height: 16),
                  _buildRequirementItem("Sahil Bandı Kafeteryaları", anaRenk),
                  _buildRequirementItem("Park İçi Çay Bahçeleri ve Dinlenme Alanları", anaRenk),
                  _buildRequirementItem("Belediye Misafirhanesi ve Konaklama Tesisleri", anaRenk),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // İÇERİK KARTI: DİĞER İŞLETMELER
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
                      Icon(Icons.store_rounded, color: Colors.orange.shade500, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        "Diğer Hizmet Alanları",
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: koyuRenk),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRequirementItem("Kapalı ve Açık Otopark İşletmeleri", anaRenk),
                  _buildRequirementItem("Plaj ve Sahil Hizmetleri (Şezlong, Duş vb.)", anaRenk),
                  _buildRequirementItem("Düğün ve Çok Amaçlı Toplantı Salonları", anaRenk),
                  _buildRequirementItem("Yöresel Ürün Satış Noktaları", anaRenk),
                ],
              ),
            ),

            const SizedBox(height: 20), // Ekranın en altına sıfır yapışmaması için minik bir boşluk
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
            child: Icon(Icons.check_rounded, color: iconColor, size: 12),
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