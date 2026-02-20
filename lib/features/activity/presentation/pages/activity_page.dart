import 'package:flutter/material.dart';

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

  List<Activity> list = [];
  List<ActivityCategory> categories = [];
  List<Activity> filteredList = [];
  Map<int, ActivityCategory> categoryMap = {};

  bool loading = true;
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);

    categories = await categoryRepo.fetchCategories();

    categoryMap = {
      for (var category in categories) category.id: category,
    };

    list = selectedCategoryId == null
        ? await repo.fetchActivity()
        : await repo.fetchActivity(categoryId: selectedCategoryId);

    filteredList = List.from(list);
    setState(() => loading = false);
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
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: widget_search.SearchInput(
                    hintText: "Etkinliklerde ara...",
                    onChanged: onSearchChanged,
                  ),
                ),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: widget_list.ActivityList(
              list: filteredList,
              categoryMap: categoryMap,
              onTap: (item) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ActivityDetailPage(activity: item),
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
