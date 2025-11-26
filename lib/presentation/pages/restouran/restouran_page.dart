import 'package:flutter/material.dart';
import '../../../data/organization/model.dart';
import '../../../data/organization/repository.dart';

class RestouranPage extends StatefulWidget {
  const RestouranPage({super.key});

  @override
  State<RestouranPage> createState() => _RestouranPageState();
}

class _RestouranPageState extends State<RestouranPage> {
  final repo = OrganizationRepository();
  List<Organization> list = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    try {
      list = await repo.fetchRestaurants();
    } catch (e) {
      error = "Restoran alınırken bir hata meydana geldi!";
      debugPrint("Error fetching Restouran: $e");
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
        title: const Text("Restorantlar"),
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
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Restourant Adı: ${item.name}"),
                      Text("Adres: ${item.address}"),
                      Text("Telefon Numarası: ${item.phone}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
