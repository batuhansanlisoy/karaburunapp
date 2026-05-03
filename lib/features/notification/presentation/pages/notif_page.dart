import 'package:flutter/material.dart';

class NotifPage extends StatelessWidget {
  const NotifPage({ super.key });

  @override
  Widget build(BuildContext context) {
    // Scaffold'u attık, yerine doğrudan içeriği basıyoruz.
    return Container(
      color: Colors.white, // Arkaplan rengini layout ile uyumlu yapalım
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Başlık veya içerik buraya gelir
          Text(
            "Bildirimler", 
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text("Henüz bir bildiriminiz bulunmuyor."),
            ),
          ),
        ],
      ),
    );
  }
}