import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Sloganın ve logonun net görünmesi için 2 saniye ekranda tutuyoruz
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // 2 saniye sonra doğrudan ANA İSKELETE (PremiumDashboardScreen) geçiş yapıyoruz.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PremiumDashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // İŞTE BURASI BEMBEYAZ
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/images/logo.png',
              height: 130,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.waves_rounded, size: 100, color: Color(0xFF154360)),
            ),
            const SizedBox(height: 24),
            // Kurum Adı
            Text(
              'ERDEMLİ BELEDİYESİ',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF154360),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            // İstediğin Slogan
            Text(
              'Erdemli için, Erdemli\'yle.',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: const Color(0xFF2980B9),
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 40),
            // Şık bir yükleme çubuğu
            const CircularProgressIndicator(
              color: Color(0xFF2980B9),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}