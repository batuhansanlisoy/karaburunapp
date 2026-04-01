import 'package:flutter/material.dart';
import 'package:karaburun/utils/string_helpers.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:karaburun/core/helpers/distance_helpers.dart';
// 🌟 FullScreenGallery'yi import etmeyi unutma
import 'package:karaburun/core/widgets/full_screen_gallery.dart'; 
import '../theme/app_colors.dart';

class DistanceCardList extends StatelessWidget {
  final List<dynamic> items;
  final String Function(dynamic) getName;
  final double Function(dynamic) getDistance;
  final String? Function(dynamic) getCoverUrl;
  final ScrollController controller;
  final String emptyMessage;
  final void Function(dynamic)? onRouteTap;

  const DistanceCardList({
    super.key,
    required this.items,
    required this.getName,
    required this.getDistance,
    required this.getCoverUrl,
    required this.controller,
    this.onRouteTap,
    this.emptyMessage = "Sonuç bulunamadı",
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Text(
            emptyMessage,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final String name = getName(item);
        final double distance = getDistance(item);
        final String? fullImageUrl = getCoverUrl(item);

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (fullImageUrl != null && fullImageUrl.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenGallery(
                          images: [fullImageUrl],
                          initialIndex: 0,
                        ),
                      ),
                    );
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: AppColors.divider.withOpacity(0.2),
                    child: (fullImageUrl != null && fullImageUrl.isNotEmpty)
                        ? Image.network(
                            fullImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => _buildNoImage(),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(strokeWidth: 1.5),
                              );
                            },
                          )
                        : _buildNoImage(),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // METİN ALANI
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.capitalizeAll(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "${distance.formatDistance()} uzaklıkta",
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // NAVİGASYON BUTONU
              if (onRouteTap != null)
                GestureDetector(
                  onTap: () => onRouteTap!(item),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.06), 
                      shape: BoxShape.circle
                    ),
                    child: const Center(
                      child: Icon(
                        Symbols.near_me_rounded,
                        color: AppColors.iconOrange, 
                        size: 18, 
                        fill: 1
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoImage() {
    return Image.asset(
      'assets/images/no_img.png',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          alignment: Alignment.center,
          color: Colors.grey.withOpacity(0.1),
          child: const Icon(Icons.image_not_supported, size: 20, color: Colors.grey),
        );
      },
    );
  }
}