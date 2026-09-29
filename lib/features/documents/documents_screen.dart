import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color denizMavisi = const Color(0xFF154360);
    final Color acikMavi = const Color(0xFF2980B9);

    final List<Map<String, dynamic>> documents = [
      {'title': 'İmar Belgeleri ve Dilekçeler', 'icon': Icons.architecture_rounded, 'desc': 'İmar durum belgesi, yapı ruhsatı işlemleri'},
      {'title': 'Ruhsat ve İşyeri İşlemleri', 'icon': Icons.store_rounded, 'desc': 'İşyeri açma ve çalışma ruhsatı başvuruları'},
      {'title': 'Emlak ve Vergi İşlemleri', 'icon': Icons.receipt_long_rounded, 'desc': 'Rayiç bedel, beyanname ve borç yapılandırma'},
      {'title': 'Sosyal Yardım Başvuruları', 'icon': Icons.volunteer_activism_rounded, 'desc': 'Belediye destek ve yardım formları'},
      {'title': 'Genel Başvuru Formları', 'icon': Icons.description_rounded, 'desc': 'Dilekçe örnekleri ve resmi evraklar'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Belediye Belgeleri', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: denizMavisi)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: denizMavisi),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final doc = documents[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: acikMavi.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(doc['icon'] as IconData, color: acikMavi),
              ),
              title: Text(doc['title'] as String, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: denizMavisi)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(doc['desc'] as String, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600)),
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade400),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${doc['title']} kategorisi açılıyor...')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}