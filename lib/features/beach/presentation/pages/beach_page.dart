import 'package:flutter/material.dart';
import 'package:karaburun/core/utils/saved_manager.dart';
import 'package:karaburun/features/beach/presentation/pages/beach_detail.dart';

import '../../data/models/beach_model.dart';
import '../../data/repositories/beach_repository.dart';
import '../widgets/beach_list.dart' as widget_list;
import 'package:karaburun/core/widgets/app_search_input.dart' as widget_search;
import 'package:karaburun/features/village/data/models/village_model.dart';
import 'package:karaburun/features/village/data/repositories/village_repository.dart' as village_repo;
import '../widgets/village_bar.dart' as widget_bar;

class BeachPage extends StatefulWidget {
  const BeachPage({super.key});

  @override
  State<BeachPage> createState() => _BeachPageState();
}

class _BeachPageState extends State<BeachPage> {
  final repo = BeachRepository();
  final villageRepo = village_repo.VillageRepository();

  List<Beach> list = [];
  List<Beach> filteredList = [];
  List<Village> villages = [];
  Map<int, Village> villageMap = {};
  Set<int> _savedBeachIds = {};

  bool loading = true;
  int? selectedVillageId;

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
        selectedVillageId == null
            ? repo.fetchBeachs()
            : repo.fetchBeachs(villageId: selectedVillageId),
        villageRepo.fetchVillages(),
        SavedManager.getSavedIds(SavedManager.beachKey),
      ]);

      list = results[0] as List<Beach>;
      villages = results[1] as List<Village>;
      _savedBeachIds = (results[2] as List<int>).toSet();

      villageMap = {
        for (var village in villages) village.id: village,
      };

      filteredList = List.from(list);
    } catch (e) {
      debugPrint("Beach veri çekme hatası: $e");
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
        filteredList = list.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  void onVillageSelect(int? id) {
    selectedVillageId = id;
    loadData();
  }

  Future<void> toggleFavorite(int id) async {
    await SavedManager.toggleSave(SavedManager.beachKey, id);
    
    final updatedIds = await SavedManager.getSavedIds(SavedManager.beachKey);
    final isAdded = updatedIds.contains(id);

    setState(() {
      _savedBeachIds = updatedIds.toSet();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars(); 
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAdded ? "Kaydedilenlere eklendi" : "Kaydedilenlerden çıkarıldı"),
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
    // Scaffold ve SafeArea iptal edildi, MainLayout'un Scaffold'u kullanılıyor.
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: SizedBox(
              width: double.infinity,
              child: widget_bar.VillageBar(
                villages: villages,
                selectedVillageId: selectedVillageId,
                onSelect: onVillageSelect,
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
                hintText: "Plaj & koylarda ara...",
                onChanged: onSearchChanged,
              ),
            ),
          ),
        ];
      },
      // BeachPage içindeki body kısmı
      body: widget_list.BeachList(
        list: filteredList,
        villageMap: villageMap,
        favoriteIds: _savedBeachIds,
        onFavoriteToggle: toggleFavorite,
        onTap: (item) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BeachDetail(beach: item),
            ),
          );
        },
      ),
    );
  }
}
