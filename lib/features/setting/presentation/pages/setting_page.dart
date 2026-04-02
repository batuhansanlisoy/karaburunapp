import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:karaburun/core/theme/app_colors.dart'; // Senin projendeki renk paleti

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Hafif gri-mavi arka plan (modern durur)
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header / Profil Özeti ---
            _buildProfileHeader(),

            const SizedBox(height: 20),

            // --- Ayarlar Grupları ---
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
                onTap: () {},
              ),
              _buildSettingItem(
                icon: Symbols.mail,
                title: "Geri Bildirim Gönder",
                subtitle: "Hata bildiri veya öneri yap",
                onTap: () {},
              ),
              _buildSettingItem(
                icon: Symbols.policy,
                title: "Gizlilik Politikası",
                onTap: () {},
              ),
            ]),

            const SizedBox(height: 30),

            // --- Çıkış Yap / Sil Butonları ---
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
            const SizedBox(height: 100), // Navbar'ın arkasında kalmasın diye boşluk
          ],
        ),
      ),
    );
  }

  // --- Yardımcı Widgetlar ---

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
            backgroundImage: NetworkImage("https://i.pravatar.cc/300"), // Mock Avatar
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