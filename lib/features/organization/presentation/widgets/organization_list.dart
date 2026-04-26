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
  final Function(OrganizationModel) onTap;

  const OrganizationList({
    super.key,
    required this.list,
    required this.categoryItems,
    required this.villageMap,
    required this.categoryMap,
    required this.onTap
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
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final item = list[i];
        final village = villageMap[item.villageId];
        final category = categoryMap[item.categoryId];
        final List<String> matchedProductNames = [];
        
        if (item.subCategories != null) {
          for (var sub in item.subCategories!) {
            final categoryItem = categoryItems.firstWhere(
              (element) => element.id == sub.itemId
            );
            
            if (categoryItem.name.isNotEmpty) {
              matchedProductNames.add(categoryItem.name);
            }
          }
        }

        return GestureDetector(
          onTap: () => onTap(item),
          child: 
            AppCard(
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
              onCallTap: () => _makePhoneCall(item.phone),
              onNavigationTap: () => MapLauncher.openMap(context, item.latitude, item.longitude)
            )
        );
      },
    );
  }
}