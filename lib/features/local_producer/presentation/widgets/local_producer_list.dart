import 'package:flutter/material.dart';
import 'package:karaburun/core/widgets/app_card.dart';
import 'package:karaburun/features/village/data/models/village_model.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import '../../data/models/local_producer_model.dart';
import 'package:url_launcher/url_launcher.dart';

class LocalProducerList extends StatelessWidget {
  final List<LocalProducerModel> list;
  final Map<int, Village> villageMap;
  final Function(LocalProducerModel) onTap;

  const LocalProducerList({
    super.key,
    required this.list,
    required this.villageMap,
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
      padding: const EdgeInsets.all(0),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final item = list[i];
        final village = villageMap[item.villageId];

        return AppCard(
          title: item.name,
          explanation: item.extra?['explanation'],
          // address: item.address,
          products: item.extra?['products'],
          email: item.email,
          phone: item.phone,
          imageUrl: item.cover?['url'] != null
            ? "${ApiRoutes.fileUrl}${item.cover!['url']}"
            : null,
          villageName: village?.name,
          onTap: () => onTap(item),
          onCallTap: () => _makePhoneCall(item.phone),
        );
      },
    );
  }
}
