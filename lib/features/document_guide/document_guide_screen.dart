import 'package:flutter/material.dart';

class DocumentGuideScreen extends StatefulWidget {
  const DocumentGuideScreen({super.key});

  @override
  State<DocumentGuideScreen> createState() => _DocumentGuideScreenState();
}

class _DocumentGuideScreenState extends State<DocumentGuideScreen> {
  final Color primaryNavy = const Color(0xFF1E3A8A);
  final Color primaryTeal = const Color(0xFF008272);

  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Evlendirme İşlemleri',
      'icon': Icons.favorite,
      'color': Colors.pink,
      'description': 'Nikah başvurusu için gerekli adımlar ve evraklar:',
      'steps': [
        'Çiftlerin birlikte belediyeye müracaat etmesi gereklidir.',
        'Son 6 ay içinde çekilmiş 6\'şar adet vesikalık fotoğraf.',
        'Resmi onaylı Nüfus Cüzdanı aslı ve fotokopisi.',
        'Aile Sağlığı Merkezlerinden alınan resmi sağlık raporu (Çiftler için onaylı).',
        'İkametgah belgesi (E-devlet üzerinden alınabilir).'
      ]
    },
    {
      'title': 'İş Yeri Açma ve Çalışma Ruhsatı',
      'icon': Icons.store,
      'color': Colors.orange,
      'description': 'Ticari faaliyetler için izlenecek yasal süreç:',
      'steps': [
        'Vergi levhası fotokopisi.',
        'İş yerinin tapu ve yapı kullanım izin belgesi.',
        'Kira sözleşmesi (İş yeri kiralık ise noter onaylı).',
        'İtfaiye raporu (Yangın güvenliği uygunluk yazısı).',
        'Oda kayıt belgesi ve Esnaf Sicil Tasdiknamesi.'
      ]
    },
    {
      'title': 'İmar Durumu Başvurusu',
      'icon': Icons.architecture,
      'color': Colors.blue,
      'description': 'Arsa ve yapı yapılaşma koşulları için başvuru evrakları:',
      'steps': [
        'Güncel tarihli Tapu Belgesi (Çap ve vaziyet planı ile birlikte).',
        'Bağlı bulunulan tapu müdürlüğünden alınan güncel tapu kayıt belgesi.',
        'Vekaleten başvuru yapılması durumunda noter onaylı vekaletname.',
        'İlgili belediye imar müdürlüğünden temin edilen başvuru dilekçesi.'
      ]
    },
    {
      'title': 'Sosyal Yardım ve Destek Başvuruları',
      'icon': Icons.support_agent,
      'color': Colors.green,
      'description': 'Belediye sosyal yardımlarından faydalanma şartları:',
      'steps': [
        'T.C. Kimlik numaralı nüfus cüzdanı fotokopisi.',
        'Muhtarlıktan alınmış fakirlik veya gelir durum belgesi.',
        'SGK tescil ve hizmet döküm belgesi.',
        'Engelli veya kronik hastalar için resmi sağlık kurulu raporu.'
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: primaryNavy,
        elevation: 2,
        title: const Text('Belge ve İşlem Rehberi', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: ExpansionTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: (cat['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(cat['icon'], color: cat['color']),
              ),
              title: Text(cat['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: primaryNavy)),
              subtitle: Text(cat['description'], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              childrenPadding: const EdgeInsets.all(16),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 8),
                const Text('Gerekli Adımlar ve Evraklar:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                const SizedBox(height: 8),
                ...(cat['steps'] as List<String>).map((step) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle, size: 16, color: primaryTeal),
                      const SizedBox(width: 8),
                      Expanded(child: Text(step, style: const TextStyle(fontSize: 13, height: 1.4))),
                    ],
                  ),
                )),
              ],
            ),
          );
        },
      ),
    );
  }
}