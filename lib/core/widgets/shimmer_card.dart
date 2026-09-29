import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Yükleme durumunda gösterilen shimmer efektli kart.
///
/// [height] ve [width] ile boyutlandırılabilir.
/// [borderRadius] ile köşe yuvarlaklığı ayarlanabilir.
class ShimmerCard extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const ShimmerCard({
    super.key,
    this.height = 200,
    this.width,
    this.borderRadius = 20,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin ?? const EdgeInsets.only(right: 16, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[50]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst kısım — resim alanı
            Container(
              height: height * 0.55,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(borderRadius),
                ),
              ),
            ),
            // Alt kısım — metin alanı
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(height: 10, width: 80, color: Colors.white),
                    const SizedBox(height: 12),
                    Container(
                      height: 14,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(height: 14, width: 150, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Yatay haber listesi için shimmer oluşturur.
  static Widget horizontalList({
    int count = 3,
    double height = 230,
    double width = 260,
  }) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: count,
        itemBuilder: (context, index) => ShimmerCard(
          height: height,
          width: width,
        ),
      ),
    );
  }

  /// Dikey liste için shimmer oluşturur.
  static Widget verticalList({
    int count = 5,
    double height = 120,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: count,
      itemBuilder: (context, index) => ShimmerCard(
        height: height,
        margin: const EdgeInsets.only(bottom: 16),
      ),
    );
  }
}
