import 'package:flutter/material.dart';
import '../../data/models/beach_model.dart';
import 'beach_image.dart';
import 'beach_info.dart';
import 'beach_explanation.dart';

class BeachCard extends StatelessWidget {
  final Beach beach;
  final String baseUrl;

  const BeachCard({
    super.key,
    required this.beach,
    required this.baseUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BeachImage(
            imageUrl: beach.logoUrl,
            baseUrl: baseUrl,
          ),
          BeachInfo(beach: beach),
          BeachExplanation(text: beach.extra?['explanation']),
        ],
      ),
    );
  }
}
