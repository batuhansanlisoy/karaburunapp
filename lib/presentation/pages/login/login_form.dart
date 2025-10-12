import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CustomTextField(
            hintText: "E-posta Adresi",
            keyboardType: TextInputType.emailAddress),
        SizedBox(height: 16),
        CustomTextField(hintText: "Şifre", obscureText: true)
      ],
    );
  }
}
