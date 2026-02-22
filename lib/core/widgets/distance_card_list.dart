import 'package:flutter/material.dart';
import 'package:karaburun/core/helpers/distance_helpers.dart';
import '../theme/app_colors.dart';

class DistanceCardList extends StatelessWidget {
  final List<dynamic> items; // Gelen mesafe modelleri listesi
  final String Function(dynamic) getName; // ID'den isim bulma mantığı
  final double Function(dynamic) getDistance; // Mesafe çekme mantığı
  final ScrollController controller;
  final IconData icon;
  final Color iconColor;
  final String emptyMessage;
  final VoidCallback? onRouteTap; // Yol tarifi tıklandığında

  const DistanceCardList({
    super.key,
    required this.items,
    required this.getName,
    required this.getDistance,
    required this.controller,
    required this.icon,
    this.iconColor = Colors.blue,
    this.emptyMessage = "Sonuç bulunamadı",
    this.onRouteTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Text(emptyMessage, style: const TextStyle(color: Colors.grey)),
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

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              // Sol İkon Alanı
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              // Orta Metin Alanı
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.near_me, size: 14, color: AppColors.iconOrange),
                        const SizedBox(width: 4),
                        Text(
                          "${distance.formatDistance()} uzaklıkta",
                          style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Sağ "Yol Tarifi" Butonu
              InkWell(
                onTap: onRouteTap,
                child: const Column(
                  children: [
                    Icon(Icons.directions_rounded, color: AppColors.primary, size: 28),
                    SizedBox(height: 4),
                    Text(
                      "Yol Tarifi",
                      style: TextStyle(
                        fontSize: 10, 
                        color: AppColors.primary, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}