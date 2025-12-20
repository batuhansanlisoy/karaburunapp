import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String hintText;

  const SearchInput({
    super.key,
    this.onChanged,
    this.hintText = "Ara...",
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Colors.black45, width: 2),
        ),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }
}
