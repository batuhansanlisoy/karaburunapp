import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

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
      cursorColor: Colors.grey.shade800,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 15,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

        // 🔹 Border yok, sadece focus’ta hafif gölge
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),

        prefixIcon: Icon(
          Symbols.search_rounded,
          size: 22,
          opticalSize: 24,
          weight: 500,
          grade: 0,
          color: Colors.grey.shade600,
        ),
      ),
      style: const TextStyle(
        fontSize: 15,
        color: Colors.black87,
      ),
    );
  }
}
