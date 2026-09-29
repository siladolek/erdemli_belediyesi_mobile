import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart'; // Bu import yolunu klasörüne göre gerekirse düzelt

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      // background yerine senin paletindeki "bgLight" atandı
      scaffoldBackgroundColor: AppColors.bgLight,
      textTheme: GoogleFonts.montserratTextTheme().apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        // primary yerine senin paletindeki "seaBlue" (Deniz Mavisi) atandı
        backgroundColor: AppColors.seaBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // Butonların ana rengi de seaBlue (Deniz Mavisi) yapıldı
          backgroundColor: AppColors.seaBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}