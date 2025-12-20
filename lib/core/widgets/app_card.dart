import 'package:flutter/material.dart';

class AppCard extends StatelessWidget{
  final String title;
  final String? subtitle;
  final String? address;
  final String? imageUrl;
  final double? borderRadius;
  final double? elevation;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? titleFontSize;
  final double? subTitleFontSize;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.title,
    this.subtitle,
    this.address,
    this.imageUrl,
    this.borderRadius,
    this.elevation,
    this.margin,
    this.padding,
    this.titleFontSize,
    this.subTitleFontSize,
    this.onTap
  }); 

  @override
  Widget build(BuildContext content) {
    Widget cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        imageUrl != null
          ? Image.network(
              imageUrl!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _placeholder()
            )
          : _placeholder(),
      Padding(
        padding: padding ?? const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title, style: TextStyle(fontSize: titleFontSize ?? 20, fontWeight: FontWeight.bold),
            ),
            if (address != null) ...[
              const SizedBox(height: 4),
              Text("Adres: $address", style: const TextStyle(fontSize: 14))
            ]
          ],
        ),
      )
      ],
    );

    if (onTap != null) {
      cardContent = InkWell(
        onTap: onTap,
        child: cardContent,
      );
    }

    return Card(
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 16)
      ),
      clipBehavior: Clip.antiAlias,
      elevation: elevation ?? 4,
      child: cardContent,
    );
  }
// resim yüklenemezse veya data olarak yoksa bunu gösteriyoruz.
  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.grey[300],
      child: const Icon(Icons.image, size: 80)
    );
  }
}