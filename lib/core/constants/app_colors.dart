import 'package:flutter/material.dart';

/// Erdemli Belediyesi — "Deniz & Limon" Renk Paleti
///
/// Turkuaz tonları Akdeniz kıyısını, Limon Sarısı ise
/// Erdemli'nin meşhur narenciyesini temsil eder.
class AppColors {
  AppColors._();

  // ── Ana Renkler ──────────────────────────────────────────
  /// Koyu deniz mavisi — başlıklar, AppBar, BottomNav aktif
  static const Color seaBlue = Color(0xFF102841);

  /// Turkuaz — birincil vurgu, etiketler, linkler
  static const Color turquoise = Color(0xFF00BCD4);

  /// Açık turkuaz — kartlardaki hafif arka plan vurguları
  static const Color turquoiseLight = Color(0xFF4DD0E1);

  /// Limon sarısı — butonlar, önemli ikonlar, badge'ler
  static const Color lemonYellow = Color(0xFFFFC107);

  /// Koyu limon — kontrast gereken yerlerde
  static const Color lemonDark = Color(0xFFFFA000);

  // ── Arka Plan ────────────────────────────────────────────
  /// Saf beyaz
  static const Color bgWhite = Color(0xFFFFFFFF);

  /// Çok açık gri — scaffold arka planı
  static const Color bgLight = Color(0xFFF7F9FC);

  /// Kart arka planı
  static const Color cardBg = Color(0xFFFFFFFF);

  // ── Metin ────────────────────────────────────────────────
  /// Birincil metin rengi
  static const Color textPrimary = Color(0xFF102841);

  /// İkincil metin rengi (açıklamalar, alt yazılar)
  static const Color textSecondary = Color(0xFF78909C);

  /// Çok soluk metin (hint, placeholder)
  static const Color textHint = Color(0xFFB0BEC5);

  // ── Yardımcı ─────────────────────────────────────────────
  /// Gölge rengi
  static const Color shadow = Color(0x0A102841);

  /// Ayırıcı çizgi rengi
  static const Color divider = Color(0xFFE0E0E0);

  /// Hata kırmızısı
  static const Color error = Color(0xFFE53935);

  /// Başarı yeşili
  static const Color success = Color(0xFF43A047);

  // ── Takma Adlar (Aliases) ────────────────────────────────
  // Meclis sayfası ve diğer sayfalarda hata vermemesi için
  // genel isimler senin kurumsal renklerine yönlendirildi.
  static const Color primary = seaBlue;
  static const Color secondary = lemonYellow;
  static const Color background = bgLight;
}