import 'package:flutter/material.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:karaburun/features/beach/data/models/beach_model.dart';
import 'package:karaburun/features/village/data/models/village_model.dart';
import 'package:karaburun/core/helpers/string_helpers.dart'; // capitalizeAll burada
import 'package:material_symbols_icons/symbols.dart';
import 'package:karaburun/core/helpers/map_launcher.dart'; // Map helper'ın

class BeachGrid extends StatelessWidget {
  final List<Beach> beaches;
  final List<Village> villages;
  final bool isLoading;

  const BeachGrid({
    super.key,
    required this.beaches,
    required this.villages,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      );
    }

    if (beaches.isEmpty) return const SizedBox.shrink();

    double screenWidth = MediaQuery.of(context).size.width;
    double gridHeight = 600; 

    return SizedBox(
      height: gridHeight, 
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero, 
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: (gridHeight / 2) / (screenWidth * 0.85), 
        ),
        itemCount: beaches.length,
        itemBuilder: (context, index) {
          final beach = beaches[index];
          
          final String? coverPath = beach.cover != null ? beach.cover!['url'] : null;
          final String imageUrl = (coverPath != null && coverPath.isNotEmpty)
            ? "${ApiRoutes.fileUrl}$coverPath"
            : "assets/images/no_img.png";

          String vName = "Karaburun";
          if (villages.isNotEmpty) {
            final match = villages.where((v) => v.id == beach.villageId);
            if (match.isNotEmpty) vName = match.first.name;
          }

          return _BeachCard(
            beach: beach, // Modeli komple yolluyoruz
            imageUrl: imageUrl, 
            beachName: beach.name, 
            villageName: vName,
            address: beach.address,
          );
        },
      ),
    );
  }
}

class _BeachCard extends StatelessWidget {
  final Beach beach; // Koordinatlar için lazım
  final String imageUrl;
  final String beachName;
  final String villageName;
  final String? address;

  const _BeachCard({
    required this.beach,
    required this.imageUrl, 
    required this.beachName, 
    required this.villageName,
    this.address,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAsset = imageUrl.startsWith('assets/');
    final String? fontFamily = Theme.of(context).textTheme.bodyLarge?.fontFamily;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.cardBg,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // 1. KATMAN: GÖRSEL
            Positioned.fill(
              child: isAsset 
                ? Image.asset(imageUrl, fit: BoxFit.cover)
                : Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/no_img.png',
                      fit: BoxFit.cover,
                    ),
                  ),
            ),

            // 2. KATMAN: SİYAH BANT
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
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
                              Text(
                                beachName.capitalizeAll(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12.5,
                                  fontFamily: fontFamily,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                          const SizedBox(height: 4),
                          Text(
                            (address?.isNotEmpty ?? false) 
                                ? address!.capitalize()
                                : "Karaburun, İzmir",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.95),
                              fontSize: 10,
                              fontFamily: fontFamily,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // --- KONUM BUTONU (YUVARLAK İÇİNDE) ---
                    GestureDetector(
                      onTap: () => MapLauncher.openMap(context, beach.latitude, beach.longitude),
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
                          fill: 1,
                          weight: 600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}