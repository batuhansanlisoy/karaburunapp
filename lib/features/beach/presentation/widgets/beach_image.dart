import 'package:flutter/material.dart';

class BeachImage extends StatelessWidget {
  final String? imageUrl;
  final String baseUrl;

  const BeachImage({
    super.key,
    required this.imageUrl,
    required this.baseUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return _placeholder();
    }

    return Image.network(
      "$baseUrl$imageUrl",
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.grey[300],
      child: const Icon(Icons.image, size: 80),
    );
  }
}
