import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class AppLaunchPopup extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const AppLaunchPopup({
    super.key,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // URL kontrolü: http ile başlıyorsa internetten, başlamıyorsa asset'ten çeker
    final bool isNetwork = imageUrl.startsWith('http');

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // 1. Görsel Alanı (Afiş / Duyuru / Reklam)
          GestureDetector(
            onTap: onTap,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: isNetwork
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      // Yükleme sırasında hata olursa (internet yoksa vs.) siyah ekran yerine ikon gösterir
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF1E293B),
                        child: const Icon(Symbols.broken_image_rounded, color: Colors.white, size: 40),
                      ),
                    )
                  : Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
            ),
          ),

          // 2. Kapatma Butonu
          Positioned(
            top: 60, // Çentik (notch) payı bırakıldı
            right: 20,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context, rootNavigator: true).pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3), 
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Symbols.close,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}