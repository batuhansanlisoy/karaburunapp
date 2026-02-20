import 'package:flutter/material.dart';
import '../../data/models/featured_organization_model.dart';
import '../../data/repositories/featured_organization_service.dart';

class FeaturedListPage extends StatefulWidget {
  const FeaturedListPage({super.key});

  @override
  State<FeaturedListPage> createState() => _FeaturedListPageState();
}

class _FeaturedListPageState extends State<FeaturedListPage> {
  final repo = FeaturedOrganizationRepository();
  List<FeaturedOrganizationModel> featuredList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadFeaturedData();
  }

  Future<void> loadFeaturedData() async {
    setState(() => loading = true);
    try {
      // orgInfo: true diyoruz ki içindeki organizasyon detayları (isim vb.) gelsin
      featuredList = await repo.fetchFeaturedOrgs(orgInfo: true);
    } catch (e) {
      print("Veri çekme hatası: $e");
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Öne Çıkan Organizasyonlar"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : featuredList.isEmpty
              ? const Center(child: Text("Öne çıkan kayıt bulunamadı."))
              : ListView.builder(
                  itemCount: featuredList.length,
                  itemBuilder: (context, index) {
                    final item = featuredList[index];
                    // Interface'de tanımladığımız iç içe objeye erişiyoruz
                    final org = item.organization; 

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(org?.id.toString() ?? "?"),
                      ),
                      title: Text(org?.name ?? "İsimsiz İşletme"),
                      subtitle: Text(org?.address ?? "Adres bilgisi yok"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        print("Seçilen Org ID: ${org?.id}");
                      },
                    );
                  },
                ),
    );
  }
}