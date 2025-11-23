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
          "Hiç Koy & Sahil bulunamadı.",
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
            "Koy & Sahil",
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
