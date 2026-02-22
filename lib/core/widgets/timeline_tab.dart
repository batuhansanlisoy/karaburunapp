import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart'; // Paket importu
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:karaburun/core/helpers/date.dart';

class TimelineTab extends StatelessWidget {
  final List<dynamic> timeline;
  final ScrollController? controller;

  const TimelineTab({super.key, required this.timeline, this.controller});

  @override
  Widget build(BuildContext context) {
    if (timeline.isEmpty) {
      return Center(
        child: Text(
          "Takvim boş",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
        ),
      );
    }

    return DefaultTabController(
      length: timeline.length,
      child: Column(
        children: [
          // 🌟 Daha modern ve temiz TabBar
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            dividerHeight: 1,
            dividerColor: AppColors.divider.withOpacity(0.3),
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: timeline
                .map<Widget>((day) => Tab(
                      text: DateHelper.formatToDayMonthYear(day.date),
                    ))
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              children: timeline
                  .map<Widget>((day) => _buildDayTab(context, day.events, controller))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayTab(BuildContext context, List events, ScrollController? controller) {
    if (events.isEmpty) {
      return const Center(
        child: Text("Bu gün için etkinlik yok", style: TextStyle(color: AppColors.textMuted)),
      );
    }

    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final item = events[index];
        
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider.withOpacity(0.5)),
            // 🌟 Çok hafif bir gölge kartı canlandırır
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            children: [
              // 🌟 Sol Taraf: Saat İkonu Alanı (DistanceCard'daki ikon stili)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Symbols.schedule, // Material Symbols Saat
                  color: AppColors.primary,
                  size: 22,
                  weight: 500,
                ),
              ),
              const SizedBox(width: 16),
              
              // 🌟 Orta Taraf: Metin Alanı
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.time,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary.withOpacity(0.8),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMain,
                      ),
                    ),
                  ],
                ),
              ),
              
              // 🌟 Sağ Taraf: İleri butonu veya ok (Opsiyonel)
              const Icon(
                Symbols.chevron_right,
                color: AppColors.textMuted,
                size: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}