import 'package:flutter/material.dart';
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

  bool loading = true;
  int? selectedVillageId;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);

    villages = await villageRepo.fetchVillages();

    villageMap = {
      for (var village in villages) village.id: village,
    };

    list = selectedVillageId == null
      ? await repo.fetchBeachs()
      : await repo.fetchBeachs(villageId: selectedVillageId);
    
    filteredList = List.from(list);

    setState(() {
      loading = false;
    });
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  color: Colors.grey[200],
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
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: widget_search.SearchInput(
                    hintText: "Plaj & koylarda ara...",
                    onChanged: onSearchChanged,
                  ),
                ),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: widget_list.BeachList(
              list: filteredList,
              villageMap: villageMap,
              onTap: (item) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BeachDetail(beach: item),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
