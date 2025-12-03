import 'package:flutter/material.dart';
import '../../../data/organization/model.dart';
import '../../../data/organization/repository.dart';

class CafePage extends StatefulWidget {
  const CafePage({super.key});

  @override
  State<CafePage> createState() => _CafePageState();
}

class _CafePageState extends State<CafePage> {
  final repo = OrganizationRepository();
  List<Organization> list = [];
  bool loading = true;
  String? error;

  final String baseUrl = "http://10.0.2.2:3000";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    try {
      list = await repo.fetchCafes();
    } catch (e) {
      error = "Cafe alınırken bir hata meydana geldi!";
      debugPrint("Error fetching Cafe: $e");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kahveciler"),
      ),

      body: Builder(
        builder: (_) {
          if (loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (error != null) {
            return Center(
              child: Text(
                error!,
                style: const TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (list.isEmpty) {
            return const Center(
              child: Text(
                "Hiç Restourant Bulunamadı",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            );
          }

          return ListView.builder(
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
                    // Resim tam genişlik
                    item.cover != null
                        ? Image.network(
                            "$baseUrl${item.cover}",
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, size: 80),
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, size: 80),
                          ),
                    // Alt bilgi alanı
                    Container(
                      width: double.infinity,
                      color: Colors.white.withOpacity(0.95),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Üst satır: isim, adres, location
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Adres: ${item.address}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.location_on,
                                  size: 32, color: Color.fromARGB(255, 107, 107, 107)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
