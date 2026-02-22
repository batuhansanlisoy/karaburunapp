import 'package:flutter/material.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:karaburun/core/helpers/string_helpers.dart';
import '../../data/models/featured_organization_model.dart';
import 'package:karaburun/core/navigation/api_routes.dart';

class FeaturedOrganizationCard extends StatelessWidget {
  final FeaturedOrganizationModel item;
  final VoidCallback? onTap;

  const FeaturedOrganizationCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final org = item.organization;
    final imageUrl = org.cover?['url'] ?? "";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        height: 250,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage("${ApiRoutes.baseUrl}$imageUrl"),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) => const Icon(Icons.broken_image),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ÜST KISIM: İSİM (Hafif boşluk bırakalım ki kenara yapışmasın) ---
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  org?.name ?? 'İsimsiz İşletme',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            const Spacer(),

            // --- ALT KISIM: DİBE YAPIŞIK BİLGİ BANDI ---
            Container(
              width: double.infinity, // Kartın genişliğine yayılır
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6), // Daha net okunurluk
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                          Symbols.distance,
                          color: AppColors.iconOrange,
                          size: 15,
                          weight: 600,
                          fill: 1,
                        ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          org?.address.capitalize() ?? "",
                          style: const TextStyle(color: Colors.white, fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (org?.phone != null && org!.phone.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Symbols.call,
                          color: AppColors.iconGreen,
                          size: 15,
                          weight: 800,
                          fill: 1,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          org.phone.formatPhoneNumber(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}