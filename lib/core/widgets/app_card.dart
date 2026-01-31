import 'package:flutter/material.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:karaburun/core/helpers/date.dart';
import 'package:karaburun/core/helpers/string_helpers.dart';

class AppCard extends StatelessWidget {
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
  final Color? contentBgColor;
  final VoidCallback? onTap;
  final String? categoryName;
  final String? villageName;
  final DateTime? begin;
  final DateTime? end;

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
    this.contentBgColor,
    this.categoryName,
    this.villageName,
    this.begin,
    this.end,
    this.onTap,
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
                errorBuilder: (context, error, stackTrace) =>
                    _placeholder(),
              )
            : _placeholder(),
        Container(
          width: double.infinity,
          color: contentBgColor ?? Colors.white,
          padding: padding ?? const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.capitalizeAll(),
                style: TextStyle(
                  fontSize: titleFontSize ?? 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  if (categoryName != null)
                    _chip(categoryName!.capitalizeAll()),
                  if (villageName != null)
                    _chip(villageName!.capitalizeAll()),
                ],
              ),
              if (address != null) ...[
                const SizedBox(height: 8),
                Text(
                  "📍 $address",
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textMuted),
                ),
              ],
              if (begin != null && end != null) ...[
                const SizedBox(height: 6),
                Text(
                  "🗓 ${DateHelper.formatDateTime(begin!)} - ${DateHelper.formatDateTime(end!)}",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400 ,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ],
          ),
        ),
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
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: elevation ?? 4,
      child: cardContent,
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

Widget _chip(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.orange.shade100,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textMain
      ),
    ),
  );
}
