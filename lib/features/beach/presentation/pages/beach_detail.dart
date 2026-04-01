import 'package:flutter/material.dart';
import 'package:karaburun/core/helpers/string_helpers.dart';
import 'package:karaburun/core/helpers/map_launcher.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:karaburun/core/widgets/distance_card_list.dart';
import 'package:karaburun/core/widgets/gallery_grid.dart';
import 'package:karaburun/features/activity/data/models/activity_model.dart';
import 'package:karaburun/features/activity/data/repositories/activity_repository.dart';
import 'package:karaburun/features/place/data/models/place_model.dart';
import 'package:karaburun/features/place/data/repositories/place_repository.dart';
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
  final ActivityRepository _activityRepo = ActivityRepository();
  final PlaceRepository _placeRepo = PlaceRepository();

  List<BeachActivityDistanceModel> _nearActivities = [];
  List<BeachPlaceDistanceModel> _nearPlaces = [];
  List<Activity> _activityList = [];
  List<Place> _placeList = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  void _loadAllData() async {
    final results = await Future.wait([
      _fetchNearestActivities(),
      _fetchNearestPlaces(),
      _fetchActivities(),
      _fetchPlaces()
    ]);

    setState(() {
      _nearActivities = results[0] as List<BeachActivityDistanceModel>;
      _nearPlaces = results[1] as List<BeachPlaceDistanceModel>;
      _activityList = results[2] as List<Activity>;
      _placeList = results[3] as List<Place>;

      // loading
      _isLoading = false;
    });
  }

  Future<List<BeachActivityDistanceModel>> _fetchNearestActivities() async {
    return await _activityDistanceRepo.fetchNearestActivities(beachId: widget.beach.id);
  }

  Future<List<BeachPlaceDistanceModel>> _fetchNearestPlaces() async {
    return await _placeDistanceRepo.fetchNearestPlaces(beachId: widget.beach.id);
  }

  Future<List<Activity>> _fetchActivities() async {
    return await _activityRepo.fetchActivity();
  }

  Future<List<Place>> _fetchPlaces() async {
    return await _placeRepo.fetchPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final String fileUrl = ApiRoutes.fileUrl;

    final coverUrl = widget.beach.cover != null
        ? "$fileUrl${widget.beach.cover!['url']}"
        : null;

    final List<String> gallery = widget.beach.gallery?.map((path) {
      return "$fileUrl$path";
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
              color: AppColors.bgDark.withValues(alpha: 0.45),
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
                          widget.beach.name.capitalizeAll(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.center,
                        labelColor: AppColors.textOrange,
                        indicatorColor: AppColors.textOrange,
                        unselectedLabelColor: AppColors.textMain,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500
                        ),
                        tabs: [
                          Tab(text: "Etkinlik"),
                          Tab(text: "Turistik"),
                          Tab(text: "Galeri"),
                        ],
                      ),
                      Expanded(
                        child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : TabBarView(
                            children: [
                              DistanceCardList(
                                items: _nearActivities,
                                controller: scrollController,
                                emptyMessage: "Yakınlarda etkinlik bulunamadı",
                                getName: (item) => _activityList.firstWhere((b) => b.id == item.activityId).name,
                                getDistance: (item) => item.distanceMeter,
                                getCoverUrl: (item) {
                                  final activity = _activityList.firstWhere((p) => p.id == item.activityId);
                                  if (activity.cover != null && activity.cover!['url'] != null) {
                                    return "${ApiRoutes.fileUrl}${activity.cover!['url']}";
                                  }
                                  return null;
                                },
                                onRouteTap: (item) {
                                  final target = _activityList.firstWhere((b) => b.id == item.activityId);
                                  MapLauncher.openMap(context, target.latitude, target.longitude);
                                },
                              ),
                              DistanceCardList(
                                items: _nearPlaces,
                                controller: scrollController,
                                emptyMessage: "Yakınlarda turistik yer bulunamadı",
                                getName: (item) => _placeList.firstWhere((p) => p.id == item.placeId).name,
                                getDistance: (item) => item.distanceMeter,
                                getCoverUrl: (item) {
                                  final place = _placeList.firstWhere((p) => p.id == item.placeId);
                                  if (place.cover != null && place.cover!['url'] != null) {
                                    return "${ApiRoutes.fileUrl}${place.cover!['url']}";
                                  }
                                  return null;
                                },
                                onRouteTap: (item) {
                                  final target = _placeList.firstWhere((b) => b.id == item.placeId);
                                  MapLauncher.openMap(context, target.latitude, target.longitude);
                                },
                              ),
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