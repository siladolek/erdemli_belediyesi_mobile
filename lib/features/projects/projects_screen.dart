import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'project_service.dart'; // Modelimiz artık bu dosyanın içinde olduğu için sadece bu yeterli!

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final Color denizMavisi = const Color(0xFF154360);
  final Color acikMavi = const Color(0xFF2980B9);
  final Color arkaPlan = const Color(0xFFF8F9FA);

  late Future<List<ProjectModel>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = ProjectService.fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: arkaPlan,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Projelerimiz', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: denizMavisi)),
        iconTheme: IconThemeData(color: denizMavisi),
      ),
      body: FutureBuilder<List<ProjectModel>>(
        future: _projectsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: 4,
              itemBuilder: (context, index) => _buildSkeletonCard(),
            );
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.architecture_rounded, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text('Henüz proje bulunamadı.', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
                ],
              ),
            );
          }

          final projectsList = snapshot.data!;
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: projectsList.length,
            itemBuilder: (context, index) {
              return ExpandableProjectCard(project: projectsList[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200]!, highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 180, width: double.infinity, decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20)))),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(height: 24, width: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))), const SizedBox(height: 16), Container(height: 18, width: double.infinity, color: Colors.white), const SizedBox(height: 8), Container(height: 18, width: 200, color: Colors.white)]),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// GENİŞLEYEBİLİR (EXPANDABLE) PROJE KARTI
// ============================================================================
class ExpandableProjectCard extends StatefulWidget {
  final ProjectModel project;

  const ExpandableProjectCard({super.key, required this.project});

  @override
  State<ExpandableProjectCard> createState() => _ExpandableProjectCardState();
}

class _ExpandableProjectCardState extends State<ExpandableProjectCard> {
  bool _isExpanded = false;

  final Color denizMavisi = const Color(0xFF154360);
  final Color acikMavi = const Color(0xFF2980B9);

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Proje Görseli
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: widget.project.imageUrl.isNotEmpty
                ? Image.network(
              widget.project.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
            )
                : _buildFallbackImage(),
          ),

          // Sabit Bilgiler ve Buton Alanı
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: acikMavi.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text(widget.project.category, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: acikMavi)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFFFF8E1), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFFFECB3))),
                      child: Text(widget.project.status, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange.shade800)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.project.title,
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: denizMavisi, height: 1.3),
                ),
                if (widget.project.location.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded, size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 6),
                      Expanded(child: Text(widget.project.location, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ],
                const SizedBox(height: 16),

                // --- AŞAĞI DOĞRU AÇILAN DETAY METNİ ---
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: SizedBox(
                    width: double.infinity,
                    child: _isExpanded
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE))),
                        Text(
                          widget.project.description.isNotEmpty
                              ? widget.project.description
                              : 'Bu projenin detay metni bulunmamaktadır.',
                          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade800, height: 1.6),
                        ),
                        const SizedBox(height: 16),
                      ],
                    )
                        : const SizedBox.shrink(),
                  ),
                ),

                // --- DETAYLARI GÖSTER/GİZLE BUTONU ---
                InkWell(
                  onTap: _toggleExpand,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isExpanded ? 'Detayları Gizle' : 'Detayları Görüntüle',
                          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: acikMavi),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: acikMavi,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      height: 180,
      width: double.infinity,
      color: const Color(0xFFF8F9FA),
      child: Center(child: Icon(Icons.architecture_rounded, size: 48, color: const Color(0xFF2980B9).withOpacity(0.3))),
    );
  }
}