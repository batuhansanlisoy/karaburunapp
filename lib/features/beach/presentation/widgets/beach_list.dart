import 'package:flutter/material.dart';
import '../../data/models/beach_model.dart';
import 'beach_card.dart';

class BeachList extends StatelessWidget {
  final List<Beach> list;
  final String baseUrl;

  const BeachList({
    super.key,
    required this.list,
    required this.baseUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      itemBuilder: (_, i) {
        return BeachCard(
          beach: list[i],
          baseUrl: baseUrl,
        );
      },
    );
  }
}
