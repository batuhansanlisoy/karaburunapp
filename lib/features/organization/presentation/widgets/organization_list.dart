import 'package:flutter/material.dart';
import 'package:karaburun/core/widgets/app_card.dart';
import '../../data/models/organization_model.dart';

class OrganizationList extends StatelessWidget {
  final List<OrganizationModel> list;
  final String baseUrl;
  // final Function(OrganizationModel) onTap;

  const OrganizationList({
    super.key,
    required this.list,
    required this.baseUrl,
    // required this.onTap
  });

 @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final item = list[i];
      
        return AppCard(
          title: item.name,
          address: item.address,
          imageUrl: item.cover != null ? "$baseUrl${item.cover!['url']}" : null,
          // onTap: () => onTap(item)
        );
      },
    );
  }
}
