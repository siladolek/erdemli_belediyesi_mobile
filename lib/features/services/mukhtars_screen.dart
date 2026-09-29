import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// İŞTE EKSİK OLAN VE TÜM HATALARI ÇÖZEN İMPORTLAR:
import '../home/models/mukhtar_model.dart';
import 'mukhtar_service.dart';

class MukhtarsScreen extends StatefulWidget {
  const MukhtarsScreen({super.key});

  @override
  State<MukhtarsScreen> createState() => _MukhtarsScreenState();
}

class _MukhtarsScreenState extends State<MukhtarsScreen> {
  final Color denizMavisi = const Color(0xFF154360);
  final Color acikMavi = const Color(0xFF2980B9);
  final Color arkaPlan = const Color(0xFFF8F9FA);

  final MukhtarService _service = MukhtarService();

  List<MukhtarModel> _allMukhtars = [];
  List<MukhtarModel> _filteredMukhtars = [];
  bool _isLoading = true;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _fetchMukhtarsFromFirebase();
  }

  String _toTurkishLowerCase(String text) {
    return text.replaceAll('I', 'ı').replaceAll('İ', 'i').toLowerCase();
  }

  String _normalizeForSearch(String text) {
    return _toTurkishLowerCase(text)
        .replaceAll('ı', 'i')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ş', 's')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c');
  }

  Future<void> _fetchMukhtarsFromFirebase() async {
    try {
      final data = await _service.getMukhtars();

      if (mounted) {
        setState(() {
          _allMukhtars = data;
          _filteredMukhtars = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Veriler yüklenirken hata oluştu.";
          _isLoading = false;
        });
      }
    }
  }

  void _filterMukhtars(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMukhtars = _allMukhtars;
      } else {
        final arama = _normalizeForSearch(query);

        _filteredMukhtars = _allMukhtars.where((muhtar) {
          final mahalle = _normalizeForSearch(muhtar.mahalleAdi);
          final isim = _normalizeForSearch(muhtar.muhtarAdi);
          return mahalle.contains(arama) || isim.contains(arama);
        }).toList();
      }
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(' ', '');
    final Uri callUri = Uri(scheme: 'tel', path: cleanPhone);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Arama başlatılamadı.', style: GoogleFonts.poppins()), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  // TEK SEFERLİK OTOMATİK FİREBASE YÜKLEME FONKSİYONU
  Future<void> _uploadSeedData() async {
    setState(() => _isLoading = true);

    // Erdemli Belediyesi sitesinden alınan gerçek veriler
    const List<Map<String, String>> mukhtarSeedData = [
      {'muhtarAdi': 'Resul Keş', 'mahalleAdi': 'Adnan Menderes', 'telefon': '0536 552 09 54'},
      {'muhtarAdi': 'Ali Yarar', 'mahalleAdi': 'Akdeniz', 'telefon': '0536 399 08 25'},
      {'muhtarAdi': 'Mehmet Serin', 'mahalleAdi': 'Akpınar', 'telefon': '0532 589 22 03'},
      {'muhtarAdi': 'Hidayet Yıldırım', 'mahalleAdi': 'Alata', 'telefon': '0505 854 05 16'},
      {'muhtarAdi': 'Selami Yıldız', 'mahalleAdi': 'Alibeyli', 'telefon': '0537 742 93 12'},
      {'muhtarAdi': 'Ahmet Ali Açıkyörük', 'mahalleAdi': 'Arpaçbahşiş', 'telefon': '0535 338 84 29'},
      {'muhtarAdi': 'Caner Ünal', 'mahalleAdi': 'Arslanlı', 'telefon': '0539 230 58 85'},
      {'muhtarAdi': 'Bayram Kurt', 'mahalleAdi': 'Ayaş', 'telefon': '0535 826 87 51'},
      {'muhtarAdi': 'Hasan Yıldırım', 'mahalleAdi': 'Aydınlar', 'telefon': '0533 479 45 63'},
      {'muhtarAdi': 'Ali Dönmez', 'mahalleAdi': 'Barbaros', 'telefon': '0535 442 44 99'},
      {'muhtarAdi': 'Cevat Dişlen', 'mahalleAdi': 'Batısandal', 'telefon': '0537 981 33 78'},
      {'muhtarAdi': 'İlyas Erdem', 'mahalleAdi': 'Çamlı', 'telefon': '0532 633 19 09'},
      {'muhtarAdi': 'Osman Ersin', 'mahalleAdi': 'Çerçili', 'telefon': '0530 406 15 51'},
      {'muhtarAdi': 'Rıdvan Yılmaz', 'mahalleAdi': 'Çeşmeli', 'telefon': '0530 544 63 43'},
      {'muhtarAdi': 'Bilal Erenay', 'mahalleAdi': 'Çiftepınar', 'telefon': '0536 636 68 41'},
      {'muhtarAdi': 'Necat Şahin', 'mahalleAdi': 'Çiriş', 'telefon': '0531 213 99 53'},
      {'muhtarAdi': 'Baki Tel', 'mahalleAdi': 'Dağlı', 'telefon': '0537 472 86 92'},
      {'muhtarAdi': 'Hasan Bulut', 'mahalleAdi': 'Doğusandal', 'telefon': '0532 155 69 33'},
      {'muhtarAdi': 'Emin Balcı', 'mahalleAdi': 'Elbeyli', 'telefon': '0533 748 87 96'},
      {'muhtarAdi': 'Şükrü Yılmaz', 'mahalleAdi': 'Elvanlı', 'telefon': '0539 352 18 33'},
      {'muhtarAdi': 'Abdurrahman Gölgeli', 'mahalleAdi': 'Esenpınar', 'telefon': '0536 437 62 99'},
      {'muhtarAdi': 'Bayram Yazar', 'mahalleAdi': 'Evdilek', 'telefon': '0541 713 22 93'},
      {'muhtarAdi': 'Suat Yanar', 'mahalleAdi': 'Fakılı', 'telefon': '0535 400 63 42'},
      {'muhtarAdi': 'Mehmet Dağtepe', 'mahalleAdi': 'Fatih', 'telefon': '0536 821 70 35'},
      {'muhtarAdi': 'Emrah Ergen', 'mahalleAdi': 'Gücüş', 'telefon': '0533 481 25 62'},
      {'muhtarAdi': 'Halil Coşar', 'mahalleAdi': 'Güneyli', 'telefon': '0533 342 62 32'},
      {'muhtarAdi': 'İbrahim Doğan', 'mahalleAdi': 'Güzeloluk', 'telefon': '0536 541 96 97'},
      {'muhtarAdi': 'Muhammed Var', 'mahalleAdi': 'Hacıalanı', 'telefon': '0537 665 12 47'},
      {'muhtarAdi': 'Mehmet Taş', 'mahalleAdi': 'Hacıhalilarpaç', 'telefon': '0536 655 46 74'},
      {'muhtarAdi': 'Musa Poyraz', 'mahalleAdi': 'Harfilli', 'telefon': '0537 315 12 08'},
      {'muhtarAdi': 'Misap Aksay', 'mahalleAdi': 'Hüsametli', 'telefon': '0536 898 03 90'},
      {'muhtarAdi': 'Eray Uzlar', 'mahalleAdi': 'İlemin', 'telefon': '0531 788 08 56'},
      {'muhtarAdi': 'Yusuf Gürsoy', 'mahalleAdi': 'Karaahmetli', 'telefon': '0533 765 35 23'},
      {'muhtarAdi': 'Ömer Çolak', 'mahalleAdi': 'Karahıdırlı', 'telefon': '0533 313 74 37'},
      {'muhtarAdi': 'Musa Koruk', 'mahalleAdi': 'Karakeşli', 'telefon': '0536 377 03 54'},
      {'muhtarAdi': 'Mustafa Yıldız', 'mahalleAdi': 'Karayakup', 'telefon': '0539 839 69 61'},
      {'muhtarAdi': 'Durmuş Kara', 'mahalleAdi': 'Kargıcak', 'telefon': '0532 232 26 17'},
      {'muhtarAdi': 'Mehmet Yıldırım', 'mahalleAdi': 'Kargıpınarı', 'telefon': '0532 402 75 02'},
      {'muhtarAdi': 'Hüseyin Bakkal', 'mahalleAdi': 'Kayacı', 'telefon': '0531 949 75 87'},
      {'muhtarAdi': 'İlyas Eser', 'mahalleAdi': 'Kızılen', 'telefon': '0536 473 01 10'},
      {'muhtarAdi': 'Murat Kale', 'mahalleAdi': 'Kızkalesi', 'telefon': '0533 350 35 65'},
      {'muhtarAdi': 'Mahmut Yazgan', 'mahalleAdi': 'Kocahasanlı', 'telefon': '0535 830 56 78'},
      {'muhtarAdi': 'Hasan Kurt', 'mahalleAdi': 'Koramşalı', 'telefon': '0532 314 15 04'},
      {'muhtarAdi': 'İlhan Çerçi', 'mahalleAdi': 'Koyuncu', 'telefon': '0541 515 64 09'},
      {'muhtarAdi': 'Cengiz Kaya', 'mahalleAdi': 'Kösbucağı', 'telefon': '0535 308 75 11'},
      {'muhtarAdi': 'Alaaddin Küçük', 'mahalleAdi': 'Kösereli', 'telefon': '0535 479 10 45'},
      {'muhtarAdi': 'Adem Güp', 'mahalleAdi': 'Kumkuyu', 'telefon': '0532 662 26 56'},
      {'muhtarAdi': 'Zübeyir Gök', 'mahalleAdi': 'Kuşluca', 'telefon': '0536 361 37 95'},
      {'muhtarAdi': 'Ali Issı', 'mahalleAdi': 'Küstüllü', 'telefon': '0536 568 85 10'},
      {'muhtarAdi': 'Orhan Çelik', 'mahalleAdi': 'Limonlu', 'telefon': '0532 332 46 85'},
      {'muhtarAdi': 'Adem Koşar', 'mahalleAdi': 'Merkez', 'telefon': '0535 522 46 72'},
      {'muhtarAdi': 'Murat Ergen', 'mahalleAdi': 'Pınarbaşı', 'telefon': '0535 929 21 37'},
      {'muhtarAdi': 'Cihan Özer', 'mahalleAdi': 'Sarıkaya', 'telefon': '0537 821 09 23'},
      {'muhtarAdi': 'Nusret Demiraslan', 'mahalleAdi': 'Sarıyer', 'telefon': '0533 550 67 68'},
      {'muhtarAdi': 'Musa Özdeniz', 'mahalleAdi': 'Sıraç', 'telefon': '0536 249 48 98'},
      {'muhtarAdi': 'Fevzi İlhan', 'mahalleAdi': 'Sinap', 'telefon': '0507 149 13 88'},
      {'muhtarAdi': 'Mehmet Gür', 'mahalleAdi': 'Sorgun', 'telefon': '0532 286 84 08'},
      {'muhtarAdi': 'Cumali Toker', 'mahalleAdi': 'Şahna', 'telefon': '0538 709 05 03'},
      {'muhtarAdi': 'Doğan Çiftçi', 'mahalleAdi': 'Tabiye', 'telefon': '0532 621 53 17'},
      {'muhtarAdi': 'Mehmet Emin Özgür', 'mahalleAdi': 'Tapureli', 'telefon': '0533 011 00 33'},
      {'muhtarAdi': 'Abdurrahman Şavk', 'mahalleAdi': 'Toros', 'telefon': '0538 897 13 42'},
      {'muhtarAdi': 'İlhan Bağcı', 'mahalleAdi': 'Tozlu', 'telefon': '0545 508 55 33'},
      {'muhtarAdi': 'Osman Ülker', 'mahalleAdi': 'Tömük', 'telefon': '0535 551 85 71'},
      {'muhtarAdi': 'Ali Salma', 'mahalleAdi': 'Türbe', 'telefon': '0532 433 70 56'},
      {'muhtarAdi': 'Mehmet Koç', 'mahalleAdi': 'Üçtepe', 'telefon': '0507 923 68 80'},
      {'muhtarAdi': 'Mustafa Keşli', 'mahalleAdi': 'Üzümlü', 'telefon': '0535 698 45 07'},
      {'muhtarAdi': 'Mahmut Yılmaz', 'mahalleAdi': 'Veyselli', 'telefon': '0530 132 45 22'},
      {'muhtarAdi': 'Mehmet Civelek', 'mahalleAdi': 'Yağda', 'telefon': '0530 043 77 35'},
      {'muhtarAdi': 'Rüstem Koç', 'mahalleAdi': 'Yarenler', 'telefon': '0533 541 25 60'},
      {'muhtarAdi': 'Ertuğrul Tat', 'mahalleAdi': 'Yeniyurt', 'telefon': '0536 769 47 09'},
      {'muhtarAdi': 'Fatin Rüştü Yılmaz', 'mahalleAdi': 'Yüksek', 'telefon': '0539 712 50 25'},
    ];

    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    for (var data in mukhtarSeedData) {
      final docRef = firestore.collection('muhtarliklar').doc();
      batch.set(docRef, data);
    }

    await batch.commit();

    // Yükleme bittikten sonra listeyi tekrar çek
    await _fetchMukhtarsFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: arkaPlan,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Muhtarlıklar',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: denizMavisi),
        ),
        iconTheme: IconThemeData(color: denizMavisi),
      ),
      body: Column(
        children: [
          // ARAMA ÇUBUĞU
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: arkaPlan,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                onChanged: _filterMukhtars,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  prefixIcon: Icon(CupertinoIcons.search, color: acikMavi),
                  hintText: "Mahalle veya Muhtar adı ara...",
                  hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // LİSTE, YÜKLENİYOR, HATA VEYA "VERİLERİ YÜKLE" EKRANI
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: acikMavi))
                : _errorMessage.isNotEmpty
                ? Center(
              child: Text(_errorMessage, style: GoogleFonts.poppins(color: Colors.red.shade600)),
            )
                : _allMukhtars.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined, size: 64, color: acikMavi.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text('Veritabanı şu an boş.', style: GoogleFonts.poppins(color: Colors.grey)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: denizMavisi,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _uploadSeedData,
                    icon: const Icon(Icons.download, color: Colors.white),
                    label: Text('Tüm Muhtarları Yükle', style: GoogleFonts.poppins(color: Colors.white)),
                  )
                ],
              ),
            )
                : _filteredMukhtars.isEmpty
                ? Center(
              child: Text('Aradığınız kriterde muhtar bulunamadı.', style: GoogleFonts.poppins(color: Colors.grey)),
            )
                : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: _filteredMukhtars.length,
              itemBuilder: (context, index) {
                final muhtar = _filteredMukhtars[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: acikMavi.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          muhtar.mahalleAdi.isNotEmpty ? muhtar.mahalleAdi[0] : 'M',
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: acikMavi),
                        ),
                      ),
                    ),
                    title: Text('${muhtar.mahalleAdi} Mahallesi', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: denizMavisi)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(muhtar.muhtarAdi, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600)),
                    ),
                    trailing: InkWell(
                      onTap: () => _makePhoneCall(muhtar.telefon),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                        child: Icon(Icons.phone_in_talk_rounded, color: Colors.green.shade600, size: 20),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}