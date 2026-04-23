import 'package:flutter/material.dart';
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
        categoryRepo.fetchOrganizationCategory()
      ]);

      list          = results[0] as List<OrganizationModel>;
      categoryItems = results[1] as List<OrganizationCategoryItemModel>;
      villages      = results[2] as List<Village>;
      categories    = results[3] as List<OrganizationCategoryModel>;

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
    // Eğer MainLayout'tan gelen categoryId değişmişse, verileri tekrar çek
    if (oldWidget.categoryId != widget.categoryId) {
      loadData();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : NestedScrollView(
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
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: widget_search.SearchInput(
                          hintText: "İşletme Ara...",
                          onChanged: onSearchChanged,
                        ),
                      ),
                    ),
                  ];
                },
                body: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: widget_list.OrganizationList(
                    list: filteredList,
                    categoryItems: categoryItems,
                    villageMap: villageMap,
                    categoryMap: categoryMap,
                  ),
                ),
              ),
      ),
    );
  }
}