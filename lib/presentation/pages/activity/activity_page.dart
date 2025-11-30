import 'package:flutter/material.dart';
import 'package:karaburun/data/activity/category/model.dart';
import 'package:karaburun/data/activity/category/repository.dart';
import '../../../data/activity/model.dart';
import '../../../data/activity/repository.dart';

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
  String? error;

  final String baseUrl = "http://10.0.2.2:3000";

  int? selectedCategoryId; // seçili kategori

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    setState(() {
      loading = true;
    });

    try {
      categories = await categoryRepo.fetchCategories();
      list = await repo.fetchActivity(categoryId: selectedCategoryId);
    } catch (e) {
      error = "Etkinlikler alınırken bir hata meydana geldi!";
      debugPrint("Error: $e");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  void onCategoryTap(int categoryId) {
    selectedCategoryId = categoryId;
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Etkinlikler",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        toolbarHeight: 30,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Kategori yatay listesi
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: categories.length,
                    itemBuilder: (_, i) {
                      final ct = categories[i];
                      final isSelected = selectedCategoryId == ct.id;

                      return GestureDetector(
                        onTap: () => onCategoryTap(ct.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          margin: const EdgeInsets.only(right: 12, top: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color.fromARGB(255, 216, 66, 66)
                                : const Color.fromARGB(255, 56, 101, 160),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              capitalize(ct.name),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Etkinlikler listesi
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final item = list[i];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        clipBehavior: Clip.antiAlias,
                        elevation: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Resim
                            item.logoUrl != null
                                ? Image.network(
                                    "$baseUrl${item.logoUrl}",
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: double.infinity,
                                      height: 200,
                                      color: Colors.grey[300],
                                      child:
                                          const Icon(Icons.image, size: 80),
                                    ),
                                  )
                                : Container(
                                    width: double.infinity,
                                    height: 200,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image, size: 80),
                                  ),
                            // Alt bilgi
                            Container(
                              width: double.infinity,
                              color: Colors.white.withOpacity(0.95),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  const SizedBox(height: 4),
                                  Text("Adres: ${item.address}",
                                      style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
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
