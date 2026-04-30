import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:karaburun/features/activity/data/models/activity_category_model.dart';
import 'package:karaburun/features/activity/data/models/activity_model.dart';
import 'package:karaburun/features/beach/data/models/beach_model.dart';
import 'package:karaburun/features/local_producer/data/models/local_producer_model.dart';
import 'package:karaburun/features/local_producer/data/repositories/local_producer_repository.dart';
import 'package:karaburun/features/organization/data/models/organization_model.dart';
import 'package:karaburun/features/beach/data/repositories/beach_repository.dart';
import 'package:karaburun/features/home/presentation/widgets/beach_grid.dart';
import 'package:karaburun/features/organization/data/repositories/organization_repository.dart';
import 'package:karaburun/features/village/data/models/village_model.dart';
import 'package:karaburun/features/activity/presentation/controllers/activity_controller.dart';
import 'package:karaburun/features/organization/data/repositories/organization_category_repository.dart';
import 'package:karaburun/features/village/data/repositories/village_repository.dart';
import 'package:karaburun/features/featured/presentation/widgets/featured_organization_card.dart';
import 'package:karaburun/features/local_producer/presentation/widgets/highligted_local_producer_card.dart';
import 'package:karaburun/features/home/presentation/widgets/category_card.dart';
import 'package:karaburun/features/home/presentation/widgets/upcoming_event.banner.dart';
import 'package:karaburun/features/home/presentation/widgets/village_grid.dart';
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
  final ActivityController _activityController = ActivityController();
  final VillageRepository _villageRepo = VillageRepository();
  final BeachRepository _beachRepo = BeachRepository();
  final OrganizationRepository _organizationRepository = OrganizationRepository();
  final LocalProducerRepository _localProducerRepository = LocalProducerRepository();

  List<Village> _allVillages = [];
  List<ActivityCategory> _activityCategories = [];
  List<Map<String, dynamic>> _orgCategoriesList = [];
  List<OrganizationModel> _highlightedOrganizations = [];
  List<LocalProducerModel> _highligtedLocalProducers = [];
  List<Beach> _highlightedBeachs = [];
  List<Activity> _upcomingEvents = [];
  PageController? _eventPageController;
  Timer? _eventTimer;
  int _currentEventIndex = 0;

  bool _isInitialDataLoading = true;
  bool _eventLoading = true;
  bool _highlightedBeachLoading = true;
  bool _highlightedOrganizationLoading = true;
  bool _highlightedLocalProducerLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _eventTimer?.cancel();
    _eventPageController?.dispose();
    super.dispose();
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
      loadUpcomingEvents(),
      loadHighligtedOrganizations(),
      loadHighligtedBeaches(),
      loadHiglightedLocalProducers()
    ]);
  }

  Future<void> loadHighligtedBeaches() async {
    try {
      final data = await _beachRepo.fetchBeachs(highlight: true); 

      if (mounted) {
        setState(() { 
          _highlightedBeachs = data; 
          _highlightedBeachLoading = false; 
        });
      }
    } catch (e) {
      debugPrint("Beach yükleme hatası: $e");
      if (mounted) setState(() => _highlightedBeachLoading = false);
    }
  }

  Future<void> loadHighligtedOrganizations() async {
    try {
      final data = await _organizationRepository.fetchOrganizations(highlight: true, isActive: true);

      if (mounted) {
        setState(() {
          _highlightedOrganizations = data;
          _highlightedOrganizationLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Öne çıkarılan işletme yüklenme hatası $e");
      if (mounted) setState(() => _highlightedOrganizationLoading = false);
    }
  }

  Future<void> loadHiglightedLocalProducers() async {
    try {
      final data = await _localProducerRepository.fetchLocalProducer(highlight: true, isActive: true);

      if (mounted) {
        setState(() {
            _highligtedLocalProducers = data;
            _highlightedLocalProducerLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _highlightedLocalProducerLoading = false;
        });
      }
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

  Future<void> loadUpcomingEvents() async {
    try {
      final results = await _activityController.getUpcomingEvents();
      if (mounted) {
        setState(() {
          _upcomingEvents = results;
          _eventLoading = false;
        });

        if (_upcomingEvents.length > 1) {
          _setupEventTimer();
        }
      }
    } catch (e) {
      if (mounted) setState(() => _eventLoading = false);
    }
  }

  void _setupEventTimer() {
    _eventPageController = PageController();
    _eventTimer?.cancel();
    _eventTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_eventPageController != null && _eventPageController!.hasClients) {
        _currentEventIndex = (_currentEventIndex + 1) % _upcomingEvents.length;
        _eventPageController!.animateToPage(
          _currentEventIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutQuart,
        );
      }
    });
  }

  String _getEventCategoryName(int id) {
    final match = _activityCategories.where((c) => c.id == id);
    return match.isNotEmpty ? match.first.name : "Etkinlik";
  }

  String _getEventVillageName(int id) {
    final match = _allVillages.where((v) => v.id == id);
    return match.isNotEmpty ? match.first.name : "Karaburun";
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialDataLoading) return const Center(child: CircularProgressIndicator(color: Colors.orange));

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: _buildOrgCategoryList()
            ),
            if (!_eventLoading && _upcomingEvents.isNotEmpty)
              SizedBox(
                height: 160, // Banner yüksekliğine göre ayarla
                child: PageView.builder(
                  controller: _eventPageController,
                  itemCount: _upcomingEvents.length,
                  onPageChanged: (index) => _currentEventIndex = index,
                  itemBuilder: (context, index) {
                    final event = _upcomingEvents[index];
                    return UpcomingEventBanner(
                      event: event,
                      isLoading: false,
                      categoryName: _getEventCategoryName(event.categoryId),
                      villageName: _getEventVillageName(event.villageId),
                      onTap: () => context.push('/activity/detail', extra: event),
                    );
                  },
                ),
              ),
            const SizedBox(height: 10),
            VillageGrid(villages: _allVillages),
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
      border: Border.all(color: Colors.black.withValues(alpha: 0.03), width: 1),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 25),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // öne çıkan işletmeler(organization)
        if (!_highlightedLocalProducerLoading && _highligtedLocalProducers.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _buildSectionTitle("Öne Çıkan Yerel Üreticiler", onSeeAllTap: () => context.go('/local_producer')),
          ),
          const SizedBox(height: 8),
          _buildHihglightedLocalProducer(),
          const SizedBox(height: 30)

        ],
        if (!_highlightedOrganizationLoading && _highlightedOrganizations.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _buildSectionTitle("Öne Çıkan İşletmeler", onSeeAllTap: () => context.go('/organization')),
          ),
          const SizedBox(height: 8),
          _buildHihglightedOrganization(),
          const SizedBox(height: 30),
        ],
        // öne çıkarılan koylar(beach)
        if (!_highlightedBeachLoading && _highlightedBeachs.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _buildSectionTitle("Popüler Koylar", onSeeAllTap: () => context.go('/beach')),
          ),
          const SizedBox(height: 8),
          BeachGrid(
            beaches: _highlightedBeachs,
            villages: _allVillages,
            isLoading: _highlightedBeachLoading,
            onBeachTap: (beach) {
              context.push('/beach/detail', extra: beach);
            },
          )
        ],
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

  Widget _buildHihglightedOrganization() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _highlightedOrganizations.map((item) {
          return FeaturedOrganizationCard(
            item: item,
            villages: _allVillages,
            onTap: () => context.push('/organization/detail', extra: item)
          ); 
        }).toList()));
  }

   Widget _buildHihglightedLocalProducer() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _highligtedLocalProducers.map((item) {
          return HighligtedLocalProducerCard(
            item: item,
            villages: _allVillages,
            onTap: () => context.go('/local_producer')
          ); 
        }).toList()));
  }
}