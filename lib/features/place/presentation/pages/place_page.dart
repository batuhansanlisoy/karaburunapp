import 'package:flutter/material.dart';
import 'package:karaburun/features/place/presentation/pages/place_detail.dart';
import '../../data/models/place_model.dart';
import '../../data/repositories/place_repository.dart';
import 'package:karaburun/features/village/data/models/village_model.dart';
import 'package:karaburun/features/village/data/repositories/village_repository.dart' as village_repo;
import '../widgets/village_bar.dart' as widget_bar;
import '../widgets/place_list.dart' as widget_list;
import 'package:karaburun/core/widgets/app_search_input.dart' as widget_search;

class PlacePage extends StatefulWidget {
  const PlacePage({super.key});

  @override
  State<PlacePage> createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {
  final repo = PlaceRepository();
  final villageRepo = village_repo.VillageRepository();

  List<Place> list = [];
  List<Place> filteredList = [];
  List<Village> villages = [];
  Map<int, Village> villageMap = {};

  bool loading = true;
  int? selectedVillageId;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true );

    villages = await villageRepo.fetchVillages();

    villageMap = {
      for (var village in villages) village.id: village,
    };

    list = selectedVillageId == null 
      ? await repo.fetchPlaces()
      : await repo.fetchPlaces(villageId: selectedVillageId);
    
    filteredList = List.from(list);

    setState(() => loading = false);
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

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      // Bu özellik header ile body arasındaki kaydırma koordinasyonunu sağlar
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          // 1. Köy Seçim Barı - Kaydırınca yukarı gider
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
          // 2. Arama Girişi - pinned: false olduğu için bu da kayıp gider
          SliverAppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            elevation: 0,
            pinned: false, // Çakılı kalmasın, yukarı aksın
            floating: true, // Aşağı kaydırınca hemen geri gelsin istiyorsan true kalsın
            snap: true,
            toolbarHeight: 72,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
              child: widget_search.SearchInput(
                hintText: "Turistik Yer Ara...",
                onChanged: onSearchChanged,
              ),
            ),
          ),
        ];
      },
      // Body içinde doğrudan listeyi veriyoruz. 
      // NestedScrollView zaten body'ye otomatik bir PrimaryScrollController atar.
      body: widget_list.PlaceList(
        list: filteredList,
        villageMap: villageMap,
        onTap: (item) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PlaceDetail(place: item),
            ),
          );
        },
      ),
    );
  }
}