import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      decoration: const BoxDecoration(
        color: Color.fromARGB(199, 19, 165, 97), // Pastel yeşil
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          SizedBox(
            height: 50, // istediğin yükseklik
            child: TextField(
              decoration: InputDecoration(
                hintText: "Ara: Restoran, benzinlik, eczane",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color.fromARGB(199, 19, 165, 97),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
