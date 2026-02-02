import 'package:flutter/material.dart';
import '../../data/models/organization_model.dart';
import '../../data/repositories/organization_repository.dart';
import '../widgets/organization_list.dart' as widget_list;
import 'package:karaburun/core/widgets/app_search_input.dart' as widget_search;

class OrganizationPage extends StatefulWidget {
  final int? categoryId;

  const OrganizationPage({super.key, this.categoryId});

  @override
  State<OrganizationPage> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  final repo = OrganizationRepository();

  List<OrganizationModel> list = [];
  List<OrganizationModel> filteredList = [];
  bool loading = true;

  // Backend URL - Emulator için 10.0.2.2 kullanmaya devam
  final String baseUrl = "http://10.0.2.2:3000";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (!mounted) return;
    setState(() => loading = true);

    try {
      list = await repo.fetchOrganizations(categoryId: widget.categoryId);
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
                    baseUrl: baseUrl,
                  ),
                ),
              ),
      ),
    );
  }
}