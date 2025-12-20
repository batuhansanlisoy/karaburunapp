import 'package:flutter/material.dart';
import '../../data/models/beach_model.dart';

class BeachInfo extends StatelessWidget {
  final Beach beach;

  const BeachInfo({
    super.key,
    required this.beach,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white.withOpacity(0.95),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  beach.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Adres: ${beach.address}",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.location_on,
            size: 32,
            color: Color.fromARGB(255, 107, 107, 107),
          ),
        ],
      ),
    );
  }
}
