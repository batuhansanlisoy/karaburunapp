import 'package:flutter/material.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:karaburun/features/village/data/models/village_model.dart';
import 'package:go_router/go_router.dart';
import 'package:karaburun/utils/string_helpers.dart';
import 'package:material_symbols_icons/symbols.dart';

class VillageGrid extends StatefulWidget {
  final List<Village> villages;

  const VillageGrid({
    super.key,
    required this.villages,
  });

  @override
  State<VillageGrid> createState() => _VillageGridState();
}

class _VillageGridState extends State<VillageGrid> {
  bool isExpanded = false;
  final int initialCount = 8; // İlk başta kaç tane görünsün

  @override
  Widget build(BuildContext context) {
    if (widget.villages.isEmpty) return const SizedBox.shrink();

    // Gösterilecek liste: Genişletilmişse hepsi, değilse sadece ilk 8 tanesi
    final displayedVillages = isExpanded 
        ? widget.villages 
        : widget.villages.take(initialCount).toList();

    // Matematiksel hesap: 
    // Ekran genişliği - (Dış padding: 2+2) - (Elemanlar arası boşluk: 8*3) = 28
    final double itemWidth = (MediaQuery.of(context).size.width - 28) / 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- BAŞLIK SATIRI (Geniş Padding: 12) ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Yerleşkeler",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMain,
                    ),
              ),
              // Eğer köy sayısı 8'den fazlaysa çentik butonunu göster
              if (widget.villages.length > initialCount)
                GestureDetector(
                  onTap: () => setState(() => isExpanded = !isExpanded),
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    turns: isExpanded ? 0.5 : 0, // Aşağı/Yukarı ok animasyonu
                    child: Icon(
                      Symbols.keyboard_arrow_down_rounded,
                      color: AppColors.textOrange,
                      size: 24,
                    ),
                  ),
                ),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        
        // --- KÖY KUTUCUKLARI (Dar Padding: 2) ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Wrap(
            spacing: 8, // Kutular arası yatay boşluk
            runSpacing: 10, // Satırlar arası dikey boşluk
            children: displayedVillages.map((village) {
              return GestureDetector(
                onTap: () => context.go('/organization?villageId=${village.id}'),
                child: Container(
                  width: itemWidth,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 59, 59, 58).withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    village.name.capitalize(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}