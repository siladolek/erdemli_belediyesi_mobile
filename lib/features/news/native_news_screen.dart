import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'news_service.dart';

class NativeNewsScreen extends StatefulWidget {
  const NativeNewsScreen({super.key});

  @override
  State<NativeNewsScreen> createState() => _NativeNewsScreenState();
}

class _NativeNewsScreenState extends State<NativeNewsScreen> {
  late Future<List<NewsModel>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = NewsService.fetchNews();
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
          'Haberler',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: primaryDark),
        ),
        iconTheme: IconThemeData(color: primaryDark),
      ),
      body: FutureBuilder<List<NewsModel>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          // 1. LOADING DURUMU
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: accentCyan),
                  const SizedBox(height: 16),
                  Text(
                    'Erdemli Belediyesi web sitesinden gerçek veriler çekiliyor...',
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          // 2. HATA VEYA VERİ GELMEME DURUMU (ASLA SAHTE VERİ GÖSTERİLMEZ)
          else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off_rounded, size: 48, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Veriler şu anda yüklenemiyor.',
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: primaryDark),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lütfen internet bağlantınızı kontrol edin veya daha sonra tekrar deneyin.',
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
                          _newsFuture = NewsService.fetchNews();
                        });
                      },
                      child: Text('Tekrar Dene', style: GoogleFonts.inter(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. BAŞARILI DURUM - GERÇEK VERİLERİN MODERN MOBİL UI'DA GÖSTERİLMESİ
          final newsList = snapshot.data!;
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              final news = newsList[index];
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
                // HABERLERE TIKLAMA ÖZELLİĞİ EKLENDİ
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailScreen(news: news),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (news.imageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          child: Image.network(
                            news.imageUrl,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                    'Resmi Haber',
                                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: accentCyan),
                                  ),
                                ),
                                Text(
                                  news.date,
                                  style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              news.title,
                              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDark),
                            ),
                            if (news.summary.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                news.summary,
                                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
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
}

// EKSİK OLAN DETAY SAYFASI SINIFI BURAYA EKLENDİ
class NewsDetailScreen extends StatelessWidget {
  final NewsModel news;

  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final Color primaryDark = const Color(0xFF102841);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F9FC),
        elevation: 0,
        title: Text(
          'Haber Detayı',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: primaryDark),
        ),
        iconTheme: IconThemeData(color: primaryDark),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  news.imageUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const SizedBox.shrink(),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              news.date,
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              news.title,
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: primaryDark),
            ),
            const SizedBox(height: 16),
            Text(
              news.summary.isNotEmpty ? news.summary : 'Detaylı bilgi için web sitesini ziyaret edebilirsiniz.',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}