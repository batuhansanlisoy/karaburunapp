import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  // --- SINGLETON YAPISI BAŞLANGIÇ ---
  // Bu kısım senin "instance" hatanı çözen kısımdır.
  AdManager._privateConstructor();
  static final AdManager instance = AdManager._privateConstructor();
  // --- SINGLETON YAPISI BİTİŞ ---

  InterstitialAd? _interstitialAd;

  // Reklamı yükleme fonksiyonu
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          print("Reklam başarıyla yüklendi.");
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
          print("Reklam yüklenemedi: $error");
        },
      ),
    );
  }

  // Reklamı gösterme fonksiyonu
  void showAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadInterstitialAd(); // Kapandıktan sonra yenisini yükle
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      print("Reklam henüz hazır değil, tekrar yükleme deneniyor.");
      loadInterstitialAd();
    }
  }
}