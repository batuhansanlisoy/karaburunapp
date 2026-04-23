import 'package:flutter/material.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:karaburun/features/local_producer/data/models/local_producer_model.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:karaburun/core/helpers/string_helpers.dart';
import 'package:karaburun/features/village/data/models/village_model.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:url_launcher/url_launcher.dart';

class HighligtedLocalProducerCard extends StatelessWidget {
  final LocalProducerModel item; 
  final List<Village> villages;
  final VoidCallback? onTap;

  const HighligtedLocalProducerCard({
    super.key,
    required this.item,
    required this.villages,
    this.onTap,
  });

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.cover?['url'] ?? "";
    final String? fontFamily = Theme.of(context).textTheme.bodyLarge?.fontFamily;

    String villageName = "Karaburun";
    if (villages.isNotEmpty) {
      final match = villages.where((v) => v.id == item.villageId);
      if (match.isNotEmpty) {
        villageName = match.first.name;
      }
    }

    final List<dynamic> products = (item.extra != null && item.extra!['products'] != null)
        ? item.extra!['products'] as List<dynamic>
        : [];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        height: 280, 
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: (imageUrl.isNotEmpty)
                ? NetworkImage("${ApiRoutes.fileUrl}$imageUrl") as ImageProvider
                : const AssetImage("assets/images/no_img.png"),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) => const AssetImage("assets/images/no_img.png"),
          ),
        ),
        child: Column(
          children: [
            const Spacer(),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), 
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8), 
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Text(
                                    item.name.capitalizeAll(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12.5,
                                      fontFamily: fontFamily,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "• ${villageName.capitalizeAll()}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Telefon İkonu
                      if (item.phone.isNotEmpty) 
                        GestureDetector(
                          onTap: () => _makePhoneCall(item.phone),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Symbols.call_rounded,
                              color: AppColors.iconGreen,
                              size: 18,
                              weight: 800,
                              fill: 1,
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Yatay Kaydırılabilir Ürünler Listesi
                  if (products.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 22, // Sabit yükseklik verdik, overlay büyümesin
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 6),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.iconGreen.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: AppColors.iconGreen.withValues(alpha: 0.4),
                                width: 0.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                products[index].toString().capitalize(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: fontFamily,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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