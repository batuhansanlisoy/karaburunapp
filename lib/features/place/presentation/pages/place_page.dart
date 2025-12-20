import 'package:flutter/material.dart';
import '../../data/models/place_model.dart';
import '../../data/repositories/place_repository.dart' as place_repo;
import 'package:karaburun/features/village/data/models/village_model.dart';
import 'package:karaburun/features/village/data/repositories/village_repository.dart' as village_repo;
import '../widgets/village_bar.dart' as widget_bar;
import '../widgets/place_list.dart' as widget_list;

class PlacePage extends StatefulWidget {
  const PlacePage({super.key});

  @override
  State<PlacePage> createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {
  final repo = place_repo.PlaceRepository();
  final villageRepo = village_repo.VillageRepository();

  List<Place> list = [];
  List<Village> villages = [];

  bool loading = true;
  int? selectedVillageId;

  final String baseUrl = "http://10.0.2.2:3000";

  String? error;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true );

    villages = await villageRepo.fetchVillages();
    list = selectedVillageId == null 
      ? await repo.fetchPlaces()
      : await repo.fetchPlaces(villageId: selectedVillageId);
    
    setState(() => loading = false);
  }

  void onVillageSelect(int? id) {
    selectedVillageId = id;
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gezilecek Yerler")),
      body: loading
        ? const Center(child: CircularProgressIndicator())
        : Column(
          children: [
            widget_bar.VillageBar(
              villages: villages,
              selectedVillageId: selectedVillageId,
              onSelect: onVillageSelect
            ),
            Expanded(
              child: widget_list.PlaceList(
                list: list,
                baseUrl: baseUrl,
              )
            )
          ]) 
    );
  }
}