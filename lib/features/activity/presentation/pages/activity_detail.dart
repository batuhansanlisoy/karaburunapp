import 'package:flutter/material.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:karaburun/core/widgets/gallery_grid.dart';
import 'package:karaburun/core/widgets/timeline_tab.dart';
import 'package:karaburun/core/widgets/distance_card_list.dart';
import 'package:karaburun/features/beach/data/models/beach_model.dart';
import 'package:karaburun/features/beach/data/repositories/beach_repository.dart';
import 'package:karaburun/features/place/data/models/place_model.dart';
import 'package:karaburun/features/place/data/repositories/place_repository.dart';
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
  final BeachRepository _beachRepo = BeachRepository();
  final PlaceRepository _placeRepo = PlaceRepository();

  List<ActivityBeachDistanceModel> _nearBeaches = [];
  List<ActivityPlaceDistanceModel> _nearPlaces = [];
  List<Beach> _beachList = [];
  List<Place> _placeList = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  void _loadAllData() async {
    final results = await Future.wait([
      _fetchNearestBeaches(),
      _fetchNearestPlaces(),
      _fetchBeaches(),
      _fetchPlaces()
    ]);

    setState(() {
      _nearBeaches = results[0] as List<ActivityBeachDistanceModel>;
      _nearPlaces  = results[1] as List<ActivityPlaceDistanceModel>;
      _beachList   = results[2] as List<Beach>;
      _placeList   = results[3] as List<Place>;
      //loading 
      _isLoading = false;
    });
  }

  Future<List<ActivityBeachDistanceModel>> _fetchNearestBeaches() async {
      return await _beachDistanceRepo.fetchActivity(activityId: widget.activity.id);
  }

  Future<List<ActivityPlaceDistanceModel>> _fetchNearestPlaces() async {
    return await _placeRepository.fetchNearestPlace(activityId: widget.activity.id);
  }

  Future<List<Beach>> _fetchBeaches() async {
    return await _beachRepo.fetchBeachs();
  }

  Future<List<Place>> _fetchPlaces() async {
    return await _placeRepo.fetchPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final String baseUrl = ApiRoutes.baseUrl;

    final coverUrl = widget.activity.cover != null
        ? "$baseUrl${widget.activity.cover!['url']}"
        : null;

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
                        child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : TabBarView(
                          children: [
                            TimelineTab(timeline: timeline, controller: scrollController),

                            DistanceCardList(
                              items: _nearBeaches,
                              controller: scrollController,
                              icon: Icons.beach_access_rounded,
                              iconColor: AppColors.iconGreen,
                              emptyMessage: "Yakınlarda koy bulunamadı",
                              getName: (item) => _beachList.firstWhere((b) => b.id == item.beachId).name,
                              getDistance: (item) => item.distanceMeter,
                            ),

                            // TURİSTİK YERLER SEKİMESİ
                            DistanceCardList(
                              items: _nearPlaces,
                              controller: scrollController,
                              icon: Icons.explore_rounded,
                              iconColor: AppColors.iconSoftOrange,
                              emptyMessage: "Yakınlarda turistik yer bulunamadı",
                              getName: (item) => _placeList.firstWhere((p) => p.id == item.placeId).name,
                              getDistance: (item) => item.distanceMeter,
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

