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
  final String? email;
  final String? phone;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? titleFontSize;
  final Color? contentBgColor;
  final VoidCallback? onTap;
  final VoidCallback? onNavigationTap;
  final VoidCallback? onCallTap;
  final String? categoryName;
  final String? villageName;
  final DateTime? begin;
  final DateTime? end;
  final List<dynamic>? products;

  const AppCard({
    super.key,
    required this.title,
    this.explanation,
    this.address,
    this.imageUrl,
    this.email,
    this.phone,
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
    this.onCallTap,
    this.products,
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
        border: Border.all(color: Colors.black.withValues(alpha: 0.08), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 20),
        child: Column(
          children: [
            // --- ÜST KISIM ---
            InkWell(
              onTap: widget.onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageStack(),
                  Padding(
                    padding: widget.padding ?? const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderRow(),

                        // Ürünler (Yatay Kaydırılabilir)
                        if (widget.products != null && widget.products!.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 24,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.products!.length,
                              separatorBuilder: (context, index) => const SizedBox(width: 6),
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.iconGreen.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.iconGreen.withValues(alpha: 0.3),
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.products![index].toString().capitalize(),
                                      style: const TextStyle(
                                        color: AppColors.iconGreen,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],

                        // Telefon
                        if (widget.phone != null && widget.phone!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _buildSimpleText(widget.phone!.formatPhoneNumber(), 12, FontWeight.w500, icon: Symbols.call_rounded),
                        ],

                        // Email
                        if (widget.email != null && widget.email!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          _buildSimpleText(widget.email!.toLowerCase(), 12, FontWeight.w500, icon: Symbols.mail_rounded),
                        ],
                        
                        // Adres
                        if (widget.address != null && widget.address!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          _buildSimpleText(widget.address!.capitalize(), 12, FontWeight.w500, icon: Symbols.location_on_rounded),
                        ],

                        // Tarih (Etkinlikler için)
                        if (widget.begin != null && widget.end != null) ...[
                          const SizedBox(height: 10),
                          _buildSimpleText(
                            "${DateHelper.formatDateTime(widget.begin!)} - ${DateHelper.formatDateTime(widget.end!)}",
                            11,
                            FontWeight.w700,
                            icon: Symbols.calendar_month_rounded,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- ALT KISIM (Açıklama Alanı) ---
            if (widget.explanation != null)
              Column(
                children: [
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
                              color: AppColors.textMain.withValues(alpha:  0.8),
                              height: 1.4
                            ),
                          )
                        : const SizedBox.shrink(),
                    ),
                  ),
                  
                  GestureDetector(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Symbols.keyboard_arrow_down_rounded,
                          color: AppColors.textMain.withValues(alpha:  0.3),
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

  Widget _buildHeaderRow() {
    return Text(
      widget.title.capitalizeAll(),
      style: TextStyle(
        fontSize: widget.titleFontSize ?? 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textMain,
        height: 1.1,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSimpleText(String text, double size, FontWeight weight, {IconData? icon}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 14,
            fill: 1,
            weight: 600,
            color: AppColors.textMain.withValues(alpha: 0.4)
            ),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: size,
              color: AppColors.textMain.withValues(alpha: 1),
              fontWeight: weight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildImageStack() {
    return Stack(
      children: [
        widget.imageUrl != null
            ? Image.network(
                widget.imageUrl!,
                width: double.infinity,
                height: 280,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _placeholder(),
              )
            : _placeholder(),
        
        if (widget.categoryName != null)
          Positioned(top: 12, left: 12, child: _badge(widget.categoryName!.capitalizeAll(), AppColors.iconOrange)),
        
        if (widget.villageName != null)
          Positioned(top: 12, right: 12, child: _badge(widget.villageName!.capitalizeAll(), Colors.black.withValues(alpha: 0.6), isVillage: true)),

        // --- Aksiyon Butonları (Sağ Alt) ---
        Positioned(
          bottom: 12,
          right: 12,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ARİMA BUTONU (YEŞİL)
              if (widget.onCallTap != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: widget.onCallTap,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Symbols.call_rounded,
                          color: AppColors.iconGreen, // Senin temandaki yeşil
                          size: 20,
                          fill: 1,
                        ),
                      ),
                    ),
                  ),
                ),

              // NAVİGASYON BUTONU (TURUNCU)
              if (widget.onNavigationTap != null)
                GestureDetector(
                  onTap: widget.onNavigationTap,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Symbols.near_me_rounded,
                        color: AppColors.iconOrange,
                        size: 20,
                        fill: 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _badge(String text, Color color, {bool isVillage = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color, 
        borderRadius: BorderRadius.circular(30), 
        border: isVillage ? Border.all(color: Colors.white.withValues(alpha: 0.2)) : null
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity, 
      height: 280, // Placeholder boyutu da resimle eşitlendi
      color: const Color(0xFFF1F5F9), 
      child: Icon(Symbols.image, size: 40, color: Colors.blueGrey.shade200)
    );
  }
}