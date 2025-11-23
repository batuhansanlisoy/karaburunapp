import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final void Function(int) onPageChange;

  const CategoryPage({super.key, required this.onPageChange});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(   // ortalamak için Center ekledim
        child: Text("selam"),
      ),
    );
  }
}
