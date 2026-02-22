extension DistanceHelpers on num {
  String formatDistance() {
    if (this >= 1000) {
      // 1000 metreden büyükse KM'ye çevir (Örn: 45.1 km)
      double km = this / 1000;
      return "${km.toStringAsFixed(1)} km";
    } else {
      // 1000 metreden küçükse metre olarak bırak (Örn: 450 m)
      return "${toStringAsFixed(0)} m";
    }
  }
}