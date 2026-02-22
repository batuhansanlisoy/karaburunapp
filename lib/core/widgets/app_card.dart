import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart'; // 🌟 Paket importu
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
    this.contentBgColor,
    this.categoryName,
    this.villageName,
    this.begin,
    this.end,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Resim Alanı
        imageUrl != null
            ? Image.network(
                imageUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _placeholder(),
              )
            : _placeholder(),
        
        // İçerik Alanı
        Container(
          width: double.infinity,
          color: contentBgColor ?? Colors.white,
          padding: padding ?? const EdgeInsets.all(16), // Padding'i bir tık artırdık
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık
              Text(
                title.capitalizeAll(),
                style: TextStyle(
                  fontSize: titleFontSize ?? 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              
              // Chipler (Kategori ve Köy)
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  if (categoryName != null) _chip(categoryName!.capitalizeAll()),
                  if (villageName != null) _chip(villageName!.capitalizeAll()),
                ],
              ),
              
              // Adres Satırı
              if (address != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Symbols.location_on,
                      size: 18,
                      color: AppColors.iconSoftOrange,
                      weight: 400,
                      fill: 1,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        address!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              
              // Tarih Satırı
              if (begin != null && end != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Symbols.calendar_today,
                      size: 16,
                      color: AppColors.iconPurple,
                      weight: 400,
                      fill: 1,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${DateHelper.formatDateTime(begin!)} - ${DateHelper.formatDateTime(end!)}",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );

    return Card(
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: elevation ?? 2, // Çok gölge boğmasın diye 2 yaptık
      child: InkWell(
        onTap: onTap,
        child: cardContent,
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.grey[100],
      child: const Icon(
        Symbols.image,
        size: 48,
        color: Colors.grey,
        weight: 300,
        fill: 1,
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bgSoftOrange, // 🌟 Senin bgOrange
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.textOrange,
        ),
      ),
    );
  }
}