import 'package:flutter/material.dart';
import 'package:karaburun/features/organization/data/models/organization_category_item_model.dart';
import 'package:karaburun/features/organization/data/models/organization_category_model.dart';
import 'package:karaburun/features/organization/data/repositories/organization_category_item.repository.dart';
import 'package:karaburun/features/organization/data/repositories/organization_category_repository.dart';
import 'package:url_launcher/url_launcher.dart'; // Telefon ve web için lazım
import 'package:karaburun/core/helpers/string_helpers.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:karaburun/core/widgets/gallery_grid.dart';
import 'package:karaburun/features/organization/data/models/organization_model.dart';
import 'package:material_symbols_icons/symbols.dart';

class OrganizationDetail extends StatefulWidget {
  final OrganizationModel organization;
  const OrganizationDetail({super.key, required this.organization});

  @override
  State<OrganizationDetail> createState() => _OrganizationDetailState();
}

class _OrganizationDetailState extends State<OrganizationDetail> {
  final categoryRepo = OrganizationCategoryRepository();
  final itemRepo = OrganizationCategoryItemRepository();

  List<OrganizationCategoryItemModel> categoryItems = [];
  List<OrganizationCategoryModel> categories = [];
  Map<int, OrganizationCategoryModel> categoryMap = {};

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (!mounted) return;
    setState(() => loading = true);

    try {
      final results = await Future.wait([
        itemRepo.fetchOrganizationCategoryItem(),
        categoryRepo.fetchOrganizationCategory()
      ]);
      
      categoryItems = results[0] as List<OrganizationCategoryItemModel>;
      categories    = results[1] as List<OrganizationCategoryModel>;

      categoryMap = {
        for (var category in categories) category.id: category,
      };

    } catch (e) {
      debugPrint("Veri çekme hatası: $e");
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String fileUrl = ApiRoutes.fileUrl;
    final coverUrl = widget.organization.cover != null
        ? "$fileUrl${widget.organization.cover!['url']}"
        : null;

    final List<String> gallery = widget.organization.gallery?.map((path) {
      return "$fileUrl$path";
    }).toList() ?? [];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Üst Kapak Görseli
            if (coverUrl != null)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.40,
                width: double.infinity,
                child: Image.network(coverUrl, fit: BoxFit.cover),
              ),
            
            // Karartma Layer
            Container(
              height: MediaQuery.of(context).size.height * 0.40,
              color: Colors.black.withValues(alpha: 0.3),
            ),

            // Geri Butonu
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.5),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),

            // İçerik Paneli
            DraggableScrollableSheet(
              initialChildSize: 0.65,
              minChildSize: 0.65,
              maxChildSize: 1.0,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: Column(
                    children: [
                      // Sürükleme Çubuğu
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        height: 5,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      
                      // Başlık ve Köy Bilgisi
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Text(
                              widget.organization.name.capitalizeAll(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textMain,
                              ),
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Tab Bar
                      const TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.center,
                        labelColor: AppColors.textOrange,
                        indicatorColor: AppColors.textOrange,
                        unselectedLabelColor: AppColors.textMain, // Gri yerine textMain yaptık
                        indicatorSize: TabBarIndicatorSize.label,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        tabs: [
                          Tab(text: "İşletme Bilgileri"),
                          Tab(text: "Hizmetler"),
                          Tab(text: "Galeri"),
                        ],
                      ),

                      Expanded(
                        child: TabBarView(
                          children: [
                            // 1. Sekme: Hakkında ve İletişim
                            _buildInfoTab(scrollController),
                            _buildProductTab(scrollController),
                            // 2. Sekme: Galeri
                            GalleryGrid(images: gallery, controller: scrollController),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildProductTab(ScrollController controller) {
  if (loading) {
    return const Center(child: CircularProgressIndicator(color: AppColors.textOrange));
  }

  final List<String> matchedProductNames = [];
  
  if (widget.organization.subCategories != null) {
    for (var sub in widget.organization.subCategories!) {
      try {
        final categoryItem = categoryItems.firstWhere(
          (element) => element.id == sub.itemId
        );
        if (categoryItem.name.isNotEmpty) {
          matchedProductNames.add(categoryItem.name);
        }
      } catch (e) {
        debugPrint("Item bulunamadı ID: ${sub.itemId}");
      }
    }
  }

  if (matchedProductNames.isEmpty) {
    return const Center(
      child: Text(
        "Bu işletmeye ait içerik bilgisi bulunmuyor.",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  return ListView.builder(
    controller: controller,
    // DistanceCardList gibi dikeyde hafif boşluk, yatayda sıfıra yakın (veya 16-20)
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
    itemCount: matchedProductNames.length,
    itemBuilder: (context, index) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16), // İçerik ferahlığı
        decoration: BoxDecoration(
          color: AppColors.cardBg, // Referansındaki gibi cardBg veya grey[50]
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          matchedProductNames[index].capitalizeAll(),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold, // Referansındaki name stili gibi
            color: AppColors.textMain,
          ),
        ),
      );
    },
  );
}

  Widget _buildInfoTab(ScrollController controller) {
    // Content içindeki dinamik verileri çekelim
    final content = widget.organization.content;
    final bool hasWifi = content?['has_wifi'] == "1" || content?['has_wifi'] == true;
    final bool hasDelivery = content?['has_delivery'] == "1" || content?['has_delivery'] == true;
    final List<dynamic> paymentMethods = content?['payment_methods'] ?? [];

    final String? website = widget.organization.website;
    final bool hasWebsite = website != null && website.trim().isNotEmpty;

    return ListView(
      controller: controller,
      padding: const EdgeInsets.all(20),
      children: [
        // Açıklama
        const Text(
          "Hakkında",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          content?['description']?.toString().capitalize() ?? "İşletme hakkında açıklama bulunmuyor.",
          style: const TextStyle(color: Colors.black87, height: 1.5),
        ),

        const SizedBox(height: 20),

        // --- YENİ EKLENEN ÖZELLİKLER BÖLÜMÜ ---
        if (hasWifi || hasDelivery) ...[
          const Text(
            "İşletme Özellikleri",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (hasWifi)
                _buildFeatureChip(Symbols.wifi, "Ücretsiz Wi-Fi", Colors.blue),
              if (hasDelivery) ...[
                const SizedBox(width: 8),
                _buildFeatureChip(Symbols.moped_package, "Paket Servis", Colors.green),
              ],
            ],
          ),
          const SizedBox(height: 20),
        ],

        // Ödeme Yöntemleri
        if (paymentMethods.isNotEmpty) ...[
          const Text(
            "Ödeme Yöntemleri",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: paymentMethods.map((method) {
              return _buildPaymentMethod(method.toString());
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
        // ---------------------------------------

        const Text(
          "İletişim ve Adres",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        
        _buildContactRow(
          icon: Symbols.call,
          title: "Telefon",
          subtitle: widget.organization.phone.formatPhoneNumber(),
          onTap: () => _launchURL("tel:${widget.organization.phone}"),
        ),
        
        if (hasWebsite)
        _buildContactRow(
          icon: Symbols.language,
          title: "Web Sitesi",
          subtitle: website,
          onTap: () => _launchURL(website),
        ),

        _buildContactRow(
          icon: Symbols.map,
          title: "Yol Tarifi Al",
          subtitle: widget.organization.address.capitalize(),
          onTap: () {
            // MapLauncher kodun buraya gelecek
          },
        ),
      ],
    );
  }

  // Özellik Chip'i için yardımcı widget
  Widget _buildFeatureChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  // Ödeme yöntemi badge'i
  Widget _buildPaymentMethod(String method) {
    IconData icon;
    String label;

    switch (method.toLowerCase()) {
      case 'cash':
      case 'nakit':
        icon = Symbols.payments;
        label = "Nakit";
        break;
      case 'card':
      case 'kart':
        icon = Symbols.credit_card;
        label = "Kredi Kartı";
        break;
      case 'door':
      case 'kapıda ödeme':
        icon = Symbols.delivery_dining;
        label = "Kapıda Ödeme";
        break;
      case 'havale':
        icon = Symbols.account_balance;
        label = "Iban / Havale";
        break;
      default:
        icon = Symbols.sell;
        label = method.capitalizeAll();
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.black54),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildContactRow({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.textOrange),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}