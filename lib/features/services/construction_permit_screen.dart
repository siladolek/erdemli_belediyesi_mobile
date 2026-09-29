import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConstructionPermitScreen extends StatelessWidget {
  const ConstructionPermitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // İNŞAAT RUHSATI ÖZEL RENK PALETİ (Menüdeki ikon rengine uyumlu: Toprak/Vizon tonları)
    final Color anaRenk = const Color(0xFF8D6E63); // Menüdeki ikona uyumlu toprak rengi
    final Color koyuRenk = const Color(0xFF5D4037); // Başlıklar ve gradyan için daha koyu ton
    final Color arkaPlan = const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: arkaPlan,
      appBar: AppBar(
        backgroundColor: arkaPlan,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'İnşaat Ruhsatı',
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
                    child: const Icon(Icons.handyman_rounded, color: Colors.white, size: 36),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Yapı (İnşaat) Ruhsatı", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 4),
                        Text(
                          "Yeni bir inşaata başlamadan önce alınması zorunlu olan yasal izin belgesidir.",
                          style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 13, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // İÇERİK KARTI 1: SÜREÇ NASIL İŞLER?
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
                        "Süreç Nasıl İşler?",
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: koyuRenk),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "İmar Kanunu'na göre, mücavir alan sınırları içinde yapılacak tüm yapılar için belediyeden ruhsat alınması mecburidir. Ruhsat alınmadan başlanan inşaatlar 'kaçak yapı' statüsüne girer ve mühürlenir.",
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "İlgili evraklarla İmar ve Şehircilik Müdürlüğümüze yapılan başvurular, mimari, statik, mekanik ve tesisat projelerinin incelenmesinin ardından onaylanarak ruhsatlandırılır. Ruhsatın geçerlilik süresi, düzenlendiği tarihten itibaren 5 yıldır.",
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // İÇERİK KARTI 2: GEREKLİ BELGELER (Standart Mevzuat Listesi)
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
                      Icon(Icons.file_copy_outlined, color: Colors.orange.shade500, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        "Başvuru İçin Gerekli Evraklar",
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: koyuRenk),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRequirementItem("Dilekçe (Arsa sahibi veya vekili tarafından)", anaRenk),
                  _buildRequirementItem("Güncel Tapu Kayıt Sureti", anaRenk),
                  _buildRequirementItem("İmar Durum Belgesi (Çap)", anaRenk),
                  _buildRequirementItem("Mimari, Statik ve Tesisat Projeleri (Oda onaylı)", anaRenk),
                  _buildRequirementItem("Zemin Etüd Raporu", anaRenk),
                  _buildRequirementItem("Yapı Denetim Sözleşmesi ve Belgeleri", anaRenk),
                  _buildRequirementItem("Müteahhitlik Sicil ve Taahhütname Evrakları", anaRenk),
                  _buildRequirementItem("Şantiye Şefi Sözleşmesi", anaRenk),
                ],
              ),
            ),

            const SizedBox(height: 20),
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