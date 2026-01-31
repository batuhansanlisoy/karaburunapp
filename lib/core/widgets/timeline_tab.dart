import 'package:flutter/material.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:karaburun/core/helpers/date.dart';

class TimelineTab extends StatelessWidget {
  final List<dynamic> timeline;
  final ScrollController? controller;

  const TimelineTab({super.key, required this.timeline, this.controller});

  @override
  Widget build(BuildContext context) {
    if (timeline.isEmpty) {
      return const Center(
        child: Text(
          "Takvim boş",
          style: TextStyle(color: AppColors.textMuted),
        ),
      );
    }

    return DefaultTabController(
      length: timeline.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            indicator: const BoxDecoration(),
            dividerHeight: 0,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            tabs: timeline
                .map<Widget>((day) => Tab(
                      child: Text(
                        DateHelper.formatToDayMonthYear(day.date),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ))
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              children: timeline
                  .map<Widget>((day) => _buildDayTab(day.events, controller))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayTab(List events, ScrollController? controller) {
    final isEmpty = events.isEmpty;

    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.all(16),
      itemCount: isEmpty ? 1 : events.length,
      itemBuilder: (context, index) {
        if (isEmpty) {
          return Container(
            height: 100,
            alignment: Alignment.center,
            child: const Text(
              "Takvim boş",
              style: TextStyle(color: AppColors.textMuted),
            ),
          );
        }

        final item = events[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item.time,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMain,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
