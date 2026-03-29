import 'package:flutter/material.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:karaburun/core/helpers/string_helpers.dart';
import 'package:karaburun/features/organization/data/models/organization_model.dart';
import 'package:karaburun/features/village/data/models/village_model.dart'; // Import eklendi
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:karaburun/core/helpers/map_launcher.dart'; 

class FeaturedOrganizationCard extends StatelessWidget {
  final OrganizationModel item; 
  final List<Village> villages; // Villages listesi eklendi
  final VoidCallback? onTap;

  const FeaturedOrganizationCard({
    super.key,
    required this.item,
    required this.villages, // Gerekli kılındı
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

    // --- KÖY İSMİNİ BULMA MANTIĞI ---
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
                color: Colors.black.withOpacity(0.75), 
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                              "• ${villageName.capitalizeAll()}", // Bulduğumuz ismi buraya bastık
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500,
                                fontFamily: fontFamily,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        
                        Text(
                          item.address.capitalize(), 
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
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
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              fontFamily: fontFamily,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (item.latitude != null && item.longitude != null) {
                             MapLauncher.openMap(item.latitude!, item.longitude!);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  "İşletme koordinatları sistemde bulunamadı.",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                                backgroundColor: Colors.redAccent.withOpacity(0.9),
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.all(20),
                                duration: const Duration(seconds: 2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
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
                                color: Colors.white.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
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
      ),
    );
  }
}