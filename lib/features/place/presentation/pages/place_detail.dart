import 'package:flutter/material.dart';
import 'package:karaburun/core/helpers/map_launcher.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:karaburun/core/widgets/distance_card_list.dart';
import 'package:karaburun/core/widgets/gallery_grid.dart';
import 'package:karaburun/features/activity/data/models/activity_model.dart';
import 'package:karaburun/features/activity/data/repositories/activity_repository.dart';
import 'package:karaburun/features/beach/data/models/beach_model.dart';
import 'package:karaburun/features/beach/data/repositories/beach_repository.dart';
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
  final ActivityRepository _activityRepo = ActivityRepository();
  final BeachRepository _beachRepo = BeachRepository();

  List<PlaceActivityDistanceModel> _nearActivities = [];
  List<PlaceBeachDistanceModel> _nearBeaches = [];
  List<Activity> _activityList = [];
  List<Beach> _beachList = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  void _loadAllData() async {
    final results = await Future.wait([
      _fetchNearestActivities(),
      _fetchNearestBeaches(),
      _fetchActivities(),
      _fetchBeaches()
    ]);

    setState(() {
      _nearActivities = results[0] as List<PlaceActivityDistanceModel>;
      _nearBeaches    = results[1] as List<PlaceBeachDistanceModel>;
      _activityList   = results[2] as List<Activity>;
      _beachList      = results[3] as List<Beach>;

      //loading
      _isLoading = false;
    });
  }

  Future<List<PlaceActivityDistanceModel>> _fetchNearestActivities() async {
    return await _activityDistanceRepo.fetchNearestActivities(placeId: widget.place.id);
  }

  Future<List<PlaceBeachDistanceModel>> _fetchNearestBeaches() async {
    return await _beachDistanceRepo.fetchNearestBeaches(placeId: widget.place.id);  
  }

  Future<List<Activity>> _fetchActivities() async {
    return await _activityRepo.fetchActivity();
  }

  Future<List<Beach>> _fetchBeaches() async {
    return await _beachRepo.fetchBeachs();
  }

  @override
  Widget build(BuildContext context) {
    final String fileUrl = ApiRoutes.fileUrl;

    final coverUrl = widget.place.cover != null
        ? "$fileUrl${widget.place.cover!['url']}"
        : null;

    final List<String> gallery = widget.place.gallery?.map((path) {
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
                        child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : TabBarView(
                          children: [
                             DistanceCardList(
                              items: _nearActivities,
                              controller: scrollController,
                              icon: Icons.celebration,
                              iconColor: AppColors.iconPurple,
                              emptyMessage: "Yakınlarda etkinlik bulunamadı",
                              getName: (item) => _activityList.firstWhere((b) => b.id == item.activityId).name,
                              getDistance: (item) => item.distanceMeter,
                              onRouteTap: (item) {
                                final target = _activityList.firstWhere((b) => b.id == item.activityId);
                                MapLauncher.openMap(target.latitude ?? 0.0, target.longitude ?? 0.0);
                              },
                            ),
                            DistanceCardList(
                              items: _nearBeaches,
                              controller: scrollController,
                              icon: Icons.beach_access_rounded,
                              iconColor: AppColors.iconGreen,
                              emptyMessage: "Yakınlarda koy bulunamadı",
                              getName: (item) => _beachList.firstWhere((b) => b.id == item.beachId).name,
                              getDistance: (item) => item.distanceMeter,
                              onRouteTap: (item) {
                                final target = _beachList.firstWhere((b) => b.id == item.beachId);
                                MapLauncher.openMap(target.latitude ?? 0.0, target.longitude ?? 0.0);
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
