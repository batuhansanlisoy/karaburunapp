import 'package:flutter/material.dart';

class GuestLoginButton extends StatelessWidget {
  final VoidCallback onTap;
  const GuestLoginButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          side: const BorderSide(color: Colors.grey),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
        child: const Text("Misafir Olarak Devam Et"));
  }
}
