import 'package:flutter/material.dart';
import 'package:karaburun/features/activity/data/models/activity_model.dart';
import 'package:karaburun/core/helpers/string_helpers.dart'; 
import 'package:material_symbols_icons/symbols.dart';

class UpcomingEventBanner extends StatelessWidget {
  final Activity? event;
  final bool isLoading;
  final String? categoryName;
  final String? villageName;
  final VoidCallback onTap;

  const UpcomingEventBanner({
    super.key,
    required this.event,
    required this.isLoading,
    required this.onTap,
    this.categoryName,
    this.villageName,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    if (event == null) return const SizedBox.shrink();
    final String beginStr = "${event!.begin.day} ${_monthName(event!.begin.month)}";
    final String endStr = "${event!.end.day} ${_monthName(event!.end.month)}";

    // ---- DEĞİŞİKLİK 1: RichText için tarih ve sabit metinleri ayırdık ----
    final bool isSingleDay = event!.begin == event!.end;
    final String dateRangeText = isSingleDay ? beginStr : "$beginStr - $endStr";
    final String suffixText = isSingleDay ? " tarihinde" : " tarihleri arasında";

    final String eventName = event!.name.capitalizeAll();
    final String category = (categoryName ?? "Etkinlik").capitalize();
    final String formattedVillage = (villageName ?? "Karaburun Merkez").capitalizeAll();
    final String address = event!.address.capitalize();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 92, 100, 102),
                const Color.fromARGB(255, 26, 64, 100).withValues(alpha: 0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Sağ Üst Köşe: Köy İsmi ve Kategori Etiketleri Yan Yana
              Positioned(
                top: 12,
                right: 12,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 0.5),
                      ),
                      child: Text(
                        formattedVillage,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 10,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.withValues(alpha: 0.5), width: 0.5),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sol taraf: Sadece Takvim İkonu Grubu
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 28), 
                        _buildDateIcon(event!.begin.day.toString(), _monthName(event!.begin.month).substring(0, 5)),
                      ],
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Orta: Bilgiler
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 28), 
                          
                          // 1. Satır: Etkinlik Adı
                          Text(
                            eventName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                              letterSpacing: 0.2,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          
                          // 2. Satır: Açık Adres
                          Text(
                            address,
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          
                          // ---- DEĞİŞİKLİK 2: Tek Satırda İki Farklı Renk (RichText) ----
                          RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            text: TextSpan(
                              style: const TextStyle(fontSize: 12), // Genel font boyutu
                              children: [
                                // Vurgulu Turuncu Tarih Kısmı
                                TextSpan(
                                  text: dateRangeText,
                                  style: TextStyle(
                                    color: Colors.orange.withValues(alpha: 0.85),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                // Soft Beyaz Metin Kısmı ("tarihinde" veya "tarihleri arasında")
                                TextSpan(
                                  text: suffixText,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.65),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Sağ: Ok işareti
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18), 
                        child: Icon(
                          Symbols.chevron_forward_rounded,
                          color: Colors.white.withValues(alpha: 0.3),
                          size: 22
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Takvim stili ikon widget'ı
  Widget _buildDateIcon(String day, String month) {
    return Container(
      width: 65,
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          Text(month.toUpperCase(), style: const TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"];
    return months[month - 1];
  }
}