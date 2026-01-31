import 'package:flutter/material.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:karaburun/core/widgets/full_screen_gallery.dart';

class GalleryGrid extends StatelessWidget {
  final List<String> images;
  final ScrollController? controller;

  const GalleryGrid({
    super.key,
    required this.images,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const Center(
        child: Text(
          "Galeri boş",
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textMuted,
          ),
        ),
      );
    }

    return GridView.builder(
      controller: controller,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final imageUrl = images[index].startsWith("http")
            ? images[index]
            : "http://10.0.2.2:3000${images[index]}";

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FullScreenGallery(
                  images: images
                      .map((e) => e.startsWith("http") ? e : "http://10.0.2.2:3000$e")
                      .toList(),
                  initialIndex: index,
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppColors.cardBg,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.cardBg,
                  child: const Icon(Icons.broken_image, color: AppColors.textMuted),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
