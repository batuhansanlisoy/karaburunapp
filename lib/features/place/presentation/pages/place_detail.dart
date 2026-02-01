import 'package:flutter/material.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:karaburun/core/widgets/gallery_grid.dart';
import '../../data/models/place_model.dart';
import '../../data/models/place_activity_distance_model.dart';
import '../../data/repositories/place_activity_distance_repository.dart';
import '../../data/models/place_beach_distance_model.dart';
import '../../data/repositories/place_beach_distance_repository.dart';

class PlaceDetail extends StatefulWidget {
  final Place place;
  const PlaceDetail({super.key, required this.place});

  @override
  _PlaceDetailState createState() => _PlaceDetailState();
}

class _PlaceDetailState extends State<PlaceDetail> {
  final PlaceActivityDistanceRepository _activityDistanceRepo = PlaceActivityDistanceRepository();
  final PlaceBeachDistanceRepository _beachDistanceRepo = PlaceBeachDistanceRepository();  

  List<PlaceActivityDistanceModel> _nearActivities = [];
  List<PlaceBeachDistanceModel> _nearBeaches = [];

  bool _activityDistanceLoading = true;
  bool _beachDistanceLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNearestActivities();
    _fetchNearestBeaches();
  }

  void _fetchNearestActivities() async {
    try {
      final distances = await _activityDistanceRepo.fetchNearestActivities(placeId: widget.place.id);
      setState(() {
        _nearActivities = distances;
        _activityDistanceLoading = false;
      });
    } catch (e) {
      setState(() {
        _activityDistanceLoading = false;
      });
    }
  }

  void _fetchNearestBeaches() async {
    try {
      final distances = await _beachDistanceRepo.fetchNearestBeaches(placeId: widget.place.id);
      setState(() {
        _nearBeaches = distances;
        _beachDistanceLoading = false;
      });
    } catch (e) {
      setState(() {
        _beachDistanceLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final coverUrl = widget.place.cover != null
        ? "http://10.0.2.2:3000${widget.place.cover!['url']}"
        : null;

    final List<String> gallery = widget.place.gallery?.cast<String>() ?? [];

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
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
                          widget.place.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.center,
                        labelColor: AppColors.primary,
                        indicatorColor: AppColors.primary,
                        unselectedLabelColor: AppColors.textMuted,
                        tabs: [
                          Tab(text: "Etkinlik"),
                          Tab(text: "Koy"),
                          Tab(text: "Galeri"),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            buildActivityTab(_nearActivities, _activityDistanceLoading, scrollController),
                            buildBeachTab(_nearBeaches, _beachDistanceLoading, scrollController),
                            GalleryGrid(images: gallery, controller: scrollController),
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
}

Widget buildActivityTab(List<PlaceActivityDistanceModel> activities, bool loading, ScrollController controller) {
  if (loading) {
    return const Center(child: CircularProgressIndicator());
  }

  return ListView.builder(
    controller: controller,
    itemCount: activities.isEmpty ? 1 : activities.length,
    itemBuilder: (context, index) {
      if (activities.isEmpty) {
        return Container(
          height: 100,
          alignment: Alignment.center,
          child: const Text("Mekan bulunamadı"),
        );
      }

      final item = activities[index]; // İsim çakışması düzeltildi
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.cardBg,
        ),
        child: Row(
          children: [
            const Icon(Icons.celebration, color: AppColors.iconPurple),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "Activity ID: ${item.activityId}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMain,
                ),
              ),
            ),
            Text(
              "${item.distanceMeter.toStringAsFixed(0)} m",
              style: const TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    },
  );
}

Widget buildBeachTab(List<PlaceBeachDistanceModel> beaches, bool loading, ScrollController controller) {
  if (loading) {
    return const Center(child: CircularProgressIndicator());
  }

  return ListView.builder(
    controller: controller,
    itemCount: beaches.isEmpty ? 1 : beaches.length,
    itemBuilder: (context, index) {
      if (beaches.isEmpty) {
        return Container(
          height: 100,
          alignment: Alignment.center,
          child: const Text("Mekan bulunamadı"),
        );
      }

      final item = beaches[index];
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.cardBg,
        ),
        child: Row(
          children: [
            const Icon(Icons.celebration, color: AppColors.iconPurple),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "Beach ID: ${item.beachId}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMain,
                ),
              ),
            ),
            Text(
              "${item.distanceMeter.toStringAsFixed(0)} m",
              style: const TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    },
  );
}
