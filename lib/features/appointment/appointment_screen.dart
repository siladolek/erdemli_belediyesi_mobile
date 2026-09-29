import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  // Gerçekçi Belediye Birimleri
  final List<String> _departments = [
    'Başkanlık (Özel Kalem)',
    'İmar ve Şehircilik Müdürlüğü',
    'Ruhsat ve Denetim Müdürlüğü',
    'Sosyal Yardım İşleri Müdürlüğü',
    'Evlendirme Memurluğu',
    'Zabıta Müdürlüğü',
  ];

  String? _selectedDepartment;
  DateTime? _selectedDate;
  final TextEditingController _reasonController = TextEditingController();

  // Renk Paleti
  final Color denizMavisi = const Color(0xFF154360);
  final Color acikMavi = const Color(0xFF2980B9);
  final Color arkaPlan = const Color(0xFFF8F9FA);

  // Tarih Seçici Fonksiyonu
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)), // Geçmişe ve bugüne randevu alınamaz
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: denizMavisi,
              onPrimary: Colors.white,
              onSurface: denizMavisi,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: arkaPlan,
      appBar: AppBar(
        backgroundColor: arkaPlan,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: denizMavisi),
        title: Text(
          'Randevu Talebi',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: denizMavisi),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. BİLGİLENDİRME KARTI (Gerçekçi İşleyişi Anlatır)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: acikMavi.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: acikMavi.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, color: acikMavi, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Süreç Nasıl İşler?',
                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: denizMavisi),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'İlgili müdürlüğe ilettiğiniz talebiniz incelendikten sonra, uygun gün ve saat bilgisi sistemde kayıtlı cep telefonunuza SMS olarak bildirilecektir.',
                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade700, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 2. BİRİM SEÇİMİ
            Text('Görüşmek İstediğiniz Birim', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: denizMavisi)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text('Birim Seçiniz', style: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 14)),
                  value: _selectedDepartment,
                  icon: Icon(Icons.keyboard_arrow_down_rounded, color: denizMavisi),
                  items: _departments.map((String dept) {
                    return DropdownMenuItem<String>(
                      value: dept,
                      child: Text(dept, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade800)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDepartment = newValue;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 3. TARİH SEÇİMİ
            Text('Talep Edilen Tarih', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: denizMavisi)),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'Tarih Seçiniz'
                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: _selectedDate == null ? Colors.grey.shade400 : Colors.grey.shade800,
                        fontWeight: _selectedDate == null ? FontWeight.normal : FontWeight.w600,
                      ),
                    ),
                    Icon(Icons.calendar_month_rounded, color: acikMavi),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 4. TALEP NEDENİ
            Text('Talep Nedeni / Açıklama', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: denizMavisi)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: TextField(
                controller: _reasonController,
                maxLines: 4,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade800),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Görüşme konunuzu kısaca özetleyiniz...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.shield_rounded, size: 14, color: Colors.green.shade600),
                const SizedBox(width: 6),
                Text(
                  'Kimlik ve iletişim bilgileriniz sistemden otomatik alınacaktır.',
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // 5. GÖNDER BUTONU
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedDepartment == null || _selectedDate == null || _reasonController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Lütfen tüm alanları doldurunuz.', style: GoogleFonts.poppins()),
                        backgroundColor: Colors.red.shade400,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }

                  // Başarılı Gönderim Simülasyonu
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Randevu talebiniz başarıyla iletildi.', style: GoogleFonts.poppins()),
                      backgroundColor: Colors.green.shade600,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pop(context); // İşlem bitince ana ekrana dön
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: denizMavisi,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  shadowColor: denizMavisi.withOpacity(0.4),
                ),
                child: Text('TALEBİ GÖNDER', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}