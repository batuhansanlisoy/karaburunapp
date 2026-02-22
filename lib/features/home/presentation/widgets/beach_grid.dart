import 'package:flutter/material.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/features/beach/data/models/beach_model.dart';
import 'package:karaburun/features/village/data/models/village_model.dart';
import 'package:karaburun/utils/string_helpers.dart';

class BeachGrid extends StatelessWidget {
  final List<Beach> beaches;
  final List<Village> villages;
  final bool isLoading;
  final VoidCallback onSeeAllTap;

  const BeachGrid({
    super.key,
    required this.beaches,
    required this.villages,
    required this.isLoading,
    required this.onSeeAllTap,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Başlık - Bunu 20 birim içerden başlatıyoruz ki metinler hizalı olsun
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildSectionTitle("Popüler Koylar", onSeeAllTap: onSeeAllTap),
        ),
        const SizedBox(height: 16),
        
        SizedBox(
          height: 380, 
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            // SOL PADDING'I 4 YAPTIK: Ekranın en solundan başlar
            padding: const EdgeInsets.only(left: 4, right: 20), 
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              // ORAN GÜNCELLENDİ: Kartın ekranı kaplaması için genişliği artırdık
              childAspectRatio: (380 / 2) / (screenWidth * 0.9), 
            ),
            itemCount: beaches.length,
            itemBuilder: (context, index) {
              final beach = beaches[index];
              
              final String? coverPath = beach.cover != null ? beach.cover!['url'] : null;
              final String imageUrl = coverPath != null ? "${ApiRoutes.baseUrl}$coverPath" : "";

              String vName = "Karaburun";
              if (villages.isNotEmpty) {
                final match = villages.where((v) => v.id == beach.villageId);
                if (match.isNotEmpty) vName = match.first.name;
              }

              return _BeachCard(
                imageUrl: imageUrl, 
                beachName: beach.name, 
                villageName: vName
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, {VoidCallback? onSeeAllTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title, 
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)
        ),
        if (onSeeAllTap != null)
          GestureDetector(
            onTap: onSeeAllTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Tümünü Gör",
                style: TextStyle(
                  fontSize: 12, 
                  color: Colors.orange, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _BeachCard extends StatelessWidget {
  final String imageUrl;
  final String beachName;
  final String villageName;

  const _BeachCard({
    required this.imageUrl, 
    required this.beachName, 
    required this.villageName
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: imageUrl.isNotEmpty 
          ? DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            )
          : null,
        color: Colors.grey[200],
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.8),
            ],
            stops: const [0.5, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              beachName.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white70, size: 10),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    villageName,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}