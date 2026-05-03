import 'package:flutter/material.dart';
import 'package:karaburun/core/utils/saved_manager.dart';
import 'package:karaburun/features/village/data/models/village_model.dart';
import 'package:karaburun/features/village/data/repositories/village_repository.dart';
import '../../data/models/activity_model.dart';
import '../../data/models/activity_category_model.dart';
import '../../data/repositories/activity_repository.dart';
import '../../data/repositories/activity_category_repository.dart';
import '../widgets/activity_category_bar.dart' as widget_bar;
import '../widgets/activity_list.dart' as widget_list;
import 'package:karaburun/core/widgets/app_search_input.dart' as widget_search;
import 'activity_detail.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final repo = ActivityRepository();
  final categoryRepo = ActivityCategoryRepository();
  final villageRepo = VillageRepository();

  List<Activity> list = [];
  List<ActivityCategory> categories = [];
  List<Village> villages = [];
  List<Activity> filteredList = [];
  Map<int, ActivityCategory> categoryMap = {};
  Map<int, Village> villageMap = {};
  Set<int> _savedActivityIds = {};

  bool loading = true;
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (!mounted) return;
    setState(() => loading = true);

    try {
      // Future.wait ile her şeyi aynı anda başlatıyoruz
      final results = await Future.wait([
        categoryRepo.fetchCategories(),
        villageRepo.fetchVillages(),
        selectedCategoryId == null
            ? repo.fetchActivity()
            : repo.fetchActivity(categoryId: selectedCategoryId),
        SavedManager.getSavedIds(SavedManager.activityKey), // Etkinlik favorileri
      ]);

      categories    = results[0] as List<ActivityCategory>;
      villages      = results[1] as List<Village>;
      list          = results[2] as List<Activity>;
      _savedActivityIds = (results[3] as List<int>).toSet();

      categoryMap = {
        for (var category in categories) category.id: category,
      };

      villageMap = {
        for (var village in villages) village.id: village
      };

      filteredList = List.from(list);
    } catch (e) {
      debugPrint("Activity yükleme hatası: $e");
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Future<void> toggleFavorite(int id) async {
    await SavedManager.toggleSave(SavedManager.activityKey, id);
    
    final updatedIds = await SavedManager.getSavedIds(SavedManager.activityKey);
    final isAdded = updatedIds.contains(id);

    setState(() {
      _savedActivityIds = updatedIds.toSet();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars(); 
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAdded ? "Kaydedilenlere eklendi" : "Kaydedilenlerden çıkartıldı"),
          duration: const Duration(milliseconds: 1000),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isAdded ? Colors.green.shade700 : Colors.grey.shade800,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredList = List.from(list);
      } else {
        filteredList = list
            .where(
              (p) => p.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void onCategorySelect(int? id) {
    selectedCategoryId = id;
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold ve SafeArea kaldırıldı, MainLayout içindeki ana Scaffold'a güveniyoruz.
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: SizedBox(
              width: double.infinity,
              child: widget_bar.ActivityCategoryBar(
                categories: categories,
                selectedCategoryId: selectedCategoryId,
                onSelect: onCategorySelect,
              ),
            ),
          ),
          SliverAppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            elevation: 0,
            floating: true,
            snap: true,
            toolbarHeight: 72,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
              child: widget_search.SearchInput(
                hintText: "Etkinliklerde ara...",
                onChanged: onSearchChanged,
              ),
            ),
          ),
        ];
      },
      body: widget_list.ActivityList(
        list: filteredList,
        categoryMap: categoryMap,
        villageMap: villageMap,
        favoriteIds: _savedActivityIds,
        onFavoriteToggle: toggleFavorite,
        onTap: (item) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ActivityDetailPage(activity: item),
            ),
          );
        },
      ),
    );
  }
}
