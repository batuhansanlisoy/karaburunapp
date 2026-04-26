import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:karaburun/core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward().whenComplete(() {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) context.go('/home');
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.titleLarge;

    return Scaffold(
      backgroundColor: const Color.fromARGB(211, 0, 0, 0),
      body: Stack( // İmza için Stack kullanmak en garantisi
        children: [
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // LOGO
                  Image.asset(
                    'assets/images/splash.png',
                    width: 250,
                    fit: BoxFit.contain,
                    // width: MediaQuery.of(context).size.width,
                    // fit: BoxFit.fill,
                  ),

                  // KARABURUNGO YAZISI
                  Transform.translate(
                    offset: const Offset(0, -50),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: baseStyle?.copyWith(
                          fontSize: 32, // Boyutu ideal seviyeye çektik
                          color: const Color.fromARGB(255, 255, 255, 255),
                          letterSpacing: -1.5,
                          fontWeight: FontWeight.w800, // Karaburun kısmı da artık daha tok
                        ),
                        children: [
                          const TextSpan(text: "Karaburun"),
                          TextSpan(
                            text: "GO",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w900, // GO en kalın haliyle devam
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // EN ALT KISIM - İmza
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'created by batuhansanlisoy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white, // Hafif şeffaf, asil durur
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}