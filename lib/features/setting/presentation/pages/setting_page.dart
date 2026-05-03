import 'package:flutter/material.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:material_symbols_icons/symbols.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // Genel URL ve Aksiyon Başlatıcı
  Future<void> _launchAction(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Açılama hatası: $urlString';
      }
    } catch (e) {
      debugPrint("Hata: $e");
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
            const SizedBox(height: 20),
            _buildSectionTitle("Uygulama Bilgileri"),
            _buildSettingsCard([
              _buildStaticItem(
                icon: Symbols.notifications,
                title: "Bildirimler",
                subtitle: "Bildirimler şu an aktif",
              ),
              _buildStaticItem(
                icon: Symbols.dark_mode,
                title: "Tema",
                subtitle: "Açık tema kullanılıyor",
              ),
              _buildStaticItem(
                icon: Symbols.distance,
                title: "Mesafe Birimi",
                subtitle: "Mesafeler metre cinsinden hesaplanır",
              ),
            ]),
            const SizedBox(height: 20),
            _buildSectionTitle("Destek & İş Birliği"),
            _buildSettingsCard([
              _buildExpansionAbout(),
              _buildExpansionPrivacy(),
              _buildSettingItem(
                icon: Symbols.handshake,
                title: "Partner Ol",
                subtitle: "İşletmeni KaraburunGO'ya ekle",
                onTap: () => _launchAction("${ApiRoutes.baseUrl}/request/business/form"),
              ),
              _buildSettingItem(
                icon: Symbols.mail,
                title: "Geri Bildirim Gönder",
                subtitle: "Hata bildir veya öneri yap",
                onTap: () => _launchAction("${ApiRoutes.baseUrl}/feedback/form"),
              ),
            ]),
            const SizedBox(height: 20),
            _buildSectionTitle("Sosyal Medya & İletişim"),
            _buildSettingsCard([
              _buildSettingItem(
                icon: Symbols.share,
                title: "Instagram",
                subtitle: "@karaburungo",
                onTap: () => _launchAction("https://www.instagram.com/karaburungo/"),
              ),
              _buildSettingItem(
                icon: Symbols.alternate_email,
                title: "E-Posta",
                subtitle: "batuhan.sanlisoy@hotmail.com",
                onTap: () => _launchAction("mailto:batuhan.sanlisoy@hotmail.com"),
              ),
              _buildSettingItem(
                icon: Symbols.call,
                title: "İletişim Hattı 1",
                subtitle: "0535 045 47 51",
                onTap: () => _launchAction("tel:05350454751"),
              ),
              _buildSettingItem(
                icon: Symbols.call,
                title: "İletişim Hattı 2",
                subtitle: "0535 060 48 36",
                onTap: () => _launchAction("tel:05350604836"),
              ),
            ]),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  "Versiyon 1.0.0+1",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted, // Mevcut renk paletine sadık kaldık
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }

  // --- Hakkında Bölümü ---
  Widget _buildExpansionAbout() {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: _buildIconContainer(Symbols.info, const Color(0xFF475569)),
        title: const Text("KaraburunGO Hakkında", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        children: const [
          Padding(
            padding: EdgeInsets.fromLTRB(70, 0, 20, 20),
            child: Text(
              "KaraburunGO, Yarımada’nın dijital kalbi ve en kapsamlı yaşam rehberidir. "
              "Keşfedilmeyi bekleyen gizli koylardan en güncel yerel etkinliklere kadar, "
              "Karaburun’a dair ne varsa tek bir dokunuşla cebinize getiriyoruz.",
              style: TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // --- Gizlilik Politikası Bölümü ---
  Widget _buildExpansionPrivacy() {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: _buildIconContainer(Symbols.policy, const Color(0xFF475569)),
        title: const Text("Gizlilik Politikası", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 20),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPrivacyText("1. GENEL BİLGİLENDİRME", "KaraburunGO, verilerinizin güvenliği için tasarlanmış bir rehber uygulamasıdır."),
                  const SizedBox(height: 10),
                  _buildPrivacyText("2. CİHAZ İZİNLERİ", "• Konum: GPS verisi toplanmaz.\n• Kamera: Erişim gerekmez."),
                  const SizedBox(height: 10),
                  _buildPrivacyText("3. YEREL SAKLAMA", "Favorileriniz sadece cihazınızda saklanır."),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Yardımcı Widgetlar ---
  Widget _buildPrivacyText(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange)),
        Text(content, style: const TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.4)),
      ],
    );
  }

  Widget _buildIconContainer(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueGrey, letterSpacing: 1.1),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> items) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(children: items),
    );
  }

  Widget _buildStaticItem({required IconData icon, required String title, required String subtitle}) {
    return ListTile(
      leading: _buildIconContainer(icon, const Color(0xFF94A3B8)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black87)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    );
  }

  Widget _buildSettingItem({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: _buildIconContainer(icon, const Color(0xFF475569)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Symbols.chevron_forward, size: 20, color: Colors.grey),
    );
  }
}