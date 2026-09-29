import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final Gradient primaryGradient = const LinearGradient(
    colors: [Color(0xFF0B3C5D), Color(0xFF1D80C2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        flexibleSpace: Container(decoration: BoxDecoration(gradient: primaryGradient)),
        elevation: 10,
        shadowColor: const Color(0xFF0B3C5D).withOpacity(0.4),
        title: Text('Çek & Gönder', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sorun Bildir', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: const Color(0xFF0B3C5D))),
            const SizedBox(height: 8),
            Text('Çevrenizde gördüğünüz aksaklıkları fotoğraflayarak bize anında iletebilirsiniz.', style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13, height: 1.4)),
            const SizedBox(height: 24),

            // Fotoğraf Yükleme Alanı
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF00B4DB).withOpacity(0.5), width: 2, style: BorderStyle.solid),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFF00B4DB).withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.add_a_photo_rounded, size: 32, color: Color(0xFF00B4DB)),
                  ),
                  const SizedBox(height: 12),
                  Text('Fotoğraf Çek veya Yükle', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFF0B3C5D))),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Açıklama Alanı
            TextFormField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Sorunu kısaca açıklayın...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF1D80C2), width: 2)),
              ),
            ),
            const SizedBox(height: 20),

            // Konum Alanı
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  const Icon(Icons.location_on_rounded, color: Colors.redAccent, size: 24),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Mevcut konumunuz otomatik alınacaktır.', style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade700))),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Gönder Butonu
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Talebiniz başarıyla alınmıştır!'), backgroundColor: Colors.green),
                  );
                  Navigator.pop(context);
                },
                child: Ink(
                  decoration: BoxDecoration(gradient: primaryGradient, borderRadius: BorderRadius.circular(16)),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text('Bildirimi Gönder', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}