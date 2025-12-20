import 'package:flutter/material.dart';
import '../../data/models/beach_model.dart';
import '../../data/repositories/beach_repository.dart';
import '../widgets/beach_list.dart' as widget_list;

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
      setState(() => loading = false);
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

          return widget_list.BeachList(
            list: list,
            baseUrl: baseUrl,
          );
        },
      ),
    );
  }
}
