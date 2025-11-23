import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Deneme {
  final int id;
  final String name;

  Deneme({required this.id, required this.name});

  factory Deneme.fromJson(Map<String, dynamic> json) {
    return Deneme(
      id: json['id'],
      name: json['name'],
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<Deneme>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = fetchCategories();
  }

  Future<List<Deneme>> fetchCategories() async {
    // Android Emulator için localhost -> 10.0.2.2
    final url = Uri.parse('http://10.0.2.2:3000/organization/category/data');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => Deneme.fromJson(e)).toList();
    } else {
      throw Exception('Kategori verisi alınamadı');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kategoriler")),
      body: FutureBuilder<List<Deneme>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Henüz kategori yok'));
          } else {
            final categories = snapshot.data!;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final deneme = categories[index];
                return ListTile(
                  title: Text(deneme.name.toUpperCase()),
                  onTap: () {
                    // İstersen kategoriye tıklayınca başka sayfaya yönlendirme buraya eklenebilir
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
