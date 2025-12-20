import 'package:flutter/material.dart';

import '../../data/models/activity_model.dart';
import '../../data/models/activity_category_model.dart';
import '../../data/repositories/activity_repository.dart';
import '../../data/repositories/activity_category_repository.dart';

import '../widgets/activity_category_bar.dart' as widget_bar;
import '../widgets/activity_list.dart' as widget_list;
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

  bool loading = true;
  int? selectedCategoryId;

  final String baseUrl = "http://10.0.2.2:3000";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);

    categories = await categoryRepo.fetchCategories();
    list = selectedCategoryId == null
        ? await repo.fetchActivity()
        : await repo.fetchActivity(categoryId: selectedCategoryId);

    setState(() => loading = false);
  }

  void onCategorySelect(int? id) {
    selectedCategoryId = id;
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Etkinlikler")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                widget_bar.ActivityCategoryBar(
                  categories: categories,
                  selectedCategoryId: selectedCategoryId,
                  onSelect: onCategorySelect,
                ),
                Expanded(
                  child: widget_list.ActivityList(
                    list: list,
                    baseUrl: baseUrl,
                    onTap: (item) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ActivityDetailPage(activity: item),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
