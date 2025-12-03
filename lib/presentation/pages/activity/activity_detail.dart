import 'package:flutter/material.dart';
import 'package:karaburun/core/helpers/date.dart';
import '../../../data/activity/model.dart';

class ActivityDetailPage extends StatelessWidget {
  final Activity activity;
  final String baseUrl = "http://10.0.2.2:3000";

  const ActivityDetailPage({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    // Kapak görseli
    final coverUrl = activity.cover != null ? "$baseUrl${activity.cover!['url']}" : null;

    // Timeline
    final timeline = activity.content?.timeline ?? [];

    // Yakındaki mekanlar (dummy)
    final nearPlaces = [
      {"name": "Mavi Kafe", "distance": "350m", "icon": Icons.local_cafe},
      {"name": "Sahil Restoran", "distance": "500m", "icon": Icons.restaurant},
      {"name": "Karaburun Camping", "distance": "900m", "icon": Icons.park},
    ];

    return DefaultTabController(
      length: timeline.length + 1, // +1 mekanlar
      child: Scaffold(
        body: Stack(
          children: [
            // Kapak + blur overlay
            if (coverUrl != null)
              SizedBox(
                height: 350,
                width: double.infinity,
                child: Image.network(
                  coverUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
                ),
              ),
            Container(height: 350, width: double.infinity, color: Colors.black.withOpacity(0.4)),

            // Üst içerik: geri butonu + başlık
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.name,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        if ((activity.content?.explanation ?? "").isNotEmpty)
                          Chip(
                            label: Text(activity.content!.explanation!),
                            backgroundColor: Colors.white70,
                          )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // İçerik Card
            Positioned(
              top: 300,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height - 20,
                padding: const EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                ),
                child: Column(
                  children: [
                    // Sekmeler
                    TabBar(
                      indicatorColor: Colors.red,
                      labelColor: Colors.red,
                      unselectedLabelColor: const Color.fromARGB(255, 129, 129, 129),
                      isScrollable: true,
                      tabs: [
                        ...timeline.map((day) => Tab(text: DateHelper.formatToDayMonthYear(day.date))
),
                        const Tab(text: "Mekanlar"),
                      ],
                    ),

                    // Sekme içeriği
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Gün bazlı timeline sekmeleri
                          ...timeline.map((day) => buildDayTab(day.events)),

                          // Yakındaki mekanlar (dummy)
                          ListView(
                            padding: const EdgeInsets.all(16),
                            children: nearPlaces.map((place) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    Icon(place["icon"] as IconData, size: 30, color: Colors.blueGrey),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        place["name"].toString(),
                                        style: const TextStyle(
                                            fontSize: 17, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Text(
                                      place["distance"].toString(),
                                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

Widget buildDayTab(List<Event> events) {
  return ListView(
    padding: const EdgeInsets.all(16),
    children: [
      // Günlük Program başlığı
      Padding(
        padding: const EdgeInsets.only(bottom: 8), // alt boşluk çok büyük olmasın
        child: Text(
          "Günlük Program",
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
      ),
      // Eventler
      ...events.map((item) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 231, 231, 231),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 0, 0),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  item.time,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 26, 26, 26)),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ],
  );
}


}
