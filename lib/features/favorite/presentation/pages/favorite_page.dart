import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:karaburun/core/helpers/date.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:karaburun/core/utils/saved_manager.dart';
import 'package:karaburun/core/helpers/string_helpers.dart';

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
        child: Text(
          "Kayıtlı veri bulunamadı.",
          style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
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
          return _buildFavoriteItem(
            item: item,
            type: type,
            onTap: () {
              if (type == "org") context.push("/organization/detail", extra: item);
              if (type == "beach") context.push("/beach/detail", extra: item);
              if (type == "activity") context.push("/activity/detail", extra: item);
              if (type == "place") context.push("/place/detail", extra: item);
            },
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
      behavior: HitTestBehavior.opaque, // Tüm alana tıklanabilmesi için
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            // Alt çizgiyi daha belirgin yaptık (Grey 200)
            bottom: BorderSide(color: Colors.grey.shade200, width: 1.5),
          ),
        ),
        child: Row(
          children: [
            // Sol Taraf: İçerik Bilgileri
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlık
                  Text(
                    item.name.toString().capitalizeAll(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMain,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Konum
                  _buildInfoRow(
                    icon: Icons.location_on_rounded,
                    text: item.address?.toString().capitalize() ?? "Karaburun",
                  ),

                  // İşletme (org) detayları
                  if (type == "org") ...[
                    const SizedBox(height: 6),
                    _buildInfoRow(
                      icon: Icons.call_rounded,
                      text: item.phone?.toString().formatPhoneNumber() ?? "-",
                    ),
                    const SizedBox(height: 6),
                    _buildInfoRow(
                      icon: Icons.mail_rounded,
                      text: item.email?.toString().toLowerCase() ?? "-",
                    ),
                  ],

                  // Etkinlik (activity) detayları
                  if (type == "activity") ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          size: 14,
                          color: AppColors.textMain.withValues(alpha: 0.4),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "${item.begin != null ? DateHelper.formatDateTime(item.begin!) : '-'} - ${item.end != null ? DateHelper.formatDateTime(item.end!) : '-'}",
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textMain,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Sağ Taraf: Caret Right İkonu
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMain.withValues(alpha: 0.2), // Hafif silik kalsın, içeriği boğmasın
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  // AppCard'daki _buildSimpleText mantığıyla ortak info satırı
  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: AppColors.textMain.withValues(alpha: 0.4),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMain,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}