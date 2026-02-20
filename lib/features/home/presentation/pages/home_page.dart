import 'package:flutter/material.dart';
// Modeller
import 'package:karaburun/features/activity/data/models/activity_category_model.dart';
import 'package:karaburun/features/activity/data/models/activity_model.dart';
import 'package:karaburun/features/featured/data/models/featured_organization_model.dart';
import 'package:karaburun/features/village/data/models/village_model.dart';
// Repositories & Controllers
import 'package:karaburun/features/activity/presentation/controllers/activity_controller.dart';
import 'package:karaburun/features/organization/data/repositories/organization_category_repository.dart';
import 'package:karaburun/features/featured/data/repositories/featured_organization_service.dart';
import 'package:karaburun/features/village/data/repositories/village_repository.dart';
// Widgets & Helpers
import 'package:karaburun/features/featured/presentation/widgets/featured_organization_card.dart';
import 'package:karaburun/features/home/presentation/widgets/category_card.dart';
import 'package:karaburun/features/home/presentation/widgets/upcoming_event.banner.dart';
import 'package:karaburun/core/utils/icon_helper.dart';
import 'package:karaburun/core/utils/color_helper.dart';
import 'package:karaburun/core/config/app_category.dart';

class HomePage extends StatefulWidget {
  final void Function(int index, {int? categoryId}) onPageChange;

  const HomePage({super.key, required this.onPageChange});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Repositories
  final OrganizationCategoryRepository _orgCategoryRepo = OrganizationCategoryRepository();
  final FeaturedOrganizationRepository _featuredRepo = FeaturedOrganizationRepository();
  final ActivityController _activityController = ActivityController();
  final VillageRepository _villageRepo = VillageRepository();

  // Data Lists
  List<Map<String, dynamic>> _orgCategoriesList = [];
  List<ActivityCategory> _activityCategories = [];
  List<Village> _allVillages = [];
  List<FeaturedOrganizationModel> _activeFeaturedList = [];
  Activity? _upcomingEvent;

  // Banner State
  String _eventCategoryName = "";
  String _eventVillageName = "";

  // Loading States
  bool _isInitialDataLoading = true;
  bool _eventLoading = true;
  bool _featuredLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  /// 1. ADIM: Altyapı Verilerini Yükle (Kategoriler, Köyler)
  Future<void> _loadInitialData() async {
    try {
      await Future.wait([
        loadOrgCategories(),
        loadVillages(),
        loadActivityCategories(),
      ]);
      
      if (mounted) {
        setState(() => _isInitialDataLoading = false);
      }

      // Altyapı hazır, şimdi içerikleri çekebiliriz
      _loadContentData();
    } catch (e) {
      debugPrint("Kritik veri yükleme hatası: $e");
    }
  }

  /// 2. ADIM: İçerik Verilerini Yükle (Etkinlik, Öne Çıkanlar)
  Future<void> _loadContentData() async {
    await Future.wait([
      loadUpcomingEvent(),
      loadFeaturedOrgs(),
    ]);
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
          "pageIndex": 1,
        };
      }).toList();
      _orgCategoriesList = [...AppCategory.staticCategories, ...maps];
    } catch (e) {
      _orgCategoriesList = AppCategory.staticCategories;
    }
  }

  Future<void> loadVillages() async {
    try {
      _allVillages = await _villageRepo.fetchVillages();
    } catch (e) {
      debugPrint("Köy yükleme hatası: $e");
    }
  }

  Future<void> loadActivityCategories() async {
    try {
      _activityCategories = await _activityController.getActivityCategories();
    } catch (e) {
      debugPrint("Etkinlik kategorisi yükleme hatası: $e");
    }
  }

  Future<void> loadUpcomingEvent() async {
    try {
      final result = await _activityController.getUpcomingEvent();
      if (mounted && result != null) {
        // Eşleştirme İşlemleri
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

        setState(() {
          _upcomingEvent = result;
          _eventCategoryName = catName;
          _eventVillageName = vName;
          _eventLoading = false;
        });
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
    if (_isInitialDataLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.orange));
    }

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 12),
            
            // 1. İşletme Kategorileri
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _buildOrgCategoryList(),
            ),

            // 2. Etkinlik Banner
            UpcomingEventBanner(
              event: _upcomingEvent,
              isLoading: _eventLoading,
              onTap: () => widget.onPageChange(2),
              categoryName: _eventCategoryName,
              villageName: _eventVillageName, 
            ),

            const SizedBox(height: 20),

            // 3. Alt İçerik Paneli
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
          topRight: Radius.circular(35),
        ),
        border: Border.all(color: Colors.black.withOpacity(0.03), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_featuredLoading && _activeFeaturedList.isNotEmpty) ...[
            _buildSectionTitle(
              "Öne Çıkan İşletmeler",
              onSeeAllTap: () => widget.onPageChange(1),
            ),
            const SizedBox(height: 6),
            _buildFeaturedList(), 
          ],
          const SizedBox(height: 100),
        ],
      ),
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
                if (e['pageIndex'] != null) {
                  widget.onPageChange(e['pageIndex'], categoryId: e['id']);
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
            onTap: () => widget.onPageChange(1),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {VoidCallback? onSeeAllTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
          if (onSeeAllTap != null)
            GestureDetector(
              onTap: onSeeAllTap,
              child: const Text("Tümünü Gör", style: TextStyle(fontSize: 14, color: Colors.black54, decoration: TextDecoration.underline)),
            ),
        ],
      ),
    );
  }
}