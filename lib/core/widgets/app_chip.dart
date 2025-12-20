import 'package:flutter/material.dart';
// bu sayfaların üstünde yuvarlak köy kategorileri gösterek için kullanılıyor
// seçili olanın rengini falanda belli ediyor.
class AppChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const AppChip({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.only(right: 12, top: 10),
        decoration: BoxDecoration(
          color: isSelected
            ? const Color.fromARGB(255, 216, 66, 66)
            : const Color.fromARGB(255, 56, 101, 160),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(title, style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600
          )),
        ),
      ),
    );
  }
}