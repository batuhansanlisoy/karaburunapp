import 'package:flutter/material.dart';

class CustomAdDialog extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const CustomAdDialog({
    super.key,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, // Arka planın şeffaf olması şart
      insetPadding: EdgeInsets.zero,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none, // Butonun dışarı taşmasına izin verir
        children: [
          // 1. Reklam Görseli
          GestureDetector(
            onTap: onTap, // Reklama tıklayınca bir yere gitsin
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 2. Kapatma Butonu (IconButton)
          Positioned(
            top: 50,    // Durum çubuğunun (saat, şarj vs.) altına denk gelmesi için
            right: 20,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context, rootNavigator: true).pop(),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7), // Biraz şeffaflık şık durur
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close, // 'cancel' yerine daha standart 'close'
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}