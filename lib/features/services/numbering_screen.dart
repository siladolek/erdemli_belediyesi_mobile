import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NumberingScreen extends StatelessWidget {
  const NumberingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // NUMARATAJ ÖZEL RENK PALETİ (Menüdeki ikon rengine uyumlu: Indigo/Mor tonları)
    final Color anaRenk = const Color(0xFF5C6BC0); // Menüdeki ikonun rengi
    final Color koyuRenk = const Color(0xFF3949AB); // Başlıklar ve gradyan için daha koyu bir ton
    final Color arkaPlan = const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: arkaPlan,
      appBar: AppBar(
        backgroundColor: arkaPlan,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Numarataj',
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
            // ÜST BİLGİ KARTI (HERO BANNER) - İNDİGO TONLARINDA
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
                    child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 36),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Numarataj İşlemleri", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 4),
                        Text(
                          "Adres tespit, bina numaralandırma ve sokak isimlendirme hizmetleri.",
                          style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 13, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // İÇERİK KARTI: GÖREV VE SORUMLULUKLAR
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
                      Text(
                        "Görev ve Sorumluluklar",
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: koyuRenk),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Web sitesinden alınan birebir içerikler
                  _buildRequirementItem(
                      "Adres ve Numaralama Yönetmeliğine uygun olarak meydan, bulvar, cadde, yol ve sokak ad ve numaraları ile bunlar üzerindeki binalara numara vermek ve alanda tabelaların takılması işlerini yürütmek.",
                      anaRenk
                  ),
                  _buildRequirementItem(
                      "Oluşturulacak yeni mahallelerle ilgili işlemleri koordine etmek, konuyu Meclise intikal ettirerek gerekli çalışmaları yapmak.",
                      anaRenk
                  ),
                  _buildRequirementItem(
                      "Seçim kanunlarına göre İlçe Seçim Kurullarına ait Seçmen Sandıklarını muhafaza etmek, belirlenen adreslere dağıtmak ve toplatmak.",
                      anaRenk
                  ),
                  _buildRequirementItem(
                      "Seçmen kütüklerine esas olmak üzere binalara, sokak, cadde ve bulvarların kılavuz işlemlerini düzenlemek.",
                      anaRenk
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20), // Ekranın en altına yapışmaması için küçük bir boşluk bıraktım
          ],
        ),
      ),
    );
  }

  // Liste elemanları için yardımcı tasarım fonksiyonu
  Widget _buildRequirementItem(String text, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
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
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade700, height: 1.5, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}