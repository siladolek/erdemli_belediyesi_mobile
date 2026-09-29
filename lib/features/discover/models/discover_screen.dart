import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart'; // YOL TARİFİ İÇİN EKLENDİ

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final Color denizMavisi = const Color(0xFF154360);
  final Color acikMavi = const Color(0xFF2980B9);
  final Color bgLight = const Color(0xFFF8F9FA);

  int _selectedCategoryIndex = 0;
  bool _isLoading = true;

  final List<String> _categories = [
    'Tümü', 'Kafeler', 'Restoranlar', 'Plajlar', 'Kamp Alanları', 'Tarihi Yerler'
  ];

  List<Map<String, dynamic>> _allPlaces = [];

  @override
  void initState() {
    super.initState();
    _fetchPlacesFromFirebase();
  }

  Future<void> _fetchPlacesFromFirebase() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('places').get();

      if (mounted) {
        setState(() {
          _allPlaces = snapshot.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Mekanları çekerken hata oluştu: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // YOL TARİFİ FONKSİYONU (EKLENDİ)
  Future<void> _launchMaps(dynamic lat, dynamic lng) async {
    final double? latitude = lat != null ? double.tryParse(lat.toString()) : null;
    final double? longitude = lng != null ? double.tryParse(lng.toString()) : null;

    if (latitude == null || longitude == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bu mekan için geçerli konum bilgisi bulunamadı.')),
        );
      }
      return;
    }

    final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harita uygulaması açılamadı.')),
        );
      }
    }
  }

  // YEDEK FOTOĞRAFLAR
  String _getFallbackImage(String category) {
    switch (category) {
      case 'Kafeler': return 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?auto=format&fit=crop&q=80&w=800';
      case 'Restoranlar': return 'https://images.unsplash.com/photo-1627308595229-7830f5c90683?auto=format&fit=crop&q=80&w=800';
      case 'Plajlar': return 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&q=80&w=800';
      case 'Kamp Alanları': return 'https://images.unsplash.com/photo-1504280390267-3140085eb24c?auto=format&fit=crop&q=80&w=800';
      case 'Tarihi Yerler': return 'https://images.unsplash.com/photo-1549471013-3364d7220b75?auto=format&fit=crop&q=80&w=800';
      default: return 'https://images.unsplash.com/photo-1496886007421-477bf27a054a?auto=format&fit=crop&q=80&w=800';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredPlaces = _selectedCategoryIndex == 0
        ? _allPlaces
        : _allPlaces.where((place) => place['category'] == _categories[_selectedCategoryIndex]).toList();

    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Erdemli\'yi Keşfet',
          style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: denizMavisi
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.map_rounded, color: denizMavisi),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          // KATEGORİ SEÇİCİ
          Container(
            height: 60,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                bool isSelected = _selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategoryIndex = index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected ? acikMavi : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? acikMavi : Colors.grey.shade300,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _categories[index],
                      style: GoogleFonts.poppins(
                        color: isSelected ? Colors.white : denizMavisi,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // MEKAN LİSTESİ
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: acikMavi))
                : filteredPlaces.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_rounded, size: 60, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Bu kategoride mekan bulunamadı.',
                    style: GoogleFonts.poppins(color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
                : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: filteredPlaces.length,
              itemBuilder: (context, index) {
                final place = filteredPlaces[index];
                return _buildPlaceCard(place);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(Map<String, dynamic> place) {
    List<dynamic> rawImageUrls = place['imageUrls'] ?? [];
    String singleImageUrl = place['imageUrl'] ?? '';

    String validImageUrl = '';
    if (rawImageUrls.isNotEmpty && rawImageUrls[0] != null && rawImageUrls[0].toString().isNotEmpty) {
      validImageUrl = rawImageUrls[0].toString();
    } else if (singleImageUrl.isNotEmpty) {
      validImageUrl = singleImageUrl;
    }

    // KRİTİK DÜZELTME: Eğer link Google API içeriyorsa (ve patlıyorsa), linki kasıtlı olarak siliyoruz!
    if (validImageUrl.contains('googleapis')) {
      validImageUrl = '';
    }

    String displayImageUrl = validImageUrl.isNotEmpty ? validImageUrl : _getFallbackImage(place['category'] ?? '');

    // ADRES VE AÇIKLAMA DÜZELTMESİ
    String descText = place['description'] ?? '';
    String addrText = place['address'] ?? '';

    // Eğer adres boşsa, description içindeki veriyi adres gibi gösteriyoruz
    if (addrText.isEmpty || addrText == 'Adres girilmemiş') {
      addrText = descText.isNotEmpty ? descText : 'Erdemli / Mersin';
      descText = ''; // Açıklamayı boşaltıyoruz ki ekranda alt alta aynı şey iki kere yazmasın
    }

    // KONUM BİLGİLERİNİ ÇEKİYORUZ (YOL TARİFİ İÇİN)
    final dynamic lat = place['latitude'];
    final dynamic lng = place['longitude'];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // GÖRSEL ALANI
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Stack(
              children: [
                Image.network(
                  displayImageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // İkinci bir güvenlik duvarı: Eğer Unsplash resmi bile yüklenemezse kırmızı hata yerine gri kutu basar
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported_rounded, color: Colors.grey.shade400, size: 40),
                          const SizedBox(height: 8),
                          Text('Görsel Yüklenemedi', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade500)),
                        ],
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          place['rating']?.toString() ?? '0.0',
                          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // BİLGİ ALANI
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    place['category'] ?? 'Genel',
                    style: GoogleFonts.poppins(
                      color: Colors.orange.shade700,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  place['name'] ?? 'İsimsiz Mekan',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: denizMavisi,
                  ),
                ),
                if (descText.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    descText,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_rounded, size: 16, color: Colors.grey.shade400),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        addrText,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: acikMavi,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    // BUTONA TIKLANDIĞINDA YÖNLENDİRME YAPILIR
                    onPressed: () => _launchMaps(lat, lng),
                    icon: const Icon(Icons.directions_rounded, color: Colors.white, size: 18),
                    label: Text(
                      'Yol Tarifi Al',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
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
}