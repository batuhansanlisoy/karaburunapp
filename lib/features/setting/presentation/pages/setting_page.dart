import 'package:flutter/material.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;

  // URL Açma Fonksiyonu
  // URL Açma Fonksiyonu
  Future<void> _launchFeedbackUrl() async {
    // Statik URL yerine ApiRoutes içindeki tanımı kullanıyoruz
    // ApiRoutes.feedback zaten baseUrl/feedback döndürüyor
    final String feedbackUrl = "${ApiRoutes.feedback}/form";
    final Uri url = Uri.parse(feedbackUrl);
    
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'URL açılamadı: $url';
      }
    } catch (e) {
      debugPrint("Geri bildirim açılırken hata: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Form şu an açılmıyor: $e"),
            backgroundColor: AppColors.secondary, // Kendi hata rengini kullanabilirsin
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildSectionTitle("Uygulama Ayarları"),
            _buildSettingsCard([
              _buildSettingItem(
                icon: Symbols.notifications,
                title: "Bildirimler",
                subtitle: "Etkinlik ve hava durumu uyarıları",
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: (val) => setState(() => _notificationsEnabled = val),
                  activeColor: Colors.orange,
                ),
              ),
              _buildSettingItem(
                icon: Symbols.dark_mode,
                title: "Koyu Tema",
                subtitle: "Gece kullanımında göz yormaz",
                trailing: Switch(
                  value: _darkMode,
                  onChanged: (val) => setState(() => _darkMode = val),
                  activeColor: Colors.orange,
                ),
              ),
              _buildSettingItem(
                icon: Symbols.distance,
                title: "Mesafe Birimi",
                subtitle: "Kilometre (km) olarak göster",
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 20),
            _buildSectionTitle("Destek & Bilgi"),
            _buildSettingsCard([
              _buildSettingItem(
                icon: Symbols.info,
                title: "KaraburunGO Hakkında",
                subtitle: "Versiyon 1.0.4",
                onTap: () => _showAboutDialog(context),
              ),
              _buildSettingItem(
                icon: Symbols.mail,
                title: "Geri Bildirim Gönder",
                subtitle: "Hata bildir veya öneri yap",
                onTap: _launchFeedbackUrl, // Fonksiyon buraya bağlandı
              ),
              _buildSettingItem(
                icon: Symbols.policy,
                title: "Gizlilik Politikası",
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 30),
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Symbols.logout, color: Colors.redAccent),
                label: const Text(
                  "Oturumu Kapat",
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // --- Yardımcı Widgetlar --- (Aynen Korundu)
  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Batuhan Şanlısoy",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Text(
                "batuhan@developer.com",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: const Text("Yerel Rehber", style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Symbols.edit, color: Colors.grey))
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(children: items),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: const Color(0xFF475569), size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
    );
  }
}

// _showAboutDialog fonksiyonu (Aynen Korundu)
void _showAboutDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.8, // %80 yükseklik ideal
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
          ),
          const SizedBox(height: 25),
          const Text("KaraburunGO Nedir?", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          const Expanded(
            child: SingleChildScrollView(
              child: Text(
                "KaraburunGO, Yarımada’nın dijital kalbi ve en kapsamlı yaşam rehberidir. "
                "Keşfedilmeyi bekleyen gizli koylardan en güncel yerel etkinliklere kadar, "
                "Karaburun’a dair ne varsa tek bir dokunuşla cebinize getiriyoruz.\n\n"
                "Sektörünüz ne olursa olsun, işletmenizi sistemimize dahil ederek görünürlüğünüzü artırabilir, "
                "doğru kitleye doğrudan ulaşarak kazancınızı katlayabilirsiniz.",
                style: TextStyle(fontSize: 15, color: Color(0xFF424242), height: 1.6),
              ),
            ),
          ),
          const Divider(),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("Kapat", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    ),
  );
}