import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EZoningScreen extends StatefulWidget {
  const EZoningScreen({super.key});

  @override
  State<EZoningScreen> createState() => _EZoningScreenState();
}

class _EZoningScreenState extends State<EZoningScreen> {
  final Color denizMavisi = const Color(0xFF154360);
  final Color acikMavi = const Color(0xFF2980B9);
  final Color arkaPlan = const Color(0xFFF8F9FA);

  int _selectedTab = 0;
  bool _isLoading = false;

  String? _selectedMahalleAda;
  final TextEditingController _adaController = TextEditingController();
  final TextEditingController _parselController = TextEditingController();

  String? _selectedMahalleAdres;
  String? _selectedSokak;
  String? _selectedKapiNo;

  final List<String> _mahalleler = [
    'Akdeniz', 'Akpınar', 'Alata', 'Alibeyli', 'Arpaçbahşiş', 'Aslanlı', 'Ayaş', 'Aydınlar',
    'Bağalanı', 'Barbaros', 'Batısandal', 'Çamlı', 'Çerçili', 'Çeşmeli', 'Çiftepınar', 'Çiriş',
    'Dağlı', 'Doğusandal', 'Elbeyli', 'Elvanlı', 'Emirhacı', 'Esenpınar', 'Evdilek', 'Fakılı',
    'Fatih', 'Güneyli', 'Güzeloluk', 'Hacıalanı', 'Hacıhalilarpaç', 'Harfilli', 'Hüsametli', 'İlemin',
    'Karahıdırlı', 'Karaleç', 'Karayakup', 'Kargıcak', 'Kargıpınarı', 'Kayacı', 'Kızılen', 'Kızkalesi',
    'Kocahasanlı', 'Koramşalı', 'Koyuncu', 'Kösbucağı', 'Kösereli', 'Kumkuyu', 'Kuşluca', 'Küstülü',
    'Limonlu', 'Merkez', 'Pınarbaşı', 'Sarıkaya', 'Sinap', 'Sıraç', 'Şahna', 'Tabiye', 'Tapureli',
    'Toros', 'Tozlu', 'Tömük', 'Türbe', 'Üçtepe', 'Veyselli', 'Yalı', 'Yeniyurt'
  ];

  final List<String> _ornekSokaklar = ['1. Sokak', '2. Sokak', 'Atatürk Caddesi', 'Cumhuriyet Bulvarı', 'Karanfil Sokak', 'Gül Sokak'];
  final List<String> _ornekKapiNolar = ['1', '2', '2/A', '3', '4/B', '5', '10', '12', '15', '22'];

  // Turkce karakterleri sadelestirip arama yaparken "husametli" yazsa bile
  // "Husametli" ile eslesmesini saglar.
  String _normalize(String input) {
    return input
        .toLowerCase()
        .replaceAll('ı', 'i')
        .replaceAll('İ', 'i')
        .replaceAll('ş', 's')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c');
  }

  Future<void> _sorgula() async {
    FocusScope.of(context).unfocus();

    if (_selectedTab == 0) {
      if (_selectedMahalleAdres == null || _selectedSokak == null || _selectedKapiNo == null) {
        _hataGoster('Lütfen Mahalle, Sokak ve Kapı No bilgilerini eksiksiz seçin.');
        return;
      }
    } else {
      if (_selectedMahalleAda == null || _adaController.text.isEmpty || _parselController.text.isEmpty) {
        _hataGoster('Lütfen Mahalle, Ada ve Parsel bilgilerini eksiksiz girin.');
        return;
      }
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);
    _showResultSheet();
  }

  void _hataGoster(String mesaj) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mesaj, style: GoogleFonts.poppins()), backgroundColor: Colors.red.shade600, behavior: SnackBarBehavior.floating),
    );
  }

  // ============================================================================
  // KOMPAKT VE ARANABILIR MAHALLE SECICI (Tam ekran degil, alt pencere)
  // ============================================================================
  Future<void> _showMahalleSecici({required String? currentValue, required Function(String) onSelected}) async {
    String searchQuery = '';

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final normalizedQuery = _normalize(searchQuery);
            final filtered = _mahalleler.where((m) => _normalize(m).contains(normalizedQuery)).toList();

            return Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.65),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Row(
                      children: [
                        Icon(Icons.location_city_rounded, color: acikMavi, size: 20),
                        const SizedBox(width: 8),
                        Text('Mahalle Seçin', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: denizMavisi)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: arkaPlan,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: TextField(
                        autofocus: false,
                        style: GoogleFonts.poppins(fontSize: 14, color: denizMavisi),
                        decoration: InputDecoration(
                          hintText: 'Mahalle ara...',
                          hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 14),
                          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 20),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onChanged: (val) => setModalState(() => searchQuery = val),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: filtered.isEmpty
                        ? Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text('Sonuç bulunamadı.', style: GoogleFonts.poppins(color: Colors.grey.shade500)),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final mahalle = filtered[index];
                        final isSelected = mahalle == currentValue;
                        return ListTile(
                          onTap: () {
                            onSelected(mahalle);
                            Navigator.pop(context);
                          },
                          title: Text(
                            mahalle,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? acikMavi : denizMavisi,
                            ),
                          ),
                          trailing: isSelected ? Icon(Icons.check_circle_rounded, color: acikMavi, size: 20) : null,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showResultSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle), child: Icon(Icons.check_circle_rounded, color: Colors.green.shade600, size: 28)),
                const SizedBox(width: 16),
                Text('İmar Durumu Sonucu', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: denizMavisi)),
              ],
            ),
            const SizedBox(height: 24),
            if (_selectedTab == 0) ...[
              _buildResultRow('Sorgu Tipi', 'Adres ile Sorgulama'),
              _buildResultRow('Adres Bilgisi', '$_selectedMahalleAdres Mah. $_selectedSokak No:$_selectedKapiNo'),
            ] else ...[
              _buildResultRow('Sorgu Tipi', 'Ada/Parsel ile Sorgulama'),
              _buildResultRow('Mahalle', '$_selectedMahalleAda'),
              _buildResultRow('Ada / Parsel', '${_adaController.text} / ${_parselController.text}'),
            ],
            _buildResultRow('İmar Durumu', 'Konut Alanı (Taks: 0.30, Kaks: 1.50)'),
            _buildResultRow('Kat İzni', 'Zemin + 4 Kat'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(foregroundColor: acikMavi, side: BorderSide(color: acikMavi), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                icon: const Icon(Icons.picture_as_pdf_rounded),
                label: Text('Resmi Belgeyi İndir (PDF)', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PDF indiriliyor...'), behavior: SnackBarBehavior.floating));
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label, style: GoogleFonts.poppins(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500))),
          Expanded(child: Text(value, style: GoogleFonts.poppins(color: denizMavisi, fontWeight: FontWeight.w600, fontSize: 14))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: arkaPlan,
      appBar: AppBar(
        backgroundColor: arkaPlan,
        elevation: 0,
        centerTitle: true,
        title: Text('İmar İşleri', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: denizMavisi)),
        iconTheme: IconThemeData(color: denizMavisi),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BASLIK - Daha gorsel, ikonlu kart
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [denizMavisi, acikMavi], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: denizMavisi.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 8))],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.architecture_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("E-İmar Sorgulama", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text("Güncel imar durumunu hızlıca öğrenin", style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.85), fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Container(
              height: 50,
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedTab == 0 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: _selectedTab == 0 ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))] : [],
                        ),
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(4),
                        child: Text("Adres Bilgileri", style: GoogleFonts.poppins(fontSize: 13, fontWeight: _selectedTab == 0 ? FontWeight.bold : FontWeight.w600, color: _selectedTab == 0 ? denizMavisi : Colors.grey.shade600)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedTab == 1 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: _selectedTab == 1 ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))] : [],
                        ),
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(4),
                        child: Text("Ada/Parsel", style: GoogleFonts.poppins(fontSize: 13, fontWeight: _selectedTab == 1 ? FontWeight.bold : FontWeight.w600, color: _selectedTab == 1 ? denizMavisi : Colors.grey.shade600)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            _selectedTab == 0 ? _buildAdresForm() : _buildAdaParselForm(),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sorgula,
                style: ElevatedButton.styleFrom(
                  backgroundColor: acikMavi,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  disabledBackgroundColor: acikMavi.withOpacity(0.7),
                ),
                child: _isLoading
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                    : Text('Sorgula', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdresForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdownLabel("Mahalle"),
        _buildMahalleSeciciKutusu(
          value: _selectedMahalleAdres,
          onTap: () => _showMahalleSecici(
            currentValue: _selectedMahalleAdres,
            onSelected: (val) => setState(() {
              _selectedMahalleAdres = val;
              _selectedSokak = null;
              _selectedKapiNo = null;
            }),
          ),
        ),
        const SizedBox(height: 20),

        _buildDropdownLabel("Sokak / Cadde"),
        _buildDropdown(
          value: _selectedSokak,
          items: _ornekSokaklar,
          hint: "Seçiniz",
          isEnabled: _selectedMahalleAdres != null,
          onChanged: (val) => setState(() {
            _selectedSokak = val;
            _selectedKapiNo = null;
          }),
        ),
        const SizedBox(height: 20),

        _buildDropdownLabel("Kapı No"),
        _buildDropdown(
          value: _selectedKapiNo,
          items: _ornekKapiNolar,
          hint: "Seçiniz",
          isEnabled: _selectedSokak != null,
          onChanged: (val) => setState(() => _selectedKapiNo = val),
        ),
      ],
    );
  }

  Widget _buildAdaParselForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdownLabel("Mahalle"),
        _buildMahalleSeciciKutusu(
          value: _selectedMahalleAda,
          onTap: () => _showMahalleSecici(
            currentValue: _selectedMahalleAda,
            onSelected: (val) => setState(() => _selectedMahalleAda = val),
          ),
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownLabel("Ada No"),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                    child: TextField(
                      controller: _adaController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.poppins(color: denizMavisi, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(hintText: 'Örn: 1024', hintStyle: GoogleFonts.poppins(color: Colors.grey.shade300, fontSize: 14), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownLabel("Parsel No"),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                    child: TextField(
                      controller: _parselController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.poppins(color: denizMavisi, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(hintText: 'Örn: 5', hintStyle: GoogleFonts.poppins(color: Colors.grey.shade300, fontSize: 14), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdownLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: denizMavisi)),
    );
  }

  // YENI: Mahalle secimi icin tiklanabilir, kompakt kutu (dropdown yerine)
  Widget _buildMahalleSeciciKutusu({required String? value, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.location_city_rounded, color: acikMavi, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                value ?? 'Seçiniz',
                style: GoogleFonts.poppins(
                  color: value != null ? denizMavisi : Colors.grey.shade400,
                  fontSize: 14,
                  fontWeight: value != null ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({required String? value, required List<String> items, required String hint, required Function(String?) onChanged, bool isEnabled = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isEnabled ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isEnabled ? Colors.grey.shade200 : Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 14)),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: isEnabled ? Colors.grey.shade400 : Colors.grey.shade300),
          style: GoogleFonts.poppins(color: denizMavisi, fontSize: 14, fontWeight: FontWeight.w500),
          items: isEnabled ? items.map((String val) => DropdownMenuItem<String>(value: val, child: Text(val))).toList() : [],
          onChanged: isEnabled ? onChanged : null,
        ),
      ),
    );
  }
}