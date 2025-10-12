import 'package:flutter/material.dart';
import 'package:karaburun/presentation/layouts/main_layout.dart';
import 'login_form.dart';
import '../../widgets/custom_button.dart';
import '../../components/guest_login_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Arka plan resmi
          SizedBox.expand(
            child: Image.asset(
              'assets/images/backImage.jpg', // resim path'i
              fit: BoxFit.cover, // ekranı kaplar
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.withOpacity(0.2), // üstten az koyu
                  Colors.black.withOpacity(0.6), // alta doğru tamamen şeffaf
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // 🔹 Üstüne form ve içerikler
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Hoş Geldin",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // arka plan koyuysa beyaz yap
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Lütfen Giriş Yap veya Misafir Olarak Devam Et",
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // 🔹 GİRİŞ FORMU
                  const LoginForm(),
                  const SizedBox(height: 24),

                  // 🔹 GİRİŞ YAP BUTONU
                  CustomButton(
                    text: "Giriş Yap",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainLayout()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Giriş yapıldı (test)')),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // 🔹 MİSAFİR GİRİŞİ
                  GuestLoginButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainLayout()),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // 🔹 ÜYE OL LİNKİ
                  TextButton(
                    onPressed: () {
                      // ileride registera yönlendirme yapılacak
                    },
                    child: const Text(
                      "Hesabın Yok mu? Üye Ol",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
