import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'contact_service.dart';

class ContactAndMapScreen extends StatefulWidget {
  const ContactAndMapScreen({super.key});

  @override
  State<ContactAndMapScreen> createState() => _ContactAndMapScreenState();
}

class _ContactAndMapScreenState extends State<ContactAndMapScreen> {
  late Future<ContactModel> _contactFuture;

  @override
  void initState() {
    super.initState();
    _contactFuture = ContactService.fetchContactInfo();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryDark = const Color(0xFF102841);
    final Color accentCyan = const Color(0xFF00C4D4);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FC),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'İletişim',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: primaryDark),
        ),
        iconTheme: IconThemeData(color: primaryDark),
      ),
      body: FutureBuilder<ContactModel>(
        future: _contactFuture,
        builder: (context, snapshot) {
          // 1. YÜKLENİYOR DURUMU
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: accentCyan),
                  const SizedBox(height: 16),
                  Text(
                    'İletişim bilgileri güncelleniyor...',
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          // 2. HATA DURUMU (Sahte veri gösterilmez)
          else if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off_rounded, size: 48, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Bilgiler şu anda yüklenemiyor.',
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: primaryDark),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'İnternet bağlantınızı kontrol edip tekrar deneyin.',
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryDark,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() {
                          _contactFuture = ContactService.fetchContactInfo();
                        });
                      },
                      child: Text('Tekrar Dene', style: GoogleFonts.inter(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. BAŞARILI DURUM: GERÇEK VERİLERİN GÖSTERİMİ
          final contactInfo = snapshot.data!;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // İletişim Kartı
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Erdemli Belediyesi Ana Hizmet Binası',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: primaryDark),
                      ),
                      const SizedBox(height: 16),
                      _buildContactRow(
                        icon: Icons.location_on_outlined,
                        title: 'Adres',
                        detail: contactInfo.address,
                        accentCyan: accentCyan,
                        primaryDark: primaryDark,
                      ),
                      const Divider(height: 24),
                      _buildContactRow(
                        icon: Icons.phone_outlined,
                        title: 'Telefon',
                        detail: contactInfo.phone,
                        accentCyan: accentCyan,
                        primaryDark: primaryDark,
                      ),
                      const Divider(height: 24),
                      _buildContactRow(
                        icon: Icons.email_outlined,
                        title: 'E-Posta',
                        detail: contactInfo.email,
                        accentCyan: accentCyan,
                        primaryDark: primaryDark,
                      ),
                      const Divider(height: 24),
                      _buildContactRow(
                        icon: Icons.access_time_outlined,
                        title: 'Çalışma Saatleri',
                        detail: contactInfo.workingHours,
                        accentCyan: accentCyan,
                        primaryDark: primaryDark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Harita / Konum Görsel Alanı
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: const DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=800'), // Harita için statik veya dinamik API kullanılabilir
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, primaryDark.withOpacity(0.8)],
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Haritada Görüntüle',
                          style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String title,
    required String detail,
    required Color accentCyan,
    required Color primaryDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: accentCyan.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: accentCyan, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                detail,
                style: GoogleFonts.inter(fontSize: 14, color: primaryDark, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}