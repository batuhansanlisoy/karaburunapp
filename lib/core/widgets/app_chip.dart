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
              ? Colors.deepOrange[600]
              : Colors.blueGrey.shade900,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.deepOrange.shade400
                : Colors.green.shade900,
            width: 2,
          ),
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