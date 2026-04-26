import 'package:flutter/material.dart';
import '../../data/models/local_producer_model.dart';
import '../../data/repositories/local_producer_repository.dart';
import '../widgets/local_producer_list.dart' as widget_list;
import 'package:karaburun/core/widgets/app_search_input.dart' as widget_search;
import 'package:karaburun/features/village/data/models/village_model.dart';
import 'package:karaburun/features/village/data/repositories/village_repository.dart' as village_repo;
import '../widgets/village_bar.dart' as widget_bar;

class LocalProducerPage extends StatefulWidget {
  const LocalProducerPage({super.key});

  @override
  State<LocalProducerPage> createState() => _LocalProducerPageState();
}

class _LocalProducerPageState extends State<LocalProducerPage> {
  final repo = LocalProducerRepository();
  final villageRepo = village_repo.VillageRepository();

  List<LocalProducerModel> list = [];
  List<LocalProducerModel> filteredList = [];
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
      ? await repo.fetchLocalProducer()
      : await repo.fetchLocalProducer(villageId: selectedVillageId);
    
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
    return NestedScrollView(
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
                hintText: "Yerel Üreticilerde Ara...",
                onChanged: onSearchChanged,
              ),
            ),
          ),
        ];
      },
      body: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: widget_list.LocalProducerList(
          list: filteredList,
          villageMap: villageMap,
          onTap: (item) {
            // Detay sayfasına yönlendirme
          },
        ),
      ),
    );
  }
}
