import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// FIREBASE IMPORTLARI
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

// MODÜLLER (EKRANLAR)
import 'features/home/home_screen.dart';
import 'features/services/online_services_screen.dart';
import 'features/discover/models/discover_screen.dart';
import 'features/municipality/belediye_screen.dart';
import 'package:erdemli_belediyesi_mobile/screens/profile_screen.dart'; // DOĞRU PROFIL EKRANI YOLU
import 'features/auth/splash_screen.dart'; // AÇILIŞ EKRANI EKLENDİ

// ============================================================================
// ARKA PLAN BILDIRIM YAKALAYICISI
// ============================================================================
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("Arka planda bildirim geldi: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const ErdemliBelediyesiApp());
}

class ErdemliBelediyesiApp extends StatelessWidget {
  const ErdemliBelediyesiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Erdemli Belediyesi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8F9FA),
          elevation: 0,
          centerTitle: false,
        ),
      ),
      // UYGULAMA AÇILIR AÇILMAZ SPLASH EKRANINA GİDER (Oradan da 3 saniye sonra PremiumDashboardScreen'e)
      home: const SplashScreen(),
    );
  }
}

// ============================================================================
// ANA NAVIGASYON VE İSKELET YÖNETİCİSİ
// ============================================================================
class PremiumDashboardScreen extends StatefulWidget {
  const PremiumDashboardScreen({super.key});

  @override
  State<PremiumDashboardScreen> createState() => _PremiumDashboardScreenState();
}

class _PremiumDashboardScreenState extends State<PremiumDashboardScreen> {
  final Color denizMavisi = const Color(0xFF154360);
  final Color acikMavi = const Color(0xFF2980B9);
  final Color limonSarisi = const Color(0xFFF1C40F);
  final Color bgLight = const Color(0xFFF8F9FA);

  int _currentIndex = 0;
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    _setupFCM();
  }

  Future<void> _setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() => _notificationCount++);
      if (message.notification != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: denizMavisi,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message.notification!.title ?? 'Yeni Bildirim', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: limonSarisi)),
                const SizedBox(height: 4),
                Text(message.notification!.body ?? '', style: GoogleFonts.poppins(color: Colors.white)),
              ],
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    });
  }

  void _showNotificationsPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(color: Color(0xFFF8F9FA), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(margin: const EdgeInsets.only(top: 12, bottom: 20), width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Anlık Bildirimler', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF154360))),
                    Icon(Icons.sensors_rounded, color: Colors.green.shade600, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('notifications').orderBy('timestamp', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Color(0xFF2980B9)));

                    List<Widget> notificationList = [];

                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      for (var doc in snapshot.data!.docs) {
                        var data = doc.data() as Map<String, dynamic>;
                        IconData icon = Icons.notifications_active_rounded;
                        Color color = const Color(0xFF2980B9);
                        String type = data['type'] ?? 'genel';

                        if (type == 'su') { icon = Icons.water_drop_rounded; color = Colors.blue; }
                        else if (type == 'elektrik') { icon = Icons.bolt_rounded; color = Colors.orange; }
                        else if (type == 'hava') { icon = Icons.cloud_rounded; color = Colors.grey.shade700; }
                        else if (type == 'etkinlik') { icon = Icons.music_note_rounded; color = Colors.purple; }

                        notificationList.add(_buildNotificationItem(
                          data['title'] ?? 'Yeni Bildirim',
                          data['description'] ?? '',
                          icon,
                          color,
                        ));
                      }
                    } else {
                      notificationList.add(_buildNotificationItem('Su Kesintisi', 'Kocahasanlı Mahallesinde ana boru arızası nedeniyle 14:00 - 18:00 arası su kesintisi yaşanacaktır.', Icons.water_drop_rounded, Colors.blue));
                      notificationList.add(_buildNotificationItem('Elektrik Kesintisi', 'Tömük Mahallesinde planlı TEDAŞ bakım çalışması sebebiyle elektrik verilememektedir.', Icons.bolt_rounded, Colors.orange));
                      notificationList.add(_buildNotificationItem('Hava Durumu Uyarısı', 'Erdemli için bugün öğleden sonra şiddetli sağanak yağış beklenmektedir. Dikkatli olunması rica olunur.', Icons.cloud_rounded, Colors.grey.shade700));
                      notificationList.add(_buildNotificationItem('Etkinlik Hatırlatması', 'Kızkalesi Yaz Konserleri bu akşam 20:30\'da başlıyor. Tüm halkımız davetlidir.', Icons.music_note_rounded, Colors.purple));
                    }

                    return ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: notificationList
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem(String title, String desc, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 24)
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF154360))),
                const SizedBox(height: 4),
                Text(desc, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // SAYFA LİSTESİ (HomeScreen'e gerekli verileri parametre olarak gönderiyoruz)
  List<Widget> get _pages => [
    HomeScreen(
      notificationCount: _notificationCount,
      onNotificationTap: () {
        setState(() => _notificationCount = 0);
        _showNotificationsPanel(context);
      },
    ),
    const OnlineHizmetlerScreen(),
    const DiscoverScreen(),
    const BelediyeScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _buildModernBottomNav(),
    );
  }

  Widget _buildModernBottomNav() {
    return Container(
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: denizMavisi.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home_filled, Icons.home_outlined, 'Ana Sayfa', 0),
          _buildNavItem(Icons.bolt, Icons.bolt_outlined, 'Hizmetler', 1),
          _buildNavItem(Icons.explore, Icons.explore_outlined, 'Keşfet', 2),
          _buildNavItem(Icons.account_balance_rounded, Icons.account_balance_outlined, 'Belediye', 3),
          _buildNavItem(Icons.person, Icons.person_outline, 'Profil', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData activeIcon, IconData inactiveIcon, String label, int index) {
    bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: isActive ? denizMavisi : Colors.transparent, borderRadius: BorderRadius.circular(16)), child: Icon(isActive ? activeIcon : inactiveIcon, color: isActive ? limonSarisi : Colors.grey.shade400, size: 26)),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.poppins(fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.w500, color: isActive ? denizMavisi : Colors.grey.shade500)),
        ],
      ),
    );
  }
}