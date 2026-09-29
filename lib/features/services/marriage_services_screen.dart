import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarriageServicesScreen extends StatelessWidget {
  const MarriageServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // EVLİLİK HİZMETLERİ ÖZEL RENK PALETİ (Menüdeki ikon rengine uyumlu: Pembe/Gül Kurusu)
    final Color anaRenk = const Color(0xFFD81B60);
    final Color koyuRenk = const Color(0xFFAD1457);
    final Color arkaPlan = const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: arkaPlan,
      appBar: AppBar(
        backgroundColor: arkaPlan,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Evlilik Hizmetleri',
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
                    child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 36),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nikah Başvuru İşlemleri", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 4),
                        Text(
                          "Erdemli Belediyesi Evlendirme Memurluğu nikah başvuru süreci ve gerekli evraklar.",
                          style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 13, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // İÇERİK KARTI: BAŞVURU ŞARTLARI VE BİLGİLER
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
                        "Başvuru Hakkında Bilgiler",
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: koyuRenk),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Nikah başvurusu yapmak isteyen çiftlerin, birlikte ve şahsen Evlendirme Memurluğumuza müracaat etmeleri gerekmektedir. Çiftlerden birinin ikametgahının Erdemli sınırları içerisinde olması zorunludur.",
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Sağlık raporları Aile Hekimliklerinden alınmalı ve 'Evlenmesinde Tıbbi Sakınca Yoktur' ibaresi ile fotoğraflı, imzalı ve kaşeli olmalıdır.",
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
                      Icon(Icons.file_present_rounded, color: Colors.orange.shade500, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        "İstenilen Evraklar",
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: koyuRenk),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRequirementItem("Çiftlerin Nüfus Cüzdanı Aslı ve Fotokopileri (T.C. Kimlik No'lu, son 10 yıl içinde değiştirilmiş)", anaRenk),
                  _buildRequirementItem("5'er Adet Vesikalık Fotoğraf (Son 6 ay içerisinde, ön cepheden çekilmiş)", anaRenk),
                  _buildRequirementItem("Sağlık Raporu (Aile Hekimliğinden onaylı, fotoğraflı ve imzalı)", anaRenk),
                  _buildRequirementItem("Evlenme Ehliyet Belgesi (Belediyemiz tarafından sistemden alınmaktadır)", anaRenk),
                  _buildRequirementItem("Daha önce evlilik yapılmış ise kesinleşmiş boşanma kararı / iddet müddeti kaldırma kararı", anaRenk),
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