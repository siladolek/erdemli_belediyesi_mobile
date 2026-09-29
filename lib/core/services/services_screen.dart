import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'service_service.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  late Future<List<ServiceModel>> _servicesFuture;

  @override
  void initState() {
    super.initState();
    _servicesFuture = ServiceService.fetchServices();
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (urlString.isNotEmpty && await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
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
          'Belediye Hizmetleri',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: primaryDark),
        ),
        iconTheme: IconThemeData(color: primaryDark),
      ),
      body: FutureBuilder<List<ServiceModel>>(
        future: _servicesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: accentCyan),
                  const SizedBox(height: 16),
                  Text('Hizmetler yükleniyor...', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            );
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off_rounded, size: 48, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text('Hizmet verileri şu anda yüklenemiyor.', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: primaryDark), textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Text('İnternet bağlantınızı kontrol edip tekrar deneyin.', style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600), textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: primaryDark, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: () => setState(() => _servicesFuture = ServiceService.fetchServices()),
                      child: Text('Tekrar Dene', style: GoogleFonts.inter(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }

          final servicesList = snapshot.data!;
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: servicesList.length,
            itemBuilder: (context, index) {
              final service = servicesList[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: accentCyan.withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(Icons.domain_rounded, color: accentCyan),
                  ),
                  title: Text(service.title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDark)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(service.description, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400),
                  onTap: () => _launchURL(service.link),
                ),
              );
            },
          );
        },
      ),
    );
  }
}