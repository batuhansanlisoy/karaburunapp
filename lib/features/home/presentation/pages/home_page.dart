import 'package:flutter/material.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:karaburun/features/home/presentation/widgets/featured_item_card.dart';
import 'package:karaburun/features/home/presentation/widgets/beach_card.dart';
import 'package:karaburun/features/home/presentation/widgets/category_card.dart';
import 'package:karaburun/core/config/featureds.dart';
import 'package:karaburun/core/config/beac.dart';
import 'package:karaburun/core/config/app_category.dart'; // Yeni import
import 'package:karaburun/core/utils/icon_helper.dart';
import 'package:karaburun/core/utils/color_helper.dart';
import 'package:karaburun/features/organization/data/repositories/organization_category_repository.dart';

class HomePage extends StatefulWidget {
  final void Function(int index, {int? categoryId}) onPageChange;

  const HomePage({super.key, required this.onPageChange});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final OrganizationCategoryRepository _organizationCategoryRepo = OrganizationCategoryRepository();
  List<Map<String, dynamic>> categoriesList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final dynamicCategories = await _organizationCategoryRepo.fetchOrganizationCategory();

      final List<Map<String, dynamic>> dynamicMaps = dynamicCategories.map((cat) {
        final Map<String, dynamic> extra = cat.extra;
        return {
          "id": cat.id,
          "icon": IconHelper.getIcon(extra['icon']),
          "title": cat.name,
          "color": ColorHelper.getColor(extra['icon_color']),
          "pageIndex": 1,
        };
      }).toList();

      if (mounted) {
        setState(() {
          // Sabitler + Dinamikler birleşiyor
          categoriesList = [...AppCategory.staticCategories, ...dynamicMaps];
          loading = false;
        });
      }
    } catch (e) {
      debugPrint('Kategori yükleme hatası: $e');
      if (mounted) {
        setState(() {
          categoriesList = AppCategory.staticCategories;
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      color: Colors.white, // KATEGORİLERİN ARKASI BEMBEYAZ
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            
            /// --- 1. KATEGORİLER (Beyaz Zemin Üstünde) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _buildCategoryList(),
            ),

            const SizedBox(height: 20),

            /// --- 2. İÇERİK PANELİ (Hafif Koyu/Gri ve Yuvarlak) ---
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                // Panel kısa kalırsa ekranın altına kadar uzansın
                minHeight: MediaQuery.of(context).size.height, 
              ),
              decoration: BoxDecoration(
                // BURASI: Panelin rengini hafif koyu yapıyoruz
                color: const Color(0xFFF8FAFC), // Çok hafif, modern bir gri
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
                border: Border.all(
                  color: Colors.black.withOpacity(0.03), // Çok ince bir hat
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// --- ÖNE ÇIKANLAR ---
                  _buildSectionTitle("Öne Çıkanlar"),
                  const SizedBox(height: 6),
                  _buildFeaturedList(),

                  const SizedBox(height: 24),

                  /// --- KOY & SAHİL ---
                  _buildSectionTitle("Koy & Sahil"),
                  const SizedBox(height: 6),
                  _buildBeachList(),
                  
                  const SizedBox(height: 100), // Navbar payı
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      // Buradaki 20 değeri, yazıyı soldan ne kadar iteceğini belirler
      padding: const EdgeInsets.symmetric(horizontal: 10), 
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categoriesList.map((e) {
          return Padding(
            padding: const EdgeInsets.all(6),
            child: CategoryCard(
              icon: e['icon'],
              title: e['title'],
              color: e['color'],
              onTap: () {
                if (e['pageIndex'] != null) {
                  // e['id'] bilgisini MainLayout'a paslıyoruz
                  widget.onPageChange(e['pageIndex'], categoryId: e['id']);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Bu kategori henüz aktif değil.")),
                  );
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeaturedList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: featuredItems.map((item) {
          return FeaturedItemCard(
            title: item['title'] ?? '',
            subtitle: item['subtitle'] ?? '',
            image: item['image'] ?? '',
            onTap: () {},
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBeachList() {
    return Column(
      children: beachItems.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: BeachCard(
            title: item['title'] ?? '',
            adress: item['adress'] ?? '',
            image: item['image'] ?? '',
            onTap: () {},
          ),
        );
      }).toList(),
    );
  }
}