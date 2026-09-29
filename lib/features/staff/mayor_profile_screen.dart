import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart'; // Yönlendirmeler için eklendi

class MayorProfileScreen extends StatelessWidget {
  const MayorProfileScreen({super.key});

  // Sosyal medya ve diğer dış bağlantıları açmak için fonksiyon
  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bağlantı açılamadı, lütfen internetinizi kontrol edin.', style: GoogleFonts.poppins()),
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
        iconTheme: IconThemeData(color: denizMavisi),
        title: Text(
          'Başkanımız',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: denizMavisi),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // 1. BAŞKAN PROFİL KARTI (Premium Tasarım)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: acikMavi.withOpacity(0.08), blurRadius: 24, offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        // Fotoğraf Alanı (Gerçek Fotoğraf + Hata Kontrolü)
                        Container(
                          width: 100,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              // Buraya belediyenin web sitesindeki veya kendi sunucunuzdaki fotoğraf linkini koyabilirsin.
                              // Eğer asset kullanacaksanız Image.asset('assets/images/baskan.jpg') yapabilirsin.
                              'https://www.erdemli.bel.tr/assets/images/mustafa_kara.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Fotoğraf yüklenemezse veya link bozuksa burası çalışır
                                return Container(
                                  color: Colors.grey.shade100,
                                  child: Icon(Icons.person, size: 60, color: Colors.grey.shade400),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),

                        // Bilgi Alanı
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.amber.shade200),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star_rounded, size: 14, color: Colors.amber.shade700),
                                    const SizedBox(width: 4),
                                    Text('Erdemli Belediyesi', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber.shade900)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text('Mustafa KARA', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: acikMavi)),
                              Text('BELEDİYE BAŞKANI', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: denizMavisi)),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.school_rounded, size: 14, color: Colors.grey.shade500),
                                  const SizedBox(width: 6),
                                  Expanded(child: Text('Bilgisayar Yüksek Mühendisi', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500))),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Slogan Alanı
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey.shade50, Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
                      border: Border(top: BorderSide(color: Colors.grey.shade100)),
                    ),
                    child: Text(
                      '"Biriz, Erdemliyiz!"',
                      style: GoogleFonts.poppins(fontSize: 14, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600, color: acikMavi),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // 2. SOSYAL MEDYA BUTONLARI (Tıklanabilir ve Yönlendirmeli)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Icon(Icons.share_rounded, size: 18, color: denizMavisi),
                  const SizedBox(width: 8),
                  Text('SOSYAL MEDYA', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: denizMavisi)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildSocialBtn(context, 'Facebook', Icons.facebook_rounded, Colors.blue.shade700, 'https://www.facebook.com/mustafakaraerdemli'),
                  _buildSocialBtn(context, 'X (Twitter)', Icons.close_rounded, Colors.black, 'https://twitter.com/mustafakara'),
                  _buildSocialBtn(context, 'Instagram', Icons.camera_alt_rounded, Colors.pink.shade500, 'https://www.instagram.com/mustafakara.33'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 3. BİLGİ KARTLARI (Özgeçmiş, Mesaj ve Görevler Tek Sayfada)
            _buildSectionCard(
              title: 'Özgeçmiş',
              icon: Icons.person_search_rounded,
              color: acikMavi,
              content: "13 Şubat 1984 tarihinde Mersin'in Erdemli ilçesinde dünyaya geldi. İlköğrenimini Erdemli Akdeniz İlkokulunda, ortaokul ve lise eğitimini Erdemli Anadolu Lisesi'nde tamamladı. Bahçeşehir Üniversitesi'nde Bilgisayar Mühendisliği bölümünden mezun oldu. Yüksek lisansını 2011 yılında tamamladı.\n\n31 Mart 2024 Yerel Seçimleri'nde halkımızın teveccühüyle Erdemli Belediyesi'nin 9. Belediye Başkanı olarak seçildi. Evli ve 2 çocuk babasıdır.",
            ),

            _buildSectionCard(
              title: 'Başkanın Mesajı',
              icon: Icons.format_quote_rounded,
              color: Colors.orange.shade600,
              content: "Çok kıymetli hemşehrilerim, sizi sevgiyle ve saygıyla selamlıyorum.\n\nErdemli'mizin tamamının kazandığı bir seçimi geride bıraktık. Doğup büyüdüğüm, Kara Sevdam dediğim Erdemli'ye hizmet etme fırsatını bana nasip eden Rabbime binlerce kez şükrediyorum!\n\nŞimdi, vatandaşımıza hizmet vakti! Şimdi yola çıkma, şimdi harekete geçme vakti! Birliğin gücüyle başaracağız, hep birlikte güzel işler yapacağız, tarihi nitelikte eserleri Erdemli'ye kazandıracağız.\n\nBirliğin gücüyle şimdi yürüyecek yolumuz, yapacak işimiz, söyleyecek sözümüz var.",
            ),

            _buildSectionCard(
              title: 'Görev ve Yetkileri',
              icon: Icons.gavel_rounded,
              color: Colors.teal.shade600,
              content: "5393 Sayılı Belediye Kanunu'nun 38. maddesi uyarınca;\n\n• Belediye teşkilatının en üst amiri olarak teşkilatı sevk ve idare etmek.\n• Beldenin ve belediyenin hak ve menfaatlerini korumak.\n• Belediyeyi stratejik plana uygun olarak yönetmek ve kurumun kurumsal stratejilerini belirlemek.\n• Belediye Meclisi ve Belediye Encümenine başkanlık etmektir.",
            ),
          ],
        ),
      ),
    );
  }

  // Sosyal Medya Butonu Tasarımı (Tıklanabilir Yapıldı)
  Widget _buildSocialBtn(BuildContext context, String title, IconData icon, Color color, String url) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _launchUrl(context, url),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                children: [
                  Icon(icon, color: color, size: 26),
                  const SizedBox(height: 8),
                  Text(title, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade800, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // İçerik Kartı Tasarımı
  Widget _buildSectionCard({required String title, required IconData icon, required String content, required Color color}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
        border: Border(left: BorderSide(color: color, width: 5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 14),
                Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF154360))),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade700, height: 1.7),
            ),
          ],
        ),
      ),
    );
  }
}