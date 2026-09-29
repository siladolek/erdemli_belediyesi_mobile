import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/auth/login_screen.dart'; // Kendi login sayfanın yolunu kontrol et

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Color denizMavisi = const Color(0xFF154360);
  final Color acikMavi = const Color(0xFF2980B9);
  final Color arkaPlan = const Color(0xFFF8F9FA);

  // Varsayılan değerler
  String _userName = "Sıla Dölek";
  String _userEmail = "";

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (mounted) {
        setState(() {
          _userEmail = user.email ?? "";
        });
      }

      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists && mounted) {
          final data = doc.data() as Map<String, dynamic>?;
          if (data != null && data['name'] != null && data['name'].toString().isNotEmpty) {
            setState(() {
              _userName = data['name'];
            });
          }
        }
      } catch (e) {
        debugPrint("Kullanıcı bilgileri çekilirken hata: $e");
      }
    }
  }

  Future<void> _handleLogout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // İsimden baş harfi alma (Örn: Sıla -> S)
    String initial = _userName.isNotEmpty ? _userName[0].toUpperCase() : 'V';

    return Scaffold(
      backgroundColor: arkaPlan,
      appBar: AppBar(
        backgroundColor: arkaPlan,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profilim',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: denizMavisi),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. KULLANICI KARTI (İSİM BÜYÜTÜLDÜ) ---
            Container(
              padding: const EdgeInsets.all(20),
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
                  // Profil Yuvarlağı
                  Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: denizMavisi),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // İsim ve Alt Bilgiler
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userName, // Artık mail değil, isim kocaman yazıyor!
                          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (_userEmail.isNotEmpty)
                          Text(
                            _userEmail,
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Onaylı Vatandaş',
                            style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- 2. KİŞİSEL İŞLEMLER BÖLÜMÜ ---
            Text(
              'Kişisel İşlemler',
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  _buildListTile(Icons.person_outline_rounded, 'Profil Bilgilerim', () {}),
                  _buildDivider(),
                  _buildListTile(Icons.favorite_border_rounded, 'Favorilerim', () {}),
                  _buildDivider(),
                  _buildListTile(Icons.calendar_month_outlined, 'Randevularım', () {}),
                  _buildDivider(),
                  _buildListTile(Icons.assignment_outlined, 'Başvurularım', () {}),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- 3. DESTEK VE BİLDİRİMLER BÖLÜMÜ ---
            Text(
              'Destek ve Bildirimler',
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  _buildListTile(Icons.support_agent_rounded, 'Canlı Destek', () {}),
                  _buildDivider(),
                  _buildListTile(Icons.notifications_none_rounded, 'Bildirim Ayarları', () {}),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- 4. ÇIKIŞ YAP BUTONU ---
            // "Version" yazısı tamamen kaldırıldı, yerine şık bir çıkış butonu eklendi.
            Center(
              child: TextButton.icon(
                onPressed: _handleLogout,
                icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                label: Text(
                  'Hesaptan Çıkış Yap',
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.redAccent),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.redAccent.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 40), // Alt navigasyon barı için boşluk
          ],
        ),
      ),
    );
  }

  // Liste elemanları için yardımcı widget
  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: denizMavisi, size: 24),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: denizMavisi),
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }

  // Liste elemanları arasındaki ince çizgi
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
    );
  }
}