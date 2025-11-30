import 'package:flutter/material.dart';
import 'package:karaburun/presentation/widgets/featured_item_card.dart';
import 'package:karaburun/presentation/widgets/beach_card.dart';
import '../../widgets/category_card.dart';
import '../../../data/categories.dart' show categories;
import '../../../data/featureds.dart' show featuredItems;
import '../../../data/beac.dart' show beachItems;

class HomePage extends StatelessWidget {
  final void Function(int) onPageChange;

  const HomePage({super.key, required this.onPageChange});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          /// --- KATEGORİLER ---
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6, bottom: 3, top: 3),
                  child: CategoryCard(
                    icon: e['icon'],
                    title: e['title'],
                    color: e['color'],
                    onTap: () {
                      if (e['pageIndex'] != null) {
                        onPageChange(e['pageIndex']);
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
          ),

          const SizedBox(height: 20),

          /// --- ÖNE ÇIKANLAR ---
          const Text(
            "Öne Çıkanlar",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 12),

          SingleChildScrollView(
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
          ),

          const SizedBox(height: 20),

          /// --- KOY & SAHİL ---
          const Text(
            "Koy & Sahil",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 12),

          Column(
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
          ),
        ],
      ),
    );
  }
}
