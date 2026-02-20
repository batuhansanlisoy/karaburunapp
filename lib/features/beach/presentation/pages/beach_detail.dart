import 'package:flutter/material.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:karaburun/core/widgets/gallery_grid.dart';
import '../../data/models/beach_model.dart';

import '../../data/models/beach_activity_distance_model.dart';
import '../../data/repositories/beach_activity_distance_repository.dart';

import '../../data/models/beach_place_distance_model.dart';
import '../../data/repositories/beach_place_distance_repository.dart';

class BeachDetail extends StatefulWidget {
  final Beach beach;
  const BeachDetail({super.key, required this.beach});

  @override
  _BeachDetailState createState() => _BeachDetailState();
}

class _BeachDetailState extends State<BeachDetail> {
  final BeachActivityDistanceRepository _activityDistanceRepo = BeachActivityDistanceRepository();
  final BeachPlaceDistanceRepository _placeDistanceRepo = BeachPlaceDistanceRepository();  

  List<BeachActivityDistanceModel> _nearActivities = [];
  List<BeachPlaceDistanceModel> _nearPlaces = [];

  bool _activityDistanceLoading = true;
  bool _placeDistanceLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNearestActivities();
    _fetchNearestPlaces();
  }

  void _fetchNearestActivities() async {
    try {
      final distances = await _activityDistanceRepo.fetchNearestActivities(beachId: widget.beach.id);
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

  void _fetchNearestPlaces() async {
    try {
      final distances = await _placeDistanceRepo.fetchNearestPlaces(beachId: widget.beach.id);
      setState(() {
        _nearPlaces = distances;
        _placeDistanceLoading = false;
      });
    } catch (e) {
      setState(() {
        _placeDistanceLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String baseUrl = ApiRoutes.baseUrl;

    final coverUrl = widget.beach.cover != null
        ? "$baseUrl${widget.beach.cover!['url']}"
        : null;

    final List<String> gallery = widget.beach.gallery?.map((path) {
      return "$baseUrl$path";
    }).toList() ?? [];

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
                          widget.beach.name,
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
                          Tab(text: "Turistik"),
                          Tab(text: "Galeri"),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            buildActivityTab(_nearActivities, _activityDistanceLoading, scrollController),
                            buildPlaceTab(_nearPlaces, _placeDistanceLoading, scrollController),
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

Widget buildActivityTab(List<BeachActivityDistanceModel> activities, bool loading, ScrollController controller) {
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

Widget buildPlaceTab(List<BeachPlaceDistanceModel> places, bool loading, ScrollController controller) {
  if (loading) {
    return const Center(child: CircularProgressIndicator());
  }

  return ListView.builder(
    controller: controller,
    itemCount: places.isEmpty ? 1 : places.length,
    itemBuilder: (context, index) {
      if (places.isEmpty) {
        return Container(
          height: 100,
          alignment: Alignment.center,
          child: const Text("Mekan bulunamadı"),
        );
      }

      final item = places[index];
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
                "Place ID: ${item.placeId}",
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
