import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../main.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final Color primaryDark = const Color(0xFF102841);
  bool _isLoading = false;
  bool _isOtpSent = false;
  String _verificationId = '';

  Future<void> _sendOtp() async {
    if (_phoneController.text.trim().length < 10) {
      _showError('Lütfen geçerli bir telefon numarası girin.');
      return;
    }

    setState(() => _isLoading = true);
    String phoneNumber = '+90${_phoneController.text.trim()}';

    try {
      // 1. BU NUMARA VERİTABANINDA KAYITLI MI KONTROLÜ
      var userCheck = await FirebaseFirestore.instance.collection('users').where('phoneNumber', isEqualTo: phoneNumber).get();
      if (userCheck.docs.isEmpty) {
        setState(() => _isLoading = false);
        _showError('Kayıtlı bir hesap bulunamadı. Lütfen önce kayıt olun.');
        return;
      }

      // 2. KAYITLIYSA SMS GÖNDER
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async => await _signInWithCredential(credential),
        verificationFailed: (FirebaseAuthException e) {
          setState(() => _isLoading = false);
          _showError('Doğrulama başarısız: ${e.message}');
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
      _showError('Bir hata oluştu: $e');
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
      await _signInWithCredential(credential);
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Kod hatalı veya süresi dolmuş.');
    }
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const PremiumDashboardScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Giriş yapılamadı: $e');
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
              Center(child: Image.asset('assets/images/logo.png', height: 100)),
              const SizedBox(height: 40),
              Text('Giriş Yap', style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: primaryDark)),
              const SizedBox(height: 8),
              Text('Devam etmek için telefon numaranızı doğrulayın.', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade600)),
              const SizedBox(height: 40),

              _buildTextField(
                controller: _phoneController, label: 'Telefon Numarası (5XX XXX XX XX)', icon: Icons.phone_android_outlined, keyboardType: TextInputType.phone, enabled: !_isOtpSent,
              ),
              const SizedBox(height: 20),

              if (_isOtpSent)
                _buildTextField(controller: _otpController, label: '6 Haneli SMS Kodu', icon: Icons.message_outlined, keyboardType: TextInputType.number),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : (_isOtpSent ? _verifyOtp : _sendOtp),
                  style: ElevatedButton.styleFrom(backgroundColor: primaryDark, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(_isOtpSent ? 'Giriş Yap' : 'SMS Kodu Gönder', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Hesabınız yok mu?', style: GoogleFonts.inter(color: Colors.grey.shade600)),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
                    child: Text('Kayıt Ol', style: GoogleFonts.inter(color: primaryDark, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, required TextInputType keyboardType, bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: primaryDark)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(color: enabled ? const Color(0xFFF7F9FC) : Colors.grey.shade200, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
          child: TextField(
            controller: controller, keyboardType: keyboardType, enabled: enabled,
            decoration: InputDecoration(prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 22), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), hintText: label),
          ),
        ),
      ],
    );
  }
}