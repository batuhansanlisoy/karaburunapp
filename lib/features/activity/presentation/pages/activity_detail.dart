import 'package:flutter/material.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:karaburun/core/widgets/gallery_grid.dart';
import 'package:karaburun/core/widgets/timeline_tab.dart';
import '../../data/models/activity_model.dart';
import '../../data/models/activity_beach_distance_model.dart';
import '../../data/repositories/activity_beach_distance_repository.dart';
import '../../data/models/activity_place_distance_model.dart';
import '../../data/repositories/activity_place_distance_repository.dart';

class ActivityDetailPage extends StatefulWidget {
  final Activity activity;
  const ActivityDetailPage({super.key, required this.activity});

  @override
  _ActivityDetailPageState createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  final ActivityBeachDistanceRepository _beachDistanceRepo = ActivityBeachDistanceRepository();
  final ActivityPlaceDistanceRepository _placeRepository= ActivityPlaceDistanceRepository();

  List<ActivityBeachDistanceModel> _nearBeaches = [];
  List<ActivityPlaceDistanceModel> _nearPlaces = [];
  bool _beachDistanceLoading = true;
  bool _placeDistanceLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNearestBeaches();
    _fetchNearestPlaces();
  }

  void _fetchNearestBeaches() async {
    try {
      final distances = await _beachDistanceRepo.fetchActivity(activityId: widget.activity.id);
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

  void _fetchNearestPlaces() async {
    try {
        final distance = await _placeRepository.fetchNearestPlace(activityId: widget.activity.id);
        setState(() {
          _nearPlaces = distance;
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

    final coverUrl = widget.activity.cover != null
        ? "$baseUrl${widget.activity.cover!['url']}"
        : null;

    // final List<String> gallery = widget.activity.gallery?.cast<String>() ?? [];

    final List<String> gallery = widget.activity.gallery?.map((path) {
      return "$baseUrl$path";
    }).toList() ?? [];

    final timeline = widget.activity.content?.timeline ?? [];

    return DefaultTabController(
      length: 4,
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
                          widget.activity.name,
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
                          Tab(text: "Etkinlik Takvimi"),
                          Tab(text: "Koylar"),
                          Tab(text: "Turistik"),
                          Tab(text: "Galeri"),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            TimelineTab(timeline: timeline, controller: scrollController),
                            buildBeachesTab(_nearBeaches, _beachDistanceLoading, scrollController),
                            buildPlacesTab(_nearPlaces, _placeDistanceLoading, scrollController),
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

Widget buildBeachesTab(List<ActivityBeachDistanceModel> beaches, bool loading, ScrollController controller) {
  if (loading) {
    return const Center(child: CircularProgressIndicator());
  }

  return ListView.builder(
    controller: controller,
    itemCount: beaches.isEmpty ? 1 : beaches.length,
    itemBuilder: (context, index) {
      if (beaches.isEmpty) {
        // Boş listede tek bir placeholder
        return Container(
          height: 100, // scroll için biraz yükseklik veriyoruz
          alignment: Alignment.center,
          child: const Text("Mekan bulunamadı"),
        );
      }

      final beach = beaches[index];
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.cardBg
        ),
        child: Row(
          children: [
            const Icon(Icons.beach_access, color: AppColors.iconGreen),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "Beach ID: ${beach.beachId}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMain,
                ),
              ),
            ),
            Text(
              "${beach.distanceMeter.toStringAsFixed(0)} m",
              style: const TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    },
  );
}


Widget buildPlacesTab(List<ActivityPlaceDistanceModel> places, bool loading, ScrollController controller) {
  if (loading) {
    return const Center(child: CircularProgressIndicator());
  }

  return ListView.builder(
    controller: controller,
    itemCount: places.isEmpty ? 1 : places.length, // boşsa tek bir placeholder
    itemBuilder: (context, index) {
      if (places.isEmpty) {
        return Container(
          height: 100, // scroll için yeterli yükseklik
          alignment: Alignment.center,
          child: const Text("Mekan bulunamadı"),
        );
      }

      final place = places[index];
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.cardBg,
        ),
        child: Row(
          children: [
            const Icon(Icons.travel_explore_rounded, color: AppColors.iconSoftOrange),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "Place ID: ${place.placeId}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMain,
                ),
              ),
            ),
            Text(
              "${place.distanceMeter.toStringAsFixed(0)} m",
              style: const TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    },
  );
}

