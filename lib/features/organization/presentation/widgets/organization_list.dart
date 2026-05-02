import 'package:flutter/material.dart';
import 'package:karaburun/core/widgets/app_card.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/features/organization/data/models/organization_category_item_model.dart';
import 'package:karaburun/features/organization/data/models/organization_category_model.dart';
import 'package:karaburun/features/village/data/models/village_model.dart';
import '../../data/models/organization_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:karaburun/core/helpers/map_launcher.dart';

class OrganizationList extends StatelessWidget {
  final List<OrganizationModel> list;
  final List<OrganizationCategoryItemModel> categoryItems;
  final Map<int, Village> villageMap;
  final Map<int, OrganizationCategoryModel> categoryMap;
  final Set<int> favoriteIds;
  final Function(OrganizationModel) onTap;
  final Function(int id) onFavoriteToggle;

  const OrganizationList({
    super.key,
    required this.list,
    required this.categoryItems,
    required this.villageMap,
    required this.categoryMap,
    required this.favoriteIds,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, i) {
        final item = list[i];
        final village = villageMap[item.villageId];
        final category = categoryMap[item.categoryId];
        
        // Ürün eşleştirme mantığı (Daha temiz bir döngü ile)
        final List<String> matchedProductNames = [];
        if (item.subCategories != null) {
          for (var sub in item.subCategories!) {
            final categoryItem = categoryItems.firstWhere(
              (element) => element.id == sub.itemId,
              orElse: () => OrganizationCategoryItemModel(
                id: 0,
                name: '',
                organizationCategoryId: 0,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            );
            if (categoryItem.name.isNotEmpty) {
              matchedProductNames.add(categoryItem.name);
            }
          }
        }

        final bool isCurrentlySaved = favoriteIds.contains(item.id);

        return AppCard(
          title: item.name,
          address: item.address,
          email: item.email,
          phone: item.phone,
          imageUrl: item.cover?['url'] != null
              ? "${ApiRoutes.fileUrl}${item.cover!['url']}"
              : null,
          products: matchedProductNames,
          villageName: village?.name,
          categoryName: category?.name,
          onTap: () => onTap(item),
          onCallTap: () => _makePhoneCall(item.phone),
          onNavigationTap: () => MapLauncher.openMap(context, item.latitude, item.longitude),
          isSaved: isCurrentlySaved,
          onSaveTap: () => onFavoriteToggle(item.id),
        );
      },
    );
  }
}