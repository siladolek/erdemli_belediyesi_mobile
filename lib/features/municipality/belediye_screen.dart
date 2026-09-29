import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BelediyeScreen extends StatefulWidget {
  const BelediyeScreen({super.key});

  @override
  State<BelediyeScreen> createState() => _BelediyeScreenState();
}

class _BelediyeScreenState extends State<BelediyeScreen> {
  final Color denizMavisi = const Color(0xFF154360);
  final Color acikMavi = const Color(0xFF2980B9);
  final Color bgLight = const Color(0xFFF8F9FA);

  // Kurumsal menü öğeleri ve onlara özel kısa açıklamalar
  final List<Map<String, dynamic>> kurumsalItems = [
    {
      'title': 'Meclis Üyeleri',
      'desc': 'Erdemli Belediyesi Meclis Üyeleri, yerel yönetim kararlarını almak ve ilçemizin gelişimine katkı sağlamak amacıyla vatandaşlarımızı temsil eder.',
      'icon': Icons.groups_rounded, 'color': Colors.blue.shade700
    },
    {
      'title': 'Başkan Yardımcıları',
      'desc': 'Belediye Başkanımıza görevlerinde destek olan, çeşitli müdürlüklerin koordinasyonundan ve projelendirme süreçlerinden sorumlu başkan yardımcılarımız.',
      'icon': Icons.person_add_alt_1_rounded, 'color': Colors.indigo.shade600
    },
    {
      'title': 'Müdürlerimiz',
      'desc': 'Belediyemizin farklı hizmet alanlarında (fen işleri, zabıta, temizlik vb.) operasyonları doğrudan yürüten ve yöneten birim amirlerimiz.',
      'icon': Icons.manage_accounts_rounded, 'color': Colors.teal.shade700
    },
    {
      'title': 'Meclis Kararları',
      'desc': 'Belediye meclisimizde aylık olarak alınan güncel kararlar, onaylanan bütçeler ve ilçemizi ilgilendiren yasal düzenleme tutanakları.',
      'icon': Icons.gavel_rounded, 'color': Colors.brown.shade600
    },
    {
      'title': 'Mali Durum ve Beklentiler',
      'desc': 'Şeffaflık ilkemiz gereği belediyemizin bütçe gerçekleşmeleri, gelir-gider tabloları ve gelecek dönem mali planlamalarına ait özet raporlar.',
      'icon': Icons.account_balance_wallet_rounded, 'color': Colors.green.shade700
    },
    {
      'title': 'Faaliyet Raporları',
      'desc': 'Erdemli Belediyesi\'nin yıl boyunca tamamladığı projeler, sunduğu hizmetler ve stratejik hedeflerinin sonuçlarını içeren detaylı raporlar.',
      'icon': Icons.assignment_rounded, 'color': Colors.orange.shade700
    },
    {
      'title': 'Performans Raporları',
      'desc': 'Stratejik plan doğrultusunda yürütülen çalışmaların, başarı hedeflerine ulaşma düzeyini gösteren dönemsel ölçüm ve analizler.',
      'icon': Icons.insert_chart_rounded, 'color': Colors.purple.shade600
    },
    {
      'title': 'İç Kontrol Eylem Planı',
      'desc': 'Belediyemizin kaynaklarını etkili ve verimli kullanmak, riskleri önceden yönetmek için hazırlanan kurumsal güvence standartları bütünü.',
      'icon': Icons.fact_check_rounded, 'color': Colors.red.shade600
    },
    {
      'title': 'Stratejik Plan',
      'desc': 'Erdemli\'nin orta ve uzun vadeli gelişim hedeflerini, kurumsal vizyonunu ve bu hedeflere ulaşmak için izlenecek haritayı içerir.',
      'icon': Icons.pie_chart_rounded, 'color': Colors.blueGrey.shade700
    },
    {
      'title': 'Etkinlikler',
      'desc': 'İlçemizde düzenlenen kültür, sanat, eğitim, spor ve sosyal etkinliklerin genel takvimi ve organizasyon detayları.',
      'icon': Icons.event_rounded, 'color': Colors.pink.shade600
    },
    {
      'title': 'Güncel İlanlar',
      'desc': 'Erdemli Belediyesi tarafından yayınlanan personel alımı, ihale ön duyuruları, askıdaki planlar ve resmi kurumsal bilgilendirmeler.',
      'icon': Icons.campaign_rounded, 'color': Colors.cyan.shade700
    },
    {
      'title': 'Güncel Duyurular',
      'desc': 'Halkımızı yakından ilgilendiren altyapı çalışmaları, hizmet kesintileri, uyarılar ve günlük yaşama dair anlık duyurular.',
      'icon': Icons.announcement_rounded, 'color': Colors.amber.shade700
    },
    {
      'title': 'Güncel İhaleler',
      'desc': 'Şeffaflık ilkesi gereği belediyemizin açtığı mal, hizmet alımı ve yapım işi ihalelerine ait tarihler ve şartname bilgileri.',
      'icon': Icons.assignment_late_rounded, 'color': Colors.deepOrange.shade600
    },
    {
      'title': 'Foto Galeri',
      'desc': 'Erdemlimizin eşsiz güzellikleri, devam eden projelerimiz ve gerçekleşen sosyal etkinliklerden derlenen fotoğraf kareleri.',
      'icon': Icons.photo_library_rounded, 'color': Colors.indigo.shade400
    },
    {
      'title': 'Video Galeri',
      'desc': 'Belediyemizin hizmetlerini, tamamlanan projeleri ve ilçemizin turistik tanıtımını içeren güncel video içerikleri.',
      'icon': Icons.video_library_rounded, 'color': Colors.redAccent.shade400
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgLight,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Erdemli Belediyesi',
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: denizMavisi
            ),
          ),
          bottom: TabBar(
            labelColor: acikMavi,
            unselectedLabelColor: Colors.grey.shade400,
            indicatorColor: acikMavi,
            indicatorWeight: 3,
            labelStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
            unselectedLabelStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: 'Kurumsal'),
              Tab(text: 'Müdürlükler'),
            ],
          ),
        ),
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          children: [
            _buildKurumsalTab(),
            _buildMudurluklerTab(),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // ALT PENCERE (BOTTOM SHEET) - YENİ TASARIM
  // ==========================================
  void _showBottomSheetDetail(BuildContext context, String title, String desc, IconData icon, Color color) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: denizMavisi,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Özel açıklama metni buraya geliyor
              Text(
                desc,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Sadece Kapat butonu kaldı, Web'e git butonu silindi
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: denizMavisi,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Kapat',
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // 1. KURUMSAL SEKMESİ
  // ==========================================
  Widget _buildKurumsalTab() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: kurumsalItems.length,
      itemBuilder: (context, index) {
        final item = kurumsalItems[index];
        return _buildInfoCard(
          title: item['title'],
          icon: item['icon'],
          iconColor: item['color'],
          onTap: () => _showBottomSheetDetail(context, item['title'], item['desc'], item['icon'], item['color']),
        );
      },
    );
  }

  // ==========================================
  // 2. MÜDÜRLÜKLER SEKMESİ (Açıklamalar eklendi)
  // ==========================================
  Widget _buildMudurluklerTab() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        _buildInfoCard(
          title: 'Fen İşleri Müdürlüğü',
          icon: Icons.construction_rounded,
          iconColor: Colors.orange.shade700,
          onTap: () => _showBottomSheetDetail(
              context,
              'Fen İşleri Müdürlüğü',
              'Yol yapım, bakım, onarım, asfaltlama ve üst yapı çalışmalarını yürüterek Erdemli\'nin ulaşım ve altyapı kalitesini artırır.',
              Icons.construction_rounded, Colors.orange.shade700
          ),
        ),
        _buildInfoCard(
          title: 'Zabıta Müdürlüğü',
          icon: Icons.local_police_rounded,
          iconColor: denizMavisi,
          onTap: () => _showBottomSheetDetail(
              context,
              'Zabıta Müdürlüğü',
              'İlçemizdeki esnaf denetimleri, pazar yeri düzeni, halk sağlığı ve huzurunu korumak amacıyla 7/24 görev yapar.',
              Icons.local_police_rounded, denizMavisi
          ),
        ),
        _buildInfoCard(
          title: 'Temizlik İşleri Müdürlüğü',
          icon: Icons.cleaning_services_rounded,
          iconColor: Colors.green.shade600,
          onTap: () => _showBottomSheetDetail(
              context,
              'Temizlik İşleri Müdürlüğü',
              'Daha temiz bir Erdemli için çöp toplama, sokak yıkama, sahil temizliği ve geri dönüşüm faaliyetlerini aralıksız sürdürür.',
              Icons.cleaning_services_rounded, Colors.green.shade600
          ),
        ),
        _buildInfoCard(
          title: 'İmar ve Şehircilik Müdürlüğü',
          icon: Icons.location_city_rounded,
          iconColor: Colors.blueGrey.shade600,
          onTap: () => _showBottomSheetDetail(
              context,
              'İmar ve Şehircilik Müdürlüğü',
              'Planlı ve modern bir şehirleşme için ruhsat, iskan, harita işlemleri, kaçak yapı denetimi ve kentsel dönüşüm süreçlerini yönetir.',
              Icons.location_city_rounded, Colors.blueGrey.shade600
          ),
        ),
        _buildInfoCard(
          title: 'Kültür ve Sosyal İşler Müdürlüğü',
          icon: Icons.theater_comedy_rounded,
          iconColor: Colors.red.shade500,
          onTap: () => _showBottomSheetDetail(
              context,
              'Kültür ve Sosyal İşler Müdürlüğü',
              'Festivaller, meslek edindirme kursları, sergiler, tiyatrolar ve sosyal yardımlaşma projeleri ile Erdemli\'nin sosyal hayatına değer katar.',
              Icons.theater_comedy_rounded, Colors.red.shade500
          ),
        ),
        _buildInfoCard(
          title: 'Park ve Bahçeler Müdürlüğü',
          icon: Icons.park_rounded,
          iconColor: Colors.lightGreen.shade700,
          onTap: () => _showBottomSheetDetail(
              context,
              'Park ve Bahçeler Müdürlüğü',
              'Yeni yeşil alanlar, çocuk oyun parkları, spor alanları ve peyzaj düzenlemeleri yaparak ilçemizin nefes almasını sağlar.',
              Icons.park_rounded, Colors.lightGreen.shade700
          ),
        ),
        _buildInfoCard(
          title: 'Basın Yayın ve Halkla İlişkiler',
          icon: Icons.campaign_rounded,
          iconColor: acikMavi,
          onTap: () => _showBottomSheetDetail(
              context,
              'Basın Yayın ve Halkla İlişkiler',
              'Belediyemizin çalışmalarını şeffaf bir şekilde kamuoyuna duyurur, çağrı merkezi üzerinden vatandaş taleplerini dinleyerek çözüme kavuşturur.',
              Icons.campaign_rounded, acikMavi
          ),
        ),
      ],
    );
  }

  // ==========================================
  // KART TASARIMI (ORTAK WIDGET)
  // ==========================================
  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: denizMavisi,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}