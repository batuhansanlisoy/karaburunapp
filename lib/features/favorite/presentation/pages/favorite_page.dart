import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:karaburun/core/helpers/date.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:karaburun/core/utils/saved_manager.dart';
import 'package:karaburun/core/helpers/string_helpers.dart';
import 'package:material_symbols_icons/symbols.dart';

// Modeller
import 'package:karaburun/features/organization/data/models/organization_model.dart';
import 'package:karaburun/features/beach/data/models/beach_model.dart';
import 'package:karaburun/features/activity/data/models/activity_model.dart';
import 'package:karaburun/features/place/data/models/place_model.dart';

// Repolar
import 'package:karaburun/features/organization/data/repositories/organization_repository.dart';
import 'package:karaburun/features/beach/data/repositories/beach_repository.dart';
import 'package:karaburun/features/activity/data/repositories/activity_repository.dart';
import 'package:karaburun/features/place/data/repositories/place_repository.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _orgRepo = OrganizationRepository();
  final _beachRepo = BeachRepository();
  final _activityRepo = ActivityRepository();
  final _placeRepo = PlaceRepository();

  List<OrganizationModel> _organizations = [];
  List<Beach> _beaches = [];
  List<Activity> _activities = [];
  List<Place> _places = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAllFavorites();
  }

  Future<void> _loadAllFavorites() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final orgIds = await SavedManager.getSavedIds(SavedManager.orgKey);
      final beachIds = await SavedManager.getSavedIds(SavedManager.beachKey);
      final activityIds = await SavedManager.getSavedIds(SavedManager.activityKey);
      final placeIds = await SavedManager.getSavedIds(SavedManager.placeKey);

      final results = await Future.wait([
        orgIds.isNotEmpty ? _orgRepo.fetchOrganizations(ids: orgIds) : Future.value(<OrganizationModel>[]),
        beachIds.isNotEmpty ? _beachRepo.fetchBeachs(ids: beachIds) : Future.value(<Beach>[]),
        activityIds.isNotEmpty ? _activityRepo.fetchActivity(ids: activityIds) : Future.value(<Activity>[]),
        placeIds.isNotEmpty ? _placeRepo.fetchPlaces(ids: placeIds) : Future.value(<Place>[]),
      ]);

      if (mounted) {
        setState(() {
          _organizations = results[0] as List<OrganizationModel>;
          _beaches = results[1] as List<Beach>;
          _activities = results[2] as List<Activity>;
          _places = results[3] as List<Place>;
        });
      }
    } catch (e) {
      debugPrint("Favori yükleme hatası: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- KALDIRMA İŞLEMİ ---
  Future<void> _handleRemove(dynamic item, String type) async {
    String key = "";
    if (type == "org") key = SavedManager.orgKey;
    if (type == "beach") key = SavedManager.beachKey;
    if (type == "activity") key = SavedManager.activityKey;
    if (type == "place") key = SavedManager.placeKey;

    await SavedManager.toggleSave(key, item.id);

    setState(() {
      if (type == "org") _organizations.removeWhere((e) => e.id == item.id);
      if (type == "beach") _beaches.removeWhere((e) => e.id == item.id);
      if (type == "activity") _activities.removeWhere((e) => e.id == item.id);
      if (type == "place") _places.removeWhere((e) => e.id == item.id);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Kaydedilenlerden kaldırıldı"),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1000),
          backgroundColor: Colors.grey.shade900,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Kaydedilenler",
          style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          labelColor: AppColors.textOrange,
          unselectedLabelColor: AppColors.textMain,
          indicatorColor: AppColors.textOrange,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: "İşletmeler"),
            Tab(text: "Plajlar"),
            Tab(text: "Etkinlikler"),
            Tab(text: "Turistik"),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.textOrange))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildList(_organizations, "org"),
                _buildList(_beaches, "beach"),
                _buildList(_activities, "activity"),
                _buildList(_places, "place"),
              ],
            ),
    );
  }

  Widget _buildList(List<dynamic> items, String type) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Symbols.bookmark_remove, size: 64, color: Colors.grey.shade200),
            const SizedBox(height: 16),
            Text(
              "Kayıtlı veri bulunamadı.",
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAllFavorites,
      color: AppColors.textOrange,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          
          return Dismissible(
            key: Key("${type}_${item.id}"),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _handleRemove(item, type),
            background: Container(
              color: Colors.red.shade600,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: const Icon(Symbols.delete_forever, color: Colors.white, fill: 1),
            ),
            child: _buildFavoriteItem(
              item: item,
              type: type,
              onTap: () {
                if (type == "org") context.push("/organization/detail", extra: item);
                if (type == "beach") context.push("/beach/detail", extra: item);
                if (type == "activity") context.push("/activity/detail", extra: item);
                if (type == "place") context.push("/place/detail", extra: item);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFavoriteItem({
    required dynamic item,
    required String type,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade100, width: 1.5),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name.toString().capitalizeAll(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMain,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    icon: Symbols.location_on_rounded,
                    text: item.address?.toString().capitalize() ?? "Karaburun",
                  ),
                  if (type == "org") ...[
                    const SizedBox(height: 6),
                    _buildInfoRow(
                      icon: Symbols.call,
                      text: item.phone?.toString().formatPhoneNumber() ?? "-",
                    ),
                  ],
                  if (type == "activity") ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      icon: Symbols.calendar_month,
                      text: "${item.begin != null ? DateHelper.formatDateTime(item.begin!) : '-'} - ${item.end != null ? DateHelper.formatDateTime(item.end!) : '-'}",
                    ),
                  ],
                ],
              ),
            ),

            // SİLME BUTONU
            IconButton(
              onPressed: () => _handleRemove(item, type),
              icon: Icon(
                Symbols.delete,
                color: Colors.red.withValues(alpha: 0.3),
                size: 22,
                weight: 500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, fill: 1, size: 14, color: AppColors.textLight, weight: 700),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: AppColors.textMain, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}