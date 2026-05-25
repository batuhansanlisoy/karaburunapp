import 'package:flutter/material.dart';
import 'package:karaburun/core/utils/saved_manager.dart';
import 'package:karaburun/features/organization/data/models/organization_category_item_model.dart';
import 'package:karaburun/features/organization/data/models/organization_category_model.dart';
import 'package:karaburun/features/organization/data/repositories/organization_category_item.repository.dart';
import 'package:karaburun/features/organization/data/repositories/organization_category_repository.dart';
import 'package:karaburun/features/village/data/models/village_model.dart';
import '../../data/models/organization_model.dart';
import '../../data/repositories/organization_repository.dart';
import '../widgets/organization_list.dart' as widget_list;
import 'package:karaburun/core/widgets/app_search_input.dart' as widget_search;
import 'package:karaburun/features/village/data/repositories/village_repository.dart' as village_repo;
import 'package:go_router/go_router.dart';

class OrganizationPage extends StatefulWidget {
  final int? categoryId;

  const OrganizationPage({super.key, this.categoryId});

  @override
  State<OrganizationPage> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  final repo = OrganizationRepository();
  final itemRepo = OrganizationCategoryItemRepository();
  final villageRepo = village_repo.VillageRepository();
  final categoryRepo = OrganizationCategoryRepository();

  List<OrganizationModel> list = [];
  List<OrganizationModel> filteredList = [];
  List<OrganizationCategoryItemModel> categoryItems = [];
  List<Village> villages = [];
  Map<int, Village> villageMap = {};
  List<OrganizationCategoryModel> categories = [];
  Map<int, OrganizationCategoryModel> categoryMap = {};
  Set<int> _savedOrgIds = {};

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (!mounted) return;
    setState(() => loading = true);

    try {
      final results = await Future.wait([
        repo.fetchOrganizations(categoryId: widget.categoryId, subCategoryInfo: true),
        itemRepo.fetchOrganizationCategoryItem(),
        villageRepo.fetchVillages(),
        categoryRepo.fetchOrganizationCategory(),
        SavedManager.getSavedIds(SavedManager.orgKey),
      ]);

      list          = results[0] as List<OrganizationModel>;
      categoryItems = results[1] as List<OrganizationCategoryItemModel>;
      villages      = results[2] as List<Village>;
      categories    = results[3] as List<OrganizationCategoryModel>;
      _savedOrgIds  = (results[4] as List<int>).toSet();

      villageMap = {
        for (var village in villages) village.id: village,
      };

      categoryMap = {
        for (var category in categories) category.id: category,
      };

      filteredList = List.from(list);
      
    } catch (e) {
      debugPrint("Veri çekme hatası: $e");
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  void onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredList = List.from(list);
      } else {
        filteredList = list
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void didUpdateWidget(covariant OrganizationPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categoryId != widget.categoryId) {
      loadData();
    }
  }

  Future<void> toggleFavorite(int id) async {
    await SavedManager.toggleSave(SavedManager.orgKey, id);
    
    final updatedIds = await SavedManager.getSavedIds(SavedManager.orgKey);
    final isAdded = updatedIds.contains(id); // Ekledik mi çıkardık mı kontrolü

    setState(() {
      _savedOrgIds = updatedIds.toSet();
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
  
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
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
                hintText: "İşletme Ara...",
                onChanged: onSearchChanged,
              ),
            ),
          ),
        ];
      },
      body: widget_list.OrganizationList(
        list: filteredList,
        categoryItems: categoryItems,
        villageMap: villageMap,
        categoryMap: categoryMap,
        favoriteIds: _savedOrgIds,
        onFavoriteToggle: toggleFavorite,
        onTap: (item) {
            context.push('/organization/detail/${item.id}', extra: item);
        },
      ),
    );
  }
}