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
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none, // Butonun dışarı taşmasına izin verir
        children: [
          // 1. Reklam Görseli
          GestureDetector(
            onTap: onTap, // Reklama tıklayınca bir yere gitsin
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 2. Kapatma Butonu (IconButton)
          Positioned(
            top: -10,
            right: -10,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(), // Dialog'u kapatır
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cancel,
                  color: Color.fromARGB(255, 73, 73, 73),
                  size: 35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}