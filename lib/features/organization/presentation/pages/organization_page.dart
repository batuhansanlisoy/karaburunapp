import 'package:flutter/material.dart';
import '../../data/models/organization_model.dart';
import '../../data/repositories/organization_repository.dart';

class OrganizationPage extends StatefulWidget {
  const OrganizationPage({super.key});

  @override
  State<OrganizationPage> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
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
      list = await repo.fetchOrganizations();
    } catch (e) {
      error = "Organizasyonlar yüklenirken hata oluştu!";
      debugPrint("Error fetching organizations: $e");
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
          "Hiç organizasyon bulunamadı.",
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
            "Organization",
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
              final o = list[i];
              return ListTile(
                title: Text(o.name),
                subtitle: Text(o.categoryName),
                trailing: Text(o.phone),
              );
            },
          ),
        ),
      ],
    );
  }
}
