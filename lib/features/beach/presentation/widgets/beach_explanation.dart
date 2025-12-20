import 'package:flutter/material.dart';

class BeachExplanation extends StatelessWidget {
  final String? text;

  const BeachExplanation({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    if (text == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text!,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
