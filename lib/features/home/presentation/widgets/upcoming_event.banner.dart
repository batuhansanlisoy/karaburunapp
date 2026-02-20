import 'package:flutter/material.dart';
import 'package:karaburun/features/activity/data/models/activity_model.dart';
import 'package:karaburun/core/helpers/string_helpers.dart'; 

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

    // Verileri hazırlayalım ve baş harflerini büyütelim
    final String eventName = event!.name.capitalize();
    final String category = (categoryName ?? "Etkinlik").capitalize();
    final String location = (villageName ?? "Karaburun Merkez").capitalizeAll();
    final String formattedDate = "${event!.begin.day} ${_monthName(event!.begin.month)} ${event!.begin.year}";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 120, // Biraz yükselttik tasarım rahatlasın diye
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF2D3436),
                const Color(0xFF000000).withOpacity(0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Sağ üst köşeye şık bir kategori etiketi
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.withOpacity(0.5), width: 0.5),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Sol taraf: Takvim İkonu Grubu
                    _buildDateIcon(event!.begin.day.toString(), _monthName(event!.begin.month).substring(0, 3)),
                    
                    const SizedBox(width: 16),
                    
                    // Orta: Bilgiler
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded, color: Colors.orange, size: 14),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  location,
                                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formattedDate,
                            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    
                    // Sağ: Ok işareti
                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.white.withOpacity(0.3), size: 14),
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
      width: 55,
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
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