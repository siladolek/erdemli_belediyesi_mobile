import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Yeniden kullanılabilir "Veri Bulunamadı" widget'ı.
///
/// Herhangi bir sayfada veri yokken gösterilir.
/// Tema renklerine uygun ikon + mesaj + opsiyonel buton.
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.message,
    required this.icon,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // İkon — turkuaz/açık gri daire içinde
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.turquoise.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: AppColors.turquoise.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),

            // Mesaj
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),

            // Opsiyonel buton
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: onButtonPressed,
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: AppColors.turquoise,
                  size: 18,
                ),
                label: Text(
                  buttonText!,
                  style: GoogleFonts.inter(
                    color: AppColors.turquoise,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
