// account_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/user_data_provider.dart';
import '../components/custom_bottom_navigation.dart';

class AccountScreen extends StatefulWidget {
  final String userName;
  final String userType;

  const AccountScreen({
    Key? key,
    required this.userName,
    required this.userType,
  }) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutQuart),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<NavigationProvider, UserDataProvider>(
      builder: (context, navigationProvider, userDataProvider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: CustomScrollView(
                  slivers: [
                    _buildSliverAppBar(),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          _buildProfileSection(),
                          _buildAccountSection(),
                          _buildNotificationSection(),
                          _buildAppearanceSection(),
                          _buildSecuritySection(),
                          _buildSupportSection(),
                          _buildDangerZone(),
                          SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: CustomBottomNavigation(
            selectedIndex: navigationProvider.selectedIndex,
            onItemSelected: _handleBottomNavTap,
            userType: widget.userType,
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      expandedHeight: 280,
      floating: false,
      pinned: true,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFE2E8F0)),
          ),
          child: Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF4A5568),
            size: 20,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60),
                Hero(
                  tag: 'user_avatar',
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2D3748), Color(0xFF4A5568)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF2D3748).withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        widget.userName[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  widget.userName,
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFF2D3748).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Color(0xFF2D3748).withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    _getUserTypeLabel(),
                    style: TextStyle(
                      color: Color(0xFF2D3748),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        title: Text(
          'Hesap Ayarları',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
    );
  }

  Widget _buildProfileSection() {
    return _buildSection('Profil Bilgileri', Icons.person_rounded, [
      _buildMenuItem(
        'Kişisel Bilgiler',
        'Ad, soyad, telefon ve e-posta',
        Icons.person_outline_rounded,
        () => _navigateToPersonalInfo(),
      ),
      _buildMenuItem(
        'Adres Bilgileri',
        'Fatura ve teslimat adresleri',
        Icons.location_on_outlined,
        () => _navigateToAddresses(),
      ),
      if (widget.userType == 'Carrier' || widget.userType == 'Driver')
        _buildMenuItem(
          'Belge Yönetimi',
          'Sürücü belgesi, ruhsat, sigorta',
          Icons.description_outlined,
          () => _navigateToDocuments(),
        ),
      if (widget.userType == 'Carrier')
        _buildMenuItem(
          'Filo Yönetimi',
          'Araç ve sürücü bilgileri',
          Icons.local_shipping_outlined,
          () => _navigateToFleetManagement(),
        ),
    ]);
  }

  Widget _buildAccountSection() {
    return _buildSection('Hesap Yönetimi', Icons.account_circle_rounded, [
      _buildMenuItem(
        'Ödeme Yöntemleri',
        'Kredi kartı ve banka hesapları',
        Icons.payment_rounded,
        () => _navigateToPaymentMethods(),
      ),
      _buildMenuItem(
        'Fatura Geçmişi',
        'Ödemeler ve faturalar',
        Icons.receipt_long_rounded,
        () => _navigateToInvoiceHistory(),
      ),
      _buildMenuItem(
        'Abonelik & Paketler',
        'Mevcut paket ve yükseltme seçenekleri',
        Icons.star_rounded,
        () => _navigateToSubscription(),
      ),
      _buildMenuItem(
        'Referanslar',
        'Arkadaş davet et, puan kazan',
        Icons.share_rounded,
        () => _navigateToReferrals(),
      ),
    ]);
  }

  Widget _buildNotificationSection() {
    return _buildSection('Bildirim Ayarları', Icons.notifications_rounded, [
      _buildSwitchMenuItem(
        'Push Bildirimleri',
        'Uygulama bildirimleri',
        Icons.notifications_active_rounded,
        _notificationsEnabled,
        (value) => setState(() => _notificationsEnabled = value),
      ),
      _buildSwitchMenuItem(
        'E-posta Bildirimleri',
        'Önemli güncellemeler için e-posta',
        Icons.email_rounded,
        _emailNotifications,
        (value) => setState(() => _emailNotifications = value),
      ),
      _buildSwitchMenuItem(
        'SMS Bildirimleri',
        'Acil durumlar için SMS',
        Icons.sms_rounded,
        _smsNotifications,
        (value) => setState(() => _smsNotifications = value),
      ),
      _buildMenuItem(
        'Bildirim Zamanları',
        'Hangi saatlerde bildirim alacağınızı ayarlayın',
        Icons.access_time_rounded,
        () => _navigateToNotificationSchedule(),
      ),
    ]);
  }

  Widget _buildAppearanceSection() {
    return _buildSection('Görünüm', Icons.palette_rounded, [
      _buildSwitchMenuItem(
        'Karanlık Tema',
        'Gece modunu kullan',
        Icons.dark_mode_rounded,
        _darkMode,
        (value) => setState(() => _darkMode = value),
      ),
      _buildMenuItem(
        'Dil Seçimi',
        'Türkçe',
        Icons.language_rounded,
        () => _showLanguageDialog(),
      ),
    ]);
  }

  Widget _buildSecuritySection() {
    return _buildSection('Güvenlik', Icons.security_rounded, [
      _buildMenuItem(
        'Şifre Değiştir',
        'Hesap şifrenizi güncelleyin',
        Icons.lock_outline_rounded,
        () => _navigateToChangePassword(),
      ),
      _buildMenuItem(
        'İki Faktörlü Doğrulama',
        'Ekstra güvenlik katmanı',
        Icons.verified_user_rounded,
        () => _navigateToTwoFactorAuth(),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xFF38A169).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF38A169).withOpacity(0.2)),
          ),
          child: Text(
            'Aktif',
            style: TextStyle(
              color: Color(0xFF38A169),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      _buildMenuItem(
        'Gizlilik Ayarları',
        'Veri kullanımı ve gizlilik',
        Icons.privacy_tip_rounded,
        () => _navigateToPrivacySettings(),
      ),
      _buildMenuItem(
        'Oturum Geçmişi',
        'Aktif oturumları yönet',
        Icons.devices_rounded,
        () => _navigateToSessionHistory(),
      ),
    ]);
  }

  Widget _buildSupportSection() {
    return _buildSection('Yardım & Destek', Icons.help_rounded, [
      _buildMenuItem(
        'Sık Sorulan Sorular',
        'Yaygın soruların cevapları',
        Icons.quiz_rounded,
        () => _navigateToFAQ(),
      ),
      _buildMenuItem(
        'Canlı Destek',
        '7/24 müşteri hizmetleri',
        Icons.chat_rounded,
        () => _navigateToLiveChat(),
        trailing: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Color(0xFF38A169),
            shape: BoxShape.circle,
          ),
        ),
      ),
      _buildMenuItem(
        'Geri Bildirim Gönder',
        'Önerilerinizi paylaşın',
        Icons.feedback_rounded,
        () => _navigateToFeedback(),
      ),
      _buildMenuItem(
        'Uygulama Hakkında',
        'Sürüm ve yasal bilgiler',
        Icons.info_rounded,
        () => _navigateToAbout(),
      ),
    ]);
  }

  Widget _buildDangerZone() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Color(0xFFE53E3E).withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Color(0xFFE53E3E).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Color(0xFFE53E3E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.warning_rounded,
                    color: Color(0xFFE53E3E),
                    size: 18,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Tehlikeli İşlemler',
                  style: TextStyle(
                    color: Color(0xFFE53E3E),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          _buildMenuItem(
            'Hesabı Geçici Olarak Dondur',
            'Hesabınızı geçici olarak devre dışı bırakın',
            Icons.pause_circle_outline_rounded,
            () => _showFreezeAccountDialog(),
            textColor: Color(0xFFED8936),
            showDivider: true,
          ),
          _buildMenuItem(
            'Hesabı Sil',
            'Tüm verileriniz kalıcı olarak silinecek',
            Icons.delete_forever_rounded,
            () => _showDeleteAccountDialog(),
            textColor: Color(0xFFE53E3E),
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Color(0xFF2D3748).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Color(0xFF2D3748).withOpacity(0.2),
                    ),
                  ),
                  child: Icon(icon, color: Color(0xFF2D3748), size: 18),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    Widget? trailing,
    Color? textColor,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(0xFF718096).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: Color(0xFF718096), size: 18),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: textColor ?? Color(0xFF2D3748),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Color(0xFF718096),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (trailing != null) ...[SizedBox(width: 16), trailing],
                ],
              ),
            ),
          ),
        ),
        if (showDivider && textColor == null)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            height: 1,
            color: Color(0xFFE2E8F0),
          ),
      ],
    );
  }

  Widget _buildSwitchMenuItem(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Color(0xFF718096).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Color(0xFF718096), size: 18),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Color(0xFF2D3748),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Color(0xFF718096), fontSize: 14),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Color(0xFF38A169),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          height: 1,
          color: Color(0xFFE2E8F0),
        ),
      ],
    );
  }

  void _handleBottomNavTap(int index) {
    final navigationProvider = Provider.of<NavigationProvider>(
      context,
      listen: false,
    );
    navigationProvider.setIndex(index);

    if (index != 4) {
      // Don't navigate if already on account screen
      Navigator.pushReplacementNamed(
        context,
        index == 0
            ? '/dashboard'
            : index == 1
            ? (widget.userType == "Carrier" || widget.userType == "Driver"
                ? '/jobs'
                : '/shipments')
            : index == 2
            ? '/search'
            : index == 3
            ? (widget.userType == "Carrier"
                ? '/vehicles'
                : widget.userType == "Driver"
                ? '/route'
                : '/shipment-history')
            : '/account',
      );
    }
  }

  String _getUserTypeLabel() {
    switch (widget.userType) {
      case "Carrier":
        return "Taşıyıcı";
      case "Driver":
        return "Sürücü";
      case "Shipper":
        return "Yükleyici";
      default:
        return "Kullanıcı";
    }
  }

  // Dialog Methods
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Dil Seçimi',
              style: TextStyle(
                color: Color(0xFF2D3748),
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: Text(
                    'Türkçe',
                    style: TextStyle(color: Color(0xFF2D3748)),
                  ),
                  value: 'tr',
                  groupValue: 'tr',
                  activeColor: Color(0xFF2D3748),
                  onChanged: (value) => Navigator.pop(context),
                ),
                RadioListTile<String>(
                  title: Text(
                    'English',
                    style: TextStyle(color: Color(0xFF2D3748)),
                  ),
                  value: 'en',
                  groupValue: 'tr',
                  activeColor: Color(0xFF2D3748),
                  onChanged: (value) => Navigator.pop(context),
                ),
              ],
            ),
          ),
    );
  }

  void _showFreezeAccountDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Hesabı Dondur',
              style: TextStyle(
                color: Color(0xFFED8936),
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Text(
              'Hesabınızı geçici olarak dondurmak istediğinizden emin misiniz? Bu işlem geri alınabilir.',
              style: TextStyle(color: Color(0xFF2D3748)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'İptal',
                  style: TextStyle(color: Color(0xFF718096)),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFED8936),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Dondur', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Hesabı Sil',
              style: TextStyle(
                color: Color(0xFFE53E3E),
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bu işlem geri alınamaz!',
                  style: TextStyle(
                    color: Color(0xFFE53E3E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Hesabınızı sildiğinizde:\n• Tüm verileriniz kalıcı olarak silinir\n• Aktif işleriniz iptal edilir\n• Ödeme geçmişiniz silinir',
                  style: TextStyle(color: Color(0xFF2D3748)),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'İptal',
                  style: TextStyle(color: Color(0xFF718096)),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE53E3E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Hesabı Sil',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  // Navigation Methods
  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature özelliği yakında geliyor!'),
        backgroundColor: Color(0xFF2D3748),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  void _navigateToPersonalInfo() => _showComingSoon('Kişisel Bilgiler');
  void _navigateToAddresses() => _showComingSoon('Adres Bilgileri');
  void _navigateToDocuments() => _showComingSoon('Belge Yönetimi');
  void _navigateToFleetManagement() => _showComingSoon('Filo Yönetimi');
  void _navigateToPaymentMethods() => _showComingSoon('Ödeme Yöntemleri');
  void _navigateToInvoiceHistory() => _showComingSoon('Fatura Geçmişi');
  void _navigateToSubscription() => _showComingSoon('Abonelik & Paketler');
  void _navigateToReferrals() => _showComingSoon('Referanslar');
  void _navigateToNotificationSchedule() =>
      _showComingSoon('Bildirim Zamanları');
  void _navigateToChangePassword() => _showComingSoon('Şifre Değiştir');
  void _navigateToTwoFactorAuth() => _showComingSoon('İki Faktörlü Doğrulama');
  void _navigateToPrivacySettings() => _showComingSoon('Gizlilik Ayarları');
  void _navigateToSessionHistory() => _showComingSoon('Oturum Geçmişi');
  void _navigateToFAQ() => _showComingSoon('SSS');
  void _navigateToLiveChat() => _showComingSoon('Canlı Destek');
  void _navigateToFeedback() => _showComingSoon('Geri Bildirim');
  void _navigateToAbout() => _showComingSoon('Hakkında');
}
