import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../main.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final Color primaryDark = const Color(0xFF102841);
  bool _isLoading = false;
  bool _isOtpSent = false;
  String _verificationId = '';

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: primaryDark, onPrimary: Colors.white, onSurface: Colors.black),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('dd.MM.yyyy').format(picked);
      });
    }
  }

  Future<void> _sendOtp() async {
    if (_nameController.text.trim().isEmpty || _surnameController.text.trim().isEmpty || _dobController.text.trim().isEmpty) {
      _showError('Lütfen ad, soyad ve doğum tarihi alanlarını doldurun.');
      return;
    }
    if (_phoneController.text.trim().length < 10) {
      _showError('Lütfen geçerli bir telefon numarası girin.');
      return;
    }

    setState(() => _isLoading = true);
    String phoneNumber = '+90${_phoneController.text.trim()}';

    try {
      // 1. BU NUMARA ZATEN KAYITLI MI KONTROLÜ
      var userCheck = await FirebaseFirestore.instance.collection('users').where('phoneNumber', isEqualTo: phoneNumber).get();
      if (userCheck.docs.isNotEmpty) {
        setState(() => _isLoading = false);
        _showError('Bu telefon numarası zaten kayıtlı. Lütfen giriş yapın.');
        return;
      }

      // 2. DEĞİLSE SMS GÖNDER
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async => await _registerWithCredential(credential),
        verificationFailed: (FirebaseAuthException e) {
          setState(() => _isLoading = false);
          _showError('Doğrulama başarısız oldu: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _isOtpSent = true;
            _isLoading = false;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) => _verificationId = verificationId,
      );
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Bağlantı hatası: $e');
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.trim().length < 6) {
      _showError('Lütfen 6 haneli kodu girin.');
      return;
    }
    setState(() => _isLoading = true);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text.trim(),
      );
      await _registerWithCredential(credential);
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Kod hatalı veya süresi dolmuş.');
    }
  }

  Future<void> _registerWithCredential(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // FIRESTORE'A PROFİLİ KAYDET
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'phoneNumber': user.phoneNumber,
          'name': _nameController.text.trim(),
          'surname': _surnameController.text.trim(),
          'birthDate': _dobController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const PremiumDashboardScreen()),
                (route) => false,
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Kayıt tamamlanamadı: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.redAccent));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new_rounded, color: primaryDark), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kayıt Ol', style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: primaryDark)),
              const SizedBox(height: 8),
              Text('Erdemli Belediyesi dijital hizmetlerine erişmek için kayıt olun.', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade600)),
              const SizedBox(height: 30),

              if (!_isOtpSent) ...[
                _buildTextField(controller: _nameController, label: 'Adınız', icon: Icons.person_outline, capitalization: TextCapitalization.words),
                const SizedBox(height: 16),
                _buildTextField(controller: _surnameController, label: 'Soyadınız', icon: Icons.person_outline, capitalization: TextCapitalization.words),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _selectDate,
                  child: AbsorbPointer(
                    child: _buildTextField(controller: _dobController, label: 'Doğum Tarihiniz', icon: Icons.calendar_today_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField(controller: _phoneController, label: 'Telefon (5XX XXX XX XX)', icon: Icons.phone_android_outlined, keyboardType: TextInputType.phone),
              ] else ...[
                _buildTextField(controller: _otpController, label: '6 Haneli SMS Kodu', icon: Icons.message_outlined, keyboardType: TextInputType.number),
              ],

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : (_isOtpSent ? _verifyOtp : _sendOtp),
                  style: ElevatedButton.styleFrom(backgroundColor: primaryDark, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(_isOtpSent ? 'Kodu Doğrula ve Kayıt Ol' : 'SMS Kodu Gönder', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, TextInputType keyboardType = TextInputType.text, TextCapitalization capitalization = TextCapitalization.none}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: primaryDark)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(color: const Color(0xFFF7F9FC), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
          child: TextField(
            controller: controller, keyboardType: keyboardType, textCapitalization: capitalization,
            decoration: InputDecoration(prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 22), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), hintText: label),
          ),
        ),
      ],
    );
  }
}