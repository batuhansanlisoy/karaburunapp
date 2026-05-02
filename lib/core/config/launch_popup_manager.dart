import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/core/widgets/app_launch_popup.dart';

class LaunchPopupManager {
  static final LaunchPopupManager _instance = LaunchPopupManager._internal();
  factory LaunchPopupManager() => _instance;
  LaunchPopupManager._internal();

  bool _hasShown = false;

  Future<void> checkAndShow(BuildContext context) async {
    if (_hasShown) return;

    try {
      final String apiKey = dotenv.env['MOBILE_API_KEY'] ?? '';

      final response = await http.get(
        Uri.parse("${ApiRoutes.config}/launch-popup"),
        headers: {
          'x-api-key': apiKey,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['isActive'] == true && data['imageUrl'] != null) {
          _hasShown = true;
          
          if (context.mounted) {
            _showDialog(
              context, 
              data['imageUrl'], 
              data['targetUrl']
            );
          }
        }
      } else {
        debugPrint("Popup API Hatası: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Popup Veri Çekme Hatası: $e");
    }
  }

  void _showDialog(BuildContext context, String imageUrl, String? targetUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppLaunchPopup(
        imageUrl: imageUrl,
        onTap: () async {
          Navigator.of(context, rootNavigator: true).pop();
          
          if (targetUrl != null && targetUrl.isNotEmpty) {
            if (targetUrl.startsWith('http')) {
              final Uri url = Uri.parse(targetUrl);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                debugPrint("URL açılamadı: $targetUrl");
              }
            } else {
              context.push(targetUrl);
            }
          }
        },
      ),
    );
  }
}