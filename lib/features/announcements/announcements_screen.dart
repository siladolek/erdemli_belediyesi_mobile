import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'announcement_service.dart';

class DuyurularScreen extends StatefulWidget {
  const DuyurularScreen({super.key});

  @override
  State<DuyurularScreen> createState() => _DuyurularScreenState();
}

class _DuyurularScreenState extends State<DuyurularScreen> {
  late Future<List<AnnouncementModel>> _announcementsFuture;

  @override
  void initState() {
    super.initState();
    _announcementsFuture = AnnouncementService.fetchAnnouncements();
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
          'Duyurular',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: primaryDark),
        ),
        iconTheme: IconThemeData(color: primaryDark),
      ),
      body: FutureBuilder<List<AnnouncementModel>>(
        future: _announcementsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: accentCyan));
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Duyuru bulunamadı.'));
          }

          final announcementsList = snapshot.data!;

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: announcementsList.length,
            itemBuilder: (context, index) {
              return ExpandableAnnouncementCard(item: announcementsList[index]);
            },
          );
        },
      ),
    );
  }
}

// ============================================================================
// KENDİ İÇİNDE GENİŞLEYEN KART TASARIMI (PROJELER EKRANI GİBİ)
// ============================================================================
class ExpandableAnnouncementCard extends StatefulWidget {
  final AnnouncementModel item;

  const ExpandableAnnouncementCard({super.key, required this.item});

  @override
  State<ExpandableAnnouncementCard> createState() => _ExpandableAnnouncementCardState();
}

class _ExpandableAnnouncementCardState extends State<ExpandableAnnouncementCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final Color primaryDark = const Color(0xFF102841);
    final Color accentCyan = const Color(0xFF00C4D4);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori ve Tarih Satırı
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentCyan.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.item.category,
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: accentCyan),
                  ),
                ),
                Text(
                  widget.item.date,
                  style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Başlık
            Text(
              widget.item.title,
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDark),
            ),
            const SizedBox(height: 12),

            // Genişleyen Detay Metni Alanı (Animasyonlu)
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(bottom: 16, top: 4),
                child: Text(
                  widget.item.summary.isNotEmpty ? widget.item.summary : 'Bu içerik için detay metni bulunmamaktadır.',
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade700, height: 1.5),
                ),
              ),
              crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),

            const Divider(height: 1),
            const SizedBox(height: 12),

            // Detayları Göster / Gizle Butonu
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isExpanded ? 'Detayları Gizle' : 'Detayları Görüntüle',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2980B9), // Mavi renk (Projeler ekranı gibi)
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF2980B9),
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}