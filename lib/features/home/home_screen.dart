import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

// DOĞRU İMPORT YOLLARI (Göreceli Yollar)
import '../projects/project_service.dart';
import '../projects/projects_screen.dart';
import '../services/e_belediye_screen.dart';
import '../staff/mayor_profile_screen.dart';
import '../contact/contact_and_map_screen.dart';
import '../report_issue/report_issue_screen.dart';
import '../document_guide/document_guide_screen.dart';
import '../appointment/appointment_screen.dart';
import '../news/news_service.dart';
import '../news/native_news_screen.dart';
import '../announcements/announcement_service.dart';
import '../announcements/announcements_screen.dart';
import '../events/event_service.dart';
import '../events/events_screen.dart';

class HomeScreen extends StatefulWidget {
  final int notificationCount;
  final VoidCallback onNotificationTap;

  const HomeScreen({
    super.key,
    required this.notificationCount,
    required this.onNotificationTap,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color denizMavisi = const Color(0xFF154360);
  final Color acikMavi = const Color(0xFF2980B9);
  final Color limonSarisi = const Color(0xFFF1C40F);

  late Future<List<NewsModel>> _newsFuture;
  late Future<List<AnnouncementModel>> _announcementsFuture;
  late Future<List<EventModel>> _eventsFuture;
  late Future<List<ProjectModel>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _newsFuture = NewsService.fetchNews();
      _announcementsFuture = AnnouncementService.fetchAnnouncements();
      _eventsFuture = EventService.fetchEvents();
      _projectsFuture = ProjectService.fetchProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: acikMavi,
      backgroundColor: Colors.white,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildDynamicHeroSection()),
            SliverToBoxAdapter(child: _buildQuickActionsGrid()),
            SliverToBoxAdapter(child: _buildSectionHeader('Güncel Duyurular', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DuyurularScreen())))),
            SliverToBoxAdapter(child: _buildDynamicAnnouncementsList()),
            SliverToBoxAdapter(child: _buildSectionHeader('Son Haberler', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NativeNewsScreen())))),
            SliverToBoxAdapter(child: _buildDynamicNewsList()),
            SliverToBoxAdapter(child: _buildSectionHeader('Yaklaşan Etkinlikler', () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EtkinliklerScreen())))),
            SliverToBoxAdapter(child: _buildDynamicEventsList()),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: denizMavisi.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))]),
                  child: Image.asset('assets/images/logo.png', height: 45, width: 45)
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Erdemli Belediyesi', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: denizMavisi)),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(6)),
                    child: Text('T.C. Erdemli Belediyesi', style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade800, fontWeight: FontWeight.w600, letterSpacing: 0.2)),
                  ),
                ],
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
                child: IconButton(icon: Icon(Icons.notifications_outlined, color: denizMavisi), onPressed: widget.onNotificationTap),
              ),
              if (widget.notificationCount > 0)
                Positioned(
                    top: 8, right: 10,
                    child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: Text('${widget.notificationCount}', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))
                    )
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicHeroSection() {
    return FutureBuilder<List<ProjectModel>>(
      future: _projectsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
              padding: const EdgeInsets.all(20),
              child: Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: Container(height: 220, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24))))
          );
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox.shrink();
        final project = snapshot.data!.first;
        return InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProjectsScreen())),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 220,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: acikMavi.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))], color: denizMavisi),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (project.imageUrl.isNotEmpty) Image.network(project.imageUrl, fit: BoxFit.cover, errorBuilder: (c,e,s) => _buildFallbackBackground()) else _buildFallbackBackground(),
                  if (project.imageUrl.isNotEmpty) Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.8)]))),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: limonSarisi, borderRadius: BorderRadius.circular(12)), child: Text(project.status.toUpperCase(), style: GoogleFonts.poppins(color: Colors.black87, fontSize: 10, fontWeight: FontWeight.bold))),
                        const SizedBox(height: 12),
                        Text(project.title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Row(children: [Text('Tüm Projeleri İncele', style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 13, fontWeight: FontWeight.w500)), const SizedBox(width: 4), const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16)]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFallbackBackground() {
    return Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [denizMavisi, acikMavi])), child: Stack(children: [Positioned(right: -20, top: -20, child: Icon(Icons.waves_rounded, size: 150, color: Colors.white.withOpacity(0.15)))]));
  }

  Widget _buildQuickActionsGrid() {
    final actions = [
      {'title': 'Çek-Gönder', 'icon': Icons.camera_alt_rounded, 'color': Colors.orange.shade500},
      {'title': 'E-Belediye', 'icon': Icons.computer_rounded, 'color': acikMavi},
      {'title': 'Belgeler', 'icon': Icons.description_rounded, 'color': Colors.indigo.shade400},
      {'title': 'Randevu', 'icon': Icons.calendar_month_rounded, 'color': Colors.purple.shade400},
      {'title': 'İletişim', 'icon': Icons.map_rounded, 'color': Colors.teal.shade500},
      {'title': 'Başkan', 'icon': Icons.person_rounded, 'color': denizMavisi},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.05),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final color = actions[index]['color'] as Color;
          final title = actions[index]['title'] as String;
          return Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: color.withOpacity(0.3), width: 1.2), boxShadow: [BoxShadow(color: color.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 5))]),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  switch (title) {
                    case 'Başkan': Navigator.push(context, MaterialPageRoute(builder: (context) => const MayorProfileScreen())); break;
                    case 'İletişim': Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactAndMapScreen())); break;
                    case 'Çek-Gönder': Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportIssueScreen())); break;
                    case 'E-Belediye': Navigator.push(context, MaterialPageRoute(builder: (context) => const EBelediyeScreen())); break;
                    case 'Belgeler': Navigator.push(context, MaterialPageRoute(builder: (context) => const DocumentGuideScreen())); break;
                    case 'Randevu': Navigator.push(context, MaterialPageRoute(builder: (context) => const AppointmentScreen())); break;
                  }
                },
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(actions[index]['icon'] as IconData, color: color, size: 30), const SizedBox(height: 10), Text(title, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: denizMavisi))]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDynamicAnnouncementsList() {
    return FutureBuilder<List<AnnouncementModel>>(
      future: _announcementsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0), child: Shimmer.fromColors(baseColor: Colors.grey[200]!, highlightColor: Colors.white, child: Container(height: 90, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)))));
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) return _buildEmptyState('Güncel duyuru bulunmuyor.', Icons.campaign_rounded);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: snapshot.data!.take(3).map((item) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(child: Container(width: 40, height: 5, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: acikMavi.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(item.category, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: acikMavi))),
                            const SizedBox(height: 12),
                            Text(item.title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: denizMavisi)),
                            const SizedBox(height: 16),
                            Text(item.summary.isNotEmpty ? item.summary : 'Bu duyuru ile ilgili içerik bilgisi sistemimizde mevcut değildir.', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700, height: 1.5)),
                            const SizedBox(height: 24),
                            SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: denizMavisi, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 14), elevation: 0), onPressed: () => Navigator.pop(context), child: Text('Kapat', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)))),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: denizMavisi.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
                  child: Row(
                    children: [
                      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: acikMavi.withOpacity(0.1), shape: BoxShape.circle), child: Icon(Icons.campaign_rounded, color: acikMavi, size: 18)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.date, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade500)), const SizedBox(height: 2), Text(item.title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: denizMavisi), maxLines: 2, overflow: TextOverflow.ellipsis)])),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildDynamicNewsList() {
    return SizedBox(
      height: 240,
      child: FutureBuilder<List<NewsModel>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 20.0), itemCount: 3, itemBuilder: (context, index) => _buildShimmerCard());
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) return _buildEmptyState('Güncel haber bulunmuyor.', Icons.newspaper_rounded);
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final news = snapshot.data![index];
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(news: news))),
                child: Container(
                  width: 260,
                  margin: const EdgeInsets.only(right: 16, bottom: 10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: denizMavisi.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5))]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(24)), child: Image.network(news.imageUrl, height: 130, width: double.infinity, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(height: 130, color: Colors.grey.shade200, child: Icon(Icons.image_not_supported, color: Colors.grey.shade400)))),
                      Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(news.category, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: acikMavi)), Text(news.date, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade500))]), const SizedBox(height: 8), Text(news.title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: denizMavisi), maxLines: 2, overflow: TextOverflow.ellipsis)])),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDynamicEventsList() {
    return FutureBuilder<List<EventModel>>(
      future: _eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0), child: Shimmer.fromColors(baseColor: Colors.grey[200]!, highlightColor: Colors.white, child: Container(height: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)))));
        if (!snapshot.hasData || snapshot.data!.isEmpty) return _buildEmptyState('Yaklaşan etkinlik bulunmuyor.', Icons.event_busy_rounded);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: snapshot.data!.take(3).map((event) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailScreen(event: event))),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
                  child: Row(
                    children: [
                      ClipRRect(borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)), child: event.imageUrl.isNotEmpty ? Image.network(event.imageUrl, width: 100, height: 100, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 100, height: 100, color: Colors.grey.shade100, child: Icon(Icons.event_note_rounded, color: Colors.grey.shade400, size: 32))) : Container(width: 100, height: 100, color: Colors.grey.shade100, child: Icon(Icons.event_note_rounded, color: Colors.grey.shade400, size: 32))),
                      Expanded(child: Padding(padding: const EdgeInsets.all(12.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(event.category, style: GoogleFonts.poppins(fontSize: 10, color: Colors.orange.shade700, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(event.title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: denizMavisi), maxLines: 2, overflow: TextOverflow.ellipsis), const SizedBox(height: 6), Row(children: [Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey.shade500), const SizedBox(width: 4), Text(event.date, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade600))])]))),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      width: 260, margin: const EdgeInsets.only(right: 16, bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200]!, highlightColor: Colors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(height: 130, width: double.infinity, decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24)))), Padding(padding: const EdgeInsets.all(16.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(height: 10, width: 80, color: Colors.white), const SizedBox(height: 12), Container(height: 14, width: double.infinity, color: Colors.white), const SizedBox(height: 8), Container(height: 14, width: 150, color: Colors.white)]))]),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
      child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: Colors.grey.shade400, size: 28), const SizedBox(height: 8), Text(message, textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.grey.shade500, fontSize: 12)), TextButton.icon(onPressed: _refreshData, icon: const Icon(Icons.refresh, color: Color(0xFF2980B9), size: 16), label: Text('Yenile', style: GoogleFonts.poppins(color: const Color(0xFF2980B9), fontSize: 12, fontWeight: FontWeight.bold)))])),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: denizMavisi)), GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTap, child: Padding(padding: const EdgeInsets.all(8.0), child: Text('Tümünü Gör', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: acikMavi))))]),
    );
  }
}