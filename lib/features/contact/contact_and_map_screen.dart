import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactAndMapScreen extends StatefulWidget {
  const ContactAndMapScreen({super.key});

  @override
  State<ContactAndMapScreen> createState() => _ContactAndMapScreenState();
}

class _ContactAndMapScreenState extends State<ContactAndMapScreen> {
  // Erdemli Belediyesi Koordinatları
  final LatLng _erdemliBelediyesi = const LatLng(36.6046, 34.3060);

  // Kurumsal Renkler
  final Color denizMavisi = const Color(0xFF154360);
  final Color acikMavi = const Color(0xFF2980B9);
  final Color arkaPlan = const Color(0xFFF8F9FA);

  // URL Başlatıcı Yardımcı Fonksiyon
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('İşlem gerçekleştirilemedi.', style: GoogleFonts.poppins()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: arkaPlan,
      appBar: AppBar(
        backgroundColor: arkaPlan,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: denizMavisi),
        title: Text(
          'Bize Ulaşın',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: denizMavisi),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HARİTA ALANI
            SizedBox(
              height: 220,
              width: double.infinity,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _erdemliBelediyesi,
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('belediye'),
                        position: _erdemliBelediyesi,
                        infoWindow: const InfoWindow(title: 'Erdemli Belediyesi'),
                      ),
                    },
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                  ),
                  // Haritanın alt kısmına şık bir geçiş efekti
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 30,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [arkaPlan, arkaPlan.withOpacity(0.0)],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'İletişim Bilgileri',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: denizMavisi),
                  ),
                  const SizedBox(height: 16),

                  // BİLGİ KARTLARI
                  _buildInfoCard(
                    icon: Icons.support_agent_rounded,
                    title: 'Çağrı Merkezi',
                    subtitle: '444 5 609 / 153',
                  ),
                  _buildInfoCard(
                    icon: Icons.email_rounded,
                    title: 'E-posta',
                    subtitle: 'iletisim@erdemli.bel.tr',
                  ),
                  _buildInfoCard(
                    icon: Icons.location_on_rounded,
                    title: 'Adres',
                    subtitle: 'Merkez Mahallesi Hal Caddesi No:18\nPk. 33730 Mersin / Erdemli',
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Hızlı Erişim',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: denizMavisi),
                  ),
                  const SizedBox(height: 16),

                  // HIZLI ERİŞİM BUTONLARI (WP Kaldırıldı, Harita eklendi)
                  _buildActionButton(
                    title: 'Hemen Ara',
                    icon: Icons.phone_rounded,
                    color: denizMavisi,
                    onTap: () => _launchURL('tel://4445609'),
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    title: 'E-posta Gönder',
                    icon: Icons.send_rounded,
                    color: acikMavi,
                    onTap: () => _launchURL('mailto:iletisim@erdemli.bel.tr'),
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    title: 'Yol Tarifi Al',
                    icon: Icons.directions_rounded,
                    color: Colors.teal.shade600, // WP yeşili yerine şık bir teal rengi
                    onTap: () => _launchURL('https://www.google.com/maps/search/?api=1&query=36.6046,34.3060'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // İletişim Bilgileri Kartı Tasarımı
  Widget _buildInfoCard({required IconData icon, required String title, required String subtitle}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: acikMavi.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: acikMavi, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: denizMavisi)),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Buton Tasarımı
  Widget _buildActionButton({required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 20),
        label: Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}