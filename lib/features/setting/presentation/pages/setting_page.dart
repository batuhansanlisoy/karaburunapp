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
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      // Padding'i HomePage'deki gibi horizontal: 12 seviyesine çekerek dış çerçeveyi genişlettik
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Uygulama Bilgileri"),
          _buildSettingsCard([
            _buildStaticItem(
              icon: Symbols.notifications_rounded,
              title: "Bildirimler",
              subtitle: "Bildirimler şu an aktif",
            ),
            _buildStaticItem(
              icon: Symbols.dark_mode_rounded,
              title: "Tema",
              subtitle: "Açık tema kullanılıyor",
            ),
            _buildStaticItem(
              icon: Symbols.distance_rounded,
              title: "Mesafe Birimi",
              subtitle: "Mesafeler metre cinsinden hesaplanır",
            ),
          ]),
          const SizedBox(height: 25),
          _buildSectionTitle("Destek & İş Birliği"),
          _buildSettingsCard([
            _buildExpansionAbout(),
            _buildExpansionPrivacy(),
            _buildSettingItem(
              icon: Symbols.handshake_rounded,
              title: "Partner Ol",
              subtitle: "İşletmeni KaraburunGO'ya ekle",
              onTap: () => _launchAction("${ApiRoutes.request}/business/form"),
            ),
            _buildSettingItem(
              icon: Symbols.mail_rounded,
              title: "Geri Bildirim Gönder",
              subtitle: "Hata bildir veya öneri yap",
              onTap: () => _launchAction("${ApiRoutes.feedback}/form"),
            ),
          ]),
          const SizedBox(height: 25),
          _buildSectionTitle("Sosyal Medya & İletişim"),
          _buildSettingsCard([
            _buildSettingItem(
              icon: Symbols.share_rounded,
              title: "Instagram",
              subtitle: "@karaburungo",
              onTap: () => _launchAction("https://www.instagram.com/karaburungo/"),
            ),
            _buildSettingItem(
              icon: Symbols.alternate_email_rounded,
              title: "E-Posta",
              subtitle: "batuhan.sanlisoy@hotmail.com",
              onTap: () => _launchAction("mailto:batuhan.sanlisoy@hotmail.com"),
            ),
            _buildSettingItem(
              icon: Symbols.call_rounded,
              title: "İletişim Hattı 1",
              subtitle: "0535 045 47 51",
              onTap: () => _launchAction("tel:05350454751"),
            ),
            _buildSettingItem(
              icon: Symbols.phone_forwarded_rounded,
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
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 70),
        ],
      ),
    );
  }

  // --- Yardımcı Başlık ve Kart Tasarımları Güncellendi ---
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12, 
          fontWeight: FontWeight.bold, 
          color: AppColors.textDark,
          letterSpacing: 1.1
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .02), 
            blurRadius: 10, 
            offset: const Offset(0, 4)
          )
        ],
      ),
      child: Column(children: items),
    );
  }

  // --- İçerik Elemanları (Aynen Korundu, Sadece Uyum Sağlandı) ---
  Widget _buildExpansionAbout() {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: _buildIconContainer(
          Symbols.info_rounded,
          const Color(0xFF475569)
        ),
        title: const Text(
          "KaraburunGO Hakkında",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: AppColors.textDark
          )
        ),
        children: const [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Text(
              "KaraburunGO, Yarımada’nın dijital kalbi ve en kapsamlı yaşam rehberidir. "
              "Keşfedilmeyi bekleyen gizli koylardan en güncel yerel etkinliklere kadar, "
              "Karaburun’a dair ne varsa tek bir dokunuşla cebinize getiriyoruz.",
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textMain,
                height: 1.8
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionPrivacy() {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: _buildIconContainer(
          Symbols.policy_rounded,
          const Color(0xFF475569)
        ),
        title: const Text(
          "Gizlilik Politikası",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: AppColors.textDark
          )
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
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

  Widget _buildPrivacyText(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textOrange
          )
        ),
        Text(
          content,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textMain,
            height: 1.8
          )
        ),
      ],
    );
  }

  Widget _buildIconContainer(IconData icon, Color color) {
    return Icon(
      icon,
      color: color,
      size: 22,
      fill: 1.0,
      weight: 700,
      grade: 0,
      opticalSize: 24,
    );
  }

  Widget _buildStaticItem({required IconData icon, required String title, required String subtitle}) {
    return ListTile(
      leading: _buildIconContainer(icon, const Color(0xFF475569)),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: AppColors.textDark
        )
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textMain
        )
      ),
    );
  }

  Widget _buildSettingItem({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: _buildIconContainer(
        icon,
        const Color(0xFF475569)
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: AppColors.textDark
        )
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textMain
        )
      ),
      trailing: const Icon(
        Symbols.chevron_forward,
        size: 20,
        color: Colors.grey
      ),
    );
  }
}