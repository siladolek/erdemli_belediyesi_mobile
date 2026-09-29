import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart'; // Yönlendirme için eklendi

class TaxOperationsScreen extends StatelessWidget {
  const TaxOperationsScreen({super.key});

  // E-Belediye güvenli ödeme sistemine yönlendirme fonksiyonu
  Future<void> _launchPaymentSystem(BuildContext context) async {
    // Erdemli Belediyesi E-Belediye ödeme sayfası linki
    final Uri url = Uri.parse('https://ebelediye.erdemli.bel.tr/');

    // Uygulama dışına (telefonun varsayılan tarayıcısına) çıkmaya zorluyoruz
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ödeme sayfasına ulaşılamadı. Lütfen internet bağlantınızı kontrol edin.',
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
    // VERGİ İŞLEMLERİ ÖZEL RENK PALETİ (Menüdeki ikon rengine uyumlu: Teal/Yeşil tonları)
    final Color anaRenk = const Color(0xFF00897B);
    final Color koyuRenk = const Color(0xFF00695C);
    final Color arkaPlan = const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: arkaPlan,
      appBar: AppBar(
        backgroundColor: arkaPlan,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Vergi İşlemleri',
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
                    child: const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 36),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Vergi ve Ödemeler", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 4),
                        Text(
                          "Emlak ve Çevre Temizlik vergisi borç sorgulama ve ödeme işlemleri.",
                          style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 13, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // İÇERİK KARTI: ÖDENEBİLECEK VERGİ TÜRLERİ
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
                      Icon(Icons.account_balance_wallet_rounded, color: anaRenk, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        "Hangi Vergiler Ödenebilir?",
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: koyuRenk),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRequirementItem("Emlak Vergisi (Bina, Arsa, Arazi)", anaRenk),
                  _buildRequirementItem("Çevre Temizlik Vergisi (ÇTV)", anaRenk),
                  _buildRequirementItem("İlan ve Reklam Vergisi", anaRenk),
                  _buildRequirementItem("Eğlence ve Haberleşme Vergisi", anaRenk),
                  _buildRequirementItem("Taksitlendirilmiş Borçlar", anaRenk),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // İÇERİK KARTI: ÖDEME KANALLARI VE TARİHLER
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
                      Icon(Icons.calendar_month_rounded, color: Colors.orange.shade500, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        "Önemli Tarihler ve Kanallar",
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: koyuRenk),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Emlak ve Çevre Temizlik Vergisi ödemeleri her yıl iki eşit taksitte yapılmaktadır:\n\n• 1. Taksit: Mayıs ayı sonuna kadar\n• 2. Taksit: Kasım ayı sonuna kadar",
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Ödemelerinizi Güvenli E-Belediye sistemimizden kredi kartı ile, belediye veznelerimizden veya anlaşmalı bankalar (Halkbank, Ziraat vb.) üzerinden yapabilirsiniz.",
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ÖDEME SİSTEMİNE GİT BUTONU
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                // Gerçek yönlendirme fonksiyonunu buraya bağladık
                onPressed: () => _launchPaymentSystem(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: anaRenk,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.payment_rounded, size: 20),
                label: Text('Güvenli Ödeme / Sorgulama', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold)),
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