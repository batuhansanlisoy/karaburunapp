import 'package:flutter/material.dart';
import '../../../data/place/model.dart';
import '../../../data/place/repository.dart';

class PlacePage extends StatefulWidget {
  const PlacePage({super.key});

  @override
  State<PlacePage> createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {
  final repo = PlaceRepository();
  List<Place> list = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    try {
      list = await repo.fetchPlaces();
    } catch (e) {
      error = "Place yüklenirken hata oluştu!";
      debugPrint("Error fetching Places: $e");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          "Hiç Place bulunamadı.",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "Place",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final item = list[i];
              return ListTile(
                title: Text(item.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Köy: ${item.villageName}"),
                    Text("Adres: ${item.address}"),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
