import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:karaburun/core/helpers/date.dart';
import 'package:karaburun/core/helpers/string_helpers.dart';

class AppCard extends StatefulWidget {
  final String title;
  final String? explanation;
  final String? address;
  final String? imageUrl;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? titleFontSize;
  final Color? contentBgColor;
  final VoidCallback? onTap;
  final VoidCallback? onNavigationTap;
  final String? categoryName;
  final String? villageName;
  final DateTime? begin;
  final DateTime? end;

  const AppCard({
    super.key,
    required this.title,
    this.explanation,
    this.address,
    this.imageUrl,
    this.borderRadius,
    this.margin,
    this.padding,
    this.titleFontSize,
    this.contentBgColor,
    this.categoryName,
    this.villageName,
    this.begin,
    this.end,
    this.onTap,
    this.onNavigationTap,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.only(bottom: 20, left: 4, right: 4),
      decoration: BoxDecoration(
        color: widget.contentBgColor ?? Colors.white,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 20),
        border: Border.all(color: Colors.black.withOpacity(0.08), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 20),
        child: Column(
          children: [
            // --- ÜST KISIM (Tıklayınca Detaya Gider) ---
            InkWell(
              onTap: widget.onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageStack(),
                  Padding(
                    padding: widget.padding ?? const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderRow(),
                        const SizedBox(height: 8),
                        if (widget.address != null)
                          _buildSimpleText(widget.address!.capitalize(), 12.5, FontWeight.w500),
                        if (widget.begin != null && widget.end != null) ...[
                          const SizedBox(height: 4),
                          _buildSimpleText(
                            "${DateHelper.formatDateTime(widget.begin!)} - ${DateHelper.formatDateTime(widget.end!)}",
                            11,
                            FontWeight.w700,
                            isDate: true,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- ALT KISIM (Açılır Kapanır Explanation & Ok Butonu) ---
            if (widget.explanation != null)
              Column(
                children: [
                  // Animasyonlu Açıklama Alanı
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.fastOutSlowIn,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12, 
                        vertical: _isExpanded ? 12 : 0
                      ),
                      child: _isExpanded 
                        ? Text(
                            widget.explanation!,
                            style: TextStyle(
                              fontSize: 13, 
                              color: AppColors.textMain.withOpacity(0.8),
                              height: 1.4
                            ),
                          )
                        : const SizedBox.shrink(),
                    ),
                  ),
                  
                  // TAM ORTADAKİ OK BUTONU
                  GestureDetector(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: double.infinity, // Geniş tıklama alanı
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Symbols.keyboard_arrow_down_rounded,
                          color: AppColors.textMain.withOpacity(0.3),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Helper metodlar
  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.title.capitalizeAll(),
            style: TextStyle(
              fontSize: widget.titleFontSize ?? 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textMain,
              height: 1.1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (widget.onNavigationTap != null)
          _buildNavButton(),
      ],
    );
  }

  Widget _buildNavButton() {
    return GestureDetector(
      onTap: widget.onNavigationTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.06), shape: BoxShape.circle),
        child: const Center(child: Icon(Symbols.near_me_rounded, color: AppColors.iconOrange, size: 16, fill: 1)),
      ),
    );
  }

  Widget _buildSimpleText(String text, double size, FontWeight weight, {bool isDate = false}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color:AppColors.textMain,
        fontWeight: weight,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildImageStack() {
    return Stack(
      children: [
        widget.imageUrl != null
            ? Image.network(
                widget.imageUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _placeholder(),
              )
            : _placeholder(),
        if (widget.categoryName != null)
          Positioned(top: 10, left: 10, child: _badge(widget.categoryName!.capitalizeAll(), AppColors.iconOrange)),
        if (widget.villageName != null)
          Positioned(top: 10, right: 10, child: _badge(widget.villageName!.capitalizeAll(), Colors.black.withOpacity(0.6), isVillage: true)),
      ],
    );
  }

  Widget _badge(String text, Color color, {bool isVillage = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(30), border: isVillage ? Border.all(color: Colors.white.withOpacity(0.2)) : null),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _placeholder() {
    return Container(width: double.infinity, height: 200, color: const Color(0xFFF1F5F9), child: Icon(Symbols.image, size: 40, color: Colors.blueGrey.shade200));
  }
}