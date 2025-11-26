import 'package:flutter/material.dart';
import '../../../data/beach/model.dart';
import '../../../data/beach/repository.dart';

class BeachPage extends StatefulWidget {
  const BeachPage({super.key});

  @override
  State<BeachPage> createState() => _BeachPageState();
}

class _BeachPageState extends State<BeachPage> {
  final repo = BeachRepository();
  List<Beach> list = [];
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
      list = await repo.fetchBeachs();
    } catch (e) {
      error = "Koy & Sahil verileri yüklenirken hata oluştu!";
      debugPrint("Error fetching Beachs: $e");
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
        title: const Text("Plaj ve Koylar"),
      ),
      body: Builder(
        builder: (_) {
          if (loading) return const Center(child: CircularProgressIndicator());

          if (error != null)
            return Center(
              child: Text(
                error!,
                style: const TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );

          if (list.isEmpty)
            return const Center(
              child: Text(
                "Hiç Koy & Sahil bulunamadı.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            );

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
                          // Alt satır: açıklama
                          if (item.extra?['explanation'] != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "${item.extra!['explanation']}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
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
