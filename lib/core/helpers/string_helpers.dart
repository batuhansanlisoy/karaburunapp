extension StringHelpers on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  String capitalizeAll() {
    return split(" ").map((word) => word.capitalize()).join(" ");
  }

  String formatPhoneNumber() {
    // Önce içindeki tüm boşlukları ve gereksiz karakterleri temizle
    String cleanNumber = replaceAll(RegExp(r'\D'), '');

    // Eğer numara 0 ile başlıyorsa (0535 gibi), baştaki 0'ı atalım ki standart olsun
    if (cleanNumber.startsWith('0')) {
      cleanNumber = cleanNumber.substring(1);
    }

    // Eğer elimizde tam 10 hane kaldıysa formatla (5350604836 -> 535 060 48 36)
    if (cleanNumber.length == 10) {
      return "${cleanNumber.substring(0, 3)} ${cleanNumber.substring(3, 6)} ${cleanNumber.substring(6, 8)} ${cleanNumber.substring(8, 10)}";
    }

    // Eğer hane sayısı tutmuyorsa ham veriyi döndür (Hata vermesin diye)
    return this;
  }
}
