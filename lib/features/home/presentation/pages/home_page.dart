import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:karaburun/features/activity/data/models/activity_category_model.dart';
import 'package:karaburun/features/activity/data/models/activity_model.dart';
import 'package:karaburun/features/beach/data/models/beach_model.dart';
import 'package:karaburun/features/beach/data/repositories/beach_repository.dart';
import 'package:karaburun/features/featured/data/models/featured_organization_model.dart';
import 'package:karaburun/features/home/presentation/widgets/beach_grid.dart';
import 'package:karaburun/features/village/data/models/village_model.dart';
import 'package:karaburun/features/activity/presentation/controllers/activity_controller.dart';
import 'package:karaburun/features/organization/data/repositories/organization_category_repository.dart';
import 'package:karaburun/features/featured/data/repositories/featured_organization_service.dart';
import 'package:karaburun/features/village/data/repositories/village_repository.dart';
import 'package:karaburun/features/featured/presentation/widgets/featured_organization_card.dart';
import 'package:karaburun/features/home/presentation/widgets/category_card.dart';
import 'package:karaburun/features/home/presentation/widgets/upcoming_event.banner.dart';
import 'package:karaburun/core/utils/icon_helper.dart';
import 'package:karaburun/core/utils/color_helper.dart';
import 'package:karaburun/core/config/app_category.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final OrganizationCategoryRepository _orgCategoryRepo = OrganizationCategoryRepository();
  final FeaturedOrganizationRepository _featuredRepo = FeaturedOrganizationRepository();
  final ActivityController _activityController = ActivityController();
  final VillageRepository _villageRepo = VillageRepository();
  final BeachRepository _beachRepo = BeachRepository();

  List<Map<String, dynamic>> _orgCategoriesList = [];
  List<ActivityCategory> _activityCategories = [];
  List<FeaturedOrganizationModel> _activeFeaturedList = [];
  List<Village> _allVillages = [];
  List<Beach> _beachList = [];
  Activity? _upcomingEvent;

  String _eventCategoryName = "";
  String _eventVillageName = "";

  bool _isInitialDataLoading = true;
  bool _eventLoading = true;
  bool _featuredLoading = true;
  bool _beachesLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      await Future.wait([
        loadOrgCategories(),
        loadVillages(),
        loadActivityCategories(),
      ]);
      if (mounted) setState(() => _isInitialDataLoading = false);
      _loadContentData();
    } catch (e) {
      debugPrint("Hata: $e");
    }
  }

  Future<void> _loadContentData() async {
    await Future.wait([
      loadUpcomingEvent(),
      loadFeaturedOrgs(),
      loadBeaches(),
    ]);
  }

  Future<void> loadBeaches() async {
    try {
      final data = await _beachRepo.fetchBeachs(highlight: true); 
      if (mounted) {
        setState(() { 
          _beachList = data; 
          _beachesLoading = false; 
        });
      }
    } catch (e) {
      debugPrint("Beach yükleme hatası: $e");
      if (mounted) setState(() => _beachesLoading = false);
    }
  }

  Future<void> loadOrgCategories() async {
    try {
      final data = await _orgCategoryRepo.fetchOrganizationCategory();
      final maps = data.map((cat) {
        final extra = cat.extra;
        return {
          "id": cat.id,
          "icon": IconHelper.getIcon(extra['icon']),
          "title": cat.name,
          "color": ColorHelper.getColor(extra['icon_color']),
          "path": "/organization",
        };
      }).toList();
      _orgCategoriesList = [...AppCategory.staticCategories, ...maps];
    } catch (e) {
      _orgCategoriesList = AppCategory.staticCategories;
    }
  }

  Future<void> loadVillages() async {
    try { _allVillages = await _villageRepo.fetchVillages(); } catch (e) {}
  }

  Future<void> loadActivityCategories() async {
    try { _activityCategories = await _activityController.getActivityCategories(); } catch (e) {}
  }

  Future<void> loadUpcomingEvent() async {
    try {
      final result = await _activityController.getUpcomingEvent();
      if (mounted && result != null) {
        String catName = "Etkinlik";
        if (_activityCategories.isNotEmpty) {
          final match = _activityCategories.where((c) => c.id == result.categoryId);
          if (match.isNotEmpty) catName = match.first.name;
        }
        String vName = "Karaburun Merkez";
        if (_allVillages.isNotEmpty) {
          final match = _allVillages.where((v) => v.id == result.villageId);
          if (match.isNotEmpty) vName = match.first.name;
        }
        setState(() { _upcomingEvent = result; _eventCategoryName = catName; _eventVillageName = vName; _eventLoading = false; });
      }
    } catch (e) {
      if (mounted) setState(() => _eventLoading = false);
    }
  }

  Future<void> loadFeaturedOrgs() async {
    try {
      final data = await _featuredRepo.fetchFeaturedOrgs(orgInfo: true);
      if (mounted) {
        setState(() {
          _activeFeaturedList = data.where((item) => item.active == true).toList();
          _featuredLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _featuredLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialDataLoading) return const Center(child: CircularProgressIndicator(color: Colors.orange));

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: _buildOrgCategoryList()
            ),
            UpcomingEventBanner(
              event: _upcomingEvent,
              isLoading: _eventLoading,
              onTap: () => context.go('/activity'),
              categoryName: _eventCategoryName,
              villageName: _eventVillageName,
            ),
            const SizedBox(height: 10),
            _buildContentPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildContentPanel() {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: const Color(0xFFF8FAFC),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(35), 
        topRight: Radius.circular(35)
      ),
      border: Border.all(color: Colors.black.withOpacity(0.03), width: 1),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 25),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. ÖNE ÇIKANLAR
        if (!_featuredLoading && _activeFeaturedList.isNotEmpty) ...[

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _buildSectionTitle("Öne Çıkan İşletmeler", onSeeAllTap: () => context.go('/organization')),
          ),
          const SizedBox(height: 8),
          _buildFeaturedList(),
          const SizedBox(height: 30),
        ],
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _buildSectionTitle("Popüler Koylar", onSeeAllTap: () => context.go('/beach')),
        ),
        const SizedBox(height: 8),
        BeachGrid(
          beaches: _beachList,
          villages: _allVillages,
          isLoading: _beachesLoading,
        ),
      ],
    ),
  );
}

  Widget _buildSectionTitle(String title, {VoidCallback? onSeeAllTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title, 
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textMain
          ),
        ),
        if (onSeeAllTap != null)
          GestureDetector(
            onTap: onSeeAllTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.bgSoftOrange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Tümünü Gör",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildOrgCategoryList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _orgCategoriesList.map((e) {
          return Padding(
            padding: const EdgeInsets.all(6),
            child: CategoryCard(
              icon: e['icon'],
              title: e['title'], 
              color: e['color'],
              onTap: () {
                final String? path = e['path'];
                final int? catId = e['id'];

                if (path != null) {
                  if (catId != null) {
                    context.go('$path?catId=$catId');
                  } else {
                    context.go(path);
                  }
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeaturedList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _activeFeaturedList.map((item) {
          return FeaturedOrganizationCard(
            item: item,
            onTap: () => context.go('/organization?catId=${item.organization.categoryId}')); 
        }).toList()));
  }
}