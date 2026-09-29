import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart'; // Yönlendirme için eklendi

class BuildingUsageScreen extends StatelessWidget {
  const BuildingUsageScreen({super.key});

  // e-Devlet yönlendirme fonksiyonu
  Future<void> _launchEDevlet(BuildContext context) async {
    // Erdemli Belediyesi e-Devlet kapısı ana linki (İstersen direkt hizmet linkiyle değiştirebilirsin)
    final Uri url = Uri.parse('https://www.turkiye.gov.tr/erdemli-belediyesi');

    // Uygulama dışına (tarayıcıya veya e-Devlet uygulamasına) çıkmaya zorluyoruz
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'e-Devlet sayfası açılamadı. Lütfen internet bağlantınızı kontrol edin.',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Kurumsal Renk Paleti
    final Color denizMavisi = const Color(0xFF154360);
    final Color acikMavi = const Color(0xFF2980B9);
    final Color arkaPlan = const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: arkaPlan,
      appBar: AppBar(
        backgroundColor: arkaPlan,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Yapı Kullanım (İskan)',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: denizMavisi),
        ),
        iconTheme: IconThemeData(color: denizMavisi),
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
                  colors: [denizMavisi, acikMavi],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: acikMavi.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.domain_verification_rounded, color: Colors.white, size: 36),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("İskan Raporu", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 4),
                        Text(
                          "Yapı Kullanma İzin Belgesi detayları ve başvuru süreçleri.",
                          style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 13, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // İÇERİK KARTI 1: YAPI KULLANMA İZNİ NEDİR?
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
                      Icon(Icons.help_outline_rounded, color: acikMavi, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        "Yapı Kullanma İzni Nedir?",
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: denizMavisi),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "İnşaatı tamamlanan yapıların, bina ile ilgili tüm teknik işlemler tamamlandıktan sonra, yapının ruhsat ve eklerine uygun olduğunu, kullanılmasında fen ve sağlık bakımından herhangi bir sakınca olmadığını gösteren belgedir.",
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "İçeriğinde; ruhsat bilgilerini, inşaatın bitim tarihini, tapu kaydını, adresini, bağımsız bölümlerin cinslerini, numaralarını, metrekarelerini, sınıflarını ve mal sahiplerini barındırır. Erdemli Belediyesi İmar ve Şehircilik Müdürlüğü Yapı İşleri birimince düzenlenir.",
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // İÇERİK KARTI 2: GEREKLİ BELGELER (ÖRNEK LİSTE)
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
                      Icon(Icons.description_outlined, color: Colors.orange.shade500, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        "Başvuru İçin Gerekli Belgeler",
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: denizMavisi),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRequirementItem("Dilekçe (İmar ve Şehircilik Müdürlüğüne hitaben)"),
                  _buildRequirementItem("Tapu Kaydı (Güncel tarihli)"),
                  _buildRequirementItem("Mimari Proje (Onaylı sureti)"),
                  _buildRequirementItem("Yapı Denetim Hakediş Raporları"),
                  _buildRequirementItem("SGK İlişiksizlik Belgesi"),
                  _buildRequirementItem("Vergi Dairesi İlişiksizlik Belgesi"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // BAŞVURU BUTONU
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                // Yönlendirme fonksiyonu buraya bağlandı
                onPressed: () => _launchEDevlet(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: acikMavi,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.launch_rounded, size: 20),
                label: Text('E-Devlet Üzerinden Başvur', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Liste elemanları için yardımcı tasarım fonksiyonu
  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: Colors.orange.shade50, shape: BoxShape.circle),
            child: Icon(Icons.check_rounded, color: Colors.orange.shade600, size: 12),
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