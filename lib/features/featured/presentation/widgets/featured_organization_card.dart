import 'package:cached_network_image/cached_network_image.dart'; // Eklendi
import 'package:flutter/material.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:karaburun/core/helpers/string_helpers.dart';
import 'package:karaburun/features/organization/data/models/organization_model.dart';
import 'package:karaburun/features/village/data/models/village_model.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:karaburun/core/helpers/map_launcher.dart'; 

class FeaturedOrganizationCard extends StatelessWidget {
  final OrganizationModel item; 
  final List<Village> villages;
  final VoidCallback? onTap;

  const FeaturedOrganizationCard({
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
    final String fullUrl = "${ApiRoutes.fileUrl}$imageUrl"; // URL dışarı alındı
    final String? fontFamily = Theme.of(context).textTheme.bodyLarge?.fontFamily;
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final int targetCacheHeight = (500 * pixelRatio).round();

    String villageName = "Karaburun";
    if (villages.isNotEmpty) {
      final match = villages.where((v) => v.id == item.villageId);
      if (match.isNotEmpty) {
        villageName = match.first.name;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        height: 500, 
        margin: const EdgeInsets.only(right: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // --- CACHELENMİŞ ARKA PLAN RESMİ ---
              Positioned.fill(
                child: (imageUrl.isNotEmpty)
                    ? CachedNetworkImage(
                        imageUrl: fullUrl,
                        fit: BoxFit.cover,
                        memCacheHeight: targetCacheHeight,
                        placeholder: (context, url) => Container(
                          color: AppColors.cardBg,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/images/no_img.png",
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset("assets/images/no_img.png", fit: BoxFit.cover),
              ),

              // --- 🔥 SAĞ ÜST KÖŞEDEKİ KÖY ETİKETİ (STİLİ KORUNDU) ---
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6), 
                    borderRadius: BorderRadius.circular(20),   
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        villageName.capitalizeAll(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          fontFamily: fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- İÇERİK KATMANI ---
              Column(
                children: [
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), 
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75), 
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center, // Butonlar ve metinleri dikeyde ortaladık
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🔥 HİZALAMA DÜZELTİLDİ: Köy adı yukarı uçtuğu için buradaki gereksiz iç Row/Column sarmalları temizlendi
                              Text(
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
                              const SizedBox(height: 4),
                              
                              Text(
                                item.address.capitalize(), 
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: fontFamily,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              if (item.phone.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  item.phone.formatPhoneNumber(),
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.95),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: fontFamily,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        // BUTONLAR GRUBU (STİLLERİ VE PADDINGLERİ BİREBİR AYNI)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => MapLauncher.openMap(context, item.latitude, item.longitude),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Symbols.near_me_rounded,
                                  color: AppColors.iconOrange,
                                  size: 18,
                                  weight: 600,
                                  fill: 1,
                                ),
                              ),
                            ),

                            if (item.phone.isNotEmpty) 
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: GestureDetector(
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
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}