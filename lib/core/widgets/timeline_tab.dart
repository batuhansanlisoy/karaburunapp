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
      return ListView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Center(
              child: Text(
                "Takvim boş",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
              ),
            ),
          ),
        ],
      );
    }

    return DefaultTabController(
      length: timeline.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            indicator: const BoxDecoration(),
            tabAlignment: TabAlignment.center,
            labelColor: AppColors.textDark,
            dividerHeight: 0,
            unselectedLabelColor: AppColors.textMuted,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
            tabs: timeline
              .map<Widget>((day) => Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Symbols.event_rounded,
                          fill: 1, 
                          size: 14
                        ),
                        const SizedBox(width: 6),
                        Text(DateHelper.formatToDayMonthYear(day.date)),
                      ],
                    ),
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
      itemCount: events.length,
      itemBuilder: (context, index) {
        final item = events[index];
        
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Symbols.schedule_rounded,
                  color: AppColors.iconBlue,
                  size: 22,
                  weight: 500,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.time,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlue,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMain,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Symbols.chevron_right_rounded,
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