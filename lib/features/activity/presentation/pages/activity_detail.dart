import 'package:flutter/material.dart';
import 'package:karaburun/core/helpers/date.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import '../../data/models/activity_model.dart';

class ActivityDetailPage extends StatelessWidget {
  final Activity activity;
  final String baseUrl = "http://10.0.2.2:3000";

  const ActivityDetailPage({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final coverUrl =
        activity.cover != null ? "$baseUrl${activity.cover!['url']}" : null;

    final timeline = activity.content?.timeline ?? [];

    final nearPlaces = [
      {"name": "Mavi Kafe", "distance": "350m", "icon": Icons.local_cafe},
      {"name": "Sahil Restoran", "distance": "500m", "icon": Icons.restaurant},
      {"name": "Karaburun Camping", "distance": "900m", "icon": Icons.park},
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            if (coverUrl != null)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(coverUrl, fit: BoxFit.cover),
              ),

            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              color: AppColors.bgDark.withOpacity(0.45),
            ),

            SafeArea(
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            DraggableScrollableSheet(
              initialChildSize: 0.65,
              minChildSize: 0.65,
              maxChildSize: 1,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        height: 4,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          activity.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      const TabBar(
                        labelColor: AppColors.primary,
                        indicatorColor: AppColors.primary,
                        unselectedLabelColor: AppColors.textMuted,
                        tabs: [
                          Tab(text: "Etkinlik Takvimi"),
                          Tab(text: "Mekanlar"),
                          Tab(text: "Galeri"),
                        ],
                      ),

                      Expanded(
                        child: TabBarView(
                          children: [
                            buildTimelineTab(timeline, scrollController),

                            ListView(
                              controller: scrollController,
                              padding: const EdgeInsets.all(16),
                              children: nearPlaces.map((place) {
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardBg,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: AppColors.divider),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(place["icon"] as IconData,
                                          color: AppColors.primary),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          place["name"].toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textMain,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        place["distance"].toString(),
                                        style: const TextStyle(
                                            color: AppColors.textMuted),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),

                            const Center(
                              child: Text(
                                "Galeri yakında 👀",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textMuted),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildTimelineTab(
      List timeline, ScrollController controller) {
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
                .map<Widget>(
                  (day) => Tab(
                    child: Text(
                      DateHelper.formatToDayMonthYear(day.date),
                      style:
                          const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                )
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              children: timeline
                  .map<Widget>(
                    (day) => buildDayTab(day.events, controller),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildDayTab(
      List<Event> events, ScrollController controller) {
    return ListView(
      controller: controller,
      padding: const EdgeInsets.all(16),
      children: events.map((item) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16)
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
      }).toList(),
    );
  }
}
