// screens/main_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';

import 'accountScreen.dart';
import 'carrierJobsScreen.dart';
import 'createShipmentScreen.dart';
import 'invoicesScreen.dart';
import 'shipmentHistoryScreen.dart';
import 'vehiclesManagementScreen.dart';

class MainDashboardScreen extends StatefulWidget {
  final String userType; // 'Shipper', 'Carrier', 'Driver'
  final String userName;

  const MainDashboardScreen({
    Key? key,
    required this.userType,
    required this.userName,
  }) : super(key: key);

  @override
  _MainDashboardScreenState createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  int _selectedBottomNavIndex = 0;
  bool _isNotificationRead = false;

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          backgroundColor: Colors.white,
          color: Color(0xFF2D3748),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildQuickStats(),
                    _buildUserTypeDashboard(),
                    _buildRecentActivity(),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // Refresh data here
    });
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
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
      child: Column(
        children: [
          Row(
            children: [
              Hero(
                tag: 'user_avatar',
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2D3748), Color(0xFF4A5568)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.userName[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: TextStyle(
                        color: Color(0xFF718096),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.userName,
                      style: TextStyle(
                        color: Color(0xFF2D3748),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildHeaderButton(
                    icon: Icons.notifications_none_rounded,
                    onTap: _showNotifications,
                    hasNotification: !_isNotificationRead,
                  ),
                  SizedBox(width: 12),
                  _buildHeaderButton(
                    icon: Icons.more_vert_rounded,
                    onTap: _showProfileMenu,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required VoidCallback onTap,
    bool hasNotification = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Color(0xFFE2E8F0), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(child: Icon(icon, color: Color(0xFF4A5568), size: 22)),
            if (hasNotification)
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Color(0xFF3182CE),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF3182CE).withOpacity(0.3),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        style: TextStyle(color: Color(0xFF2D3748)),
        decoration: InputDecoration(
          hintText: _getSearchHint(),
          hintStyle: TextStyle(
            color: Color(0xFF718096),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Color(0xFF718096),
            size: 22,
          ),
          suffixIcon: Container(
            margin: EdgeInsets.all(6),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF2D3748),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(Icons.tune_rounded, color: Colors.white, size: 20),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('12', 'Aktif\nSevkiyat', Color(0xFF3182CE)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('₺24.5K', 'Bu Ay\nKazanç', Color(0xFF38A169)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('4.8', 'Ortalama\nPuan', Color(0xFFED8936)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color accentColor) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
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
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 14),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF2D3748),
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF718096),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTypeDashboard() {
    return Container(
      margin: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getDashboardTitle(),
                style: TextStyle(
                  color: Color(0xFF2D3748),
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFFF7FAFC),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    'Tümünü Gör',
                    style: TextStyle(
                      color: Color(0xFF4A5568),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _getDashboardContent(),
        ],
      ),
    );
  }

  Widget _getDashboardContent() {
    switch (widget.userType) {
      case 'Shipper':
        return _buildShipperContent();
      case 'Carrier':
        return _buildCarrierContent();
      case 'Driver':
        return _buildDriverContent();
      default:
        return _buildDefaultContent();
    }
  }

  Widget _buildShipperContent() {
    return Column(
      children: [
        _buildServiceCard(
          'Yeni Sevkiyat Oluştur',
          'Hızlı ve güvenli gönderim',
          Icons.add_box_rounded,
          Color(0xFF3182CE),
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateShipmentScreen()),
            );
          },
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildServiceCard(
                'Sevkiyat Takip',
                'Anlık konum',
                Icons.local_shipping_rounded,
                Color(0xFF38A169),
                () {},
                isCompact: true,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildServiceCard(
                'Faturalar',
                'Ödeme geçmişi',
                Icons.receipt_rounded,
                Color(0xFFED8936),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              InvoicesScreen(userName: widget.userName),
                    ),
                  );
                },
                isCompact: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCarrierContent() {
    return Column(
      children: [
        _buildServiceCard(
          'Yeni İş Ara',
          'Size uygun yükler bulun',
          Icons.search_rounded,
          Color(0xFF3182CE),
          () {},
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildServiceCard(
                'Aktif İşler',
                '5 aktif taşıma',
                Icons.work_outline_rounded,
                Color(0xFF38A169),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              CarrierJobsScreen(userName: widget.userName),
                    ),
                  );
                },
                isCompact: true,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildServiceCard(
                'Araçlarım',
                'Filo yönetimi',
                Icons.local_shipping_rounded,
                Color(0xFFED8936),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VehiclesManagementScreen(),
                    ),
                  );
                },
                isCompact: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDriverContent() {
    return Column(
      children: [
        _buildServiceCard(
          'Günlük Görevler',
          '2 teslimat bekliyor',
          Icons.assignment_rounded,
          Color(0xFF3182CE),
          () {},
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildServiceCard(
                'Navigasyon',
                'Rota planla',
                Icons.map_rounded,
                Color(0xFF38A169),
                () {},
                isCompact: true,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildServiceCard(
                'Geçmiş',
                'Tamamlanan',
                Icons.history_rounded,
                Color(0xFFED8936),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              ShipmentHistoryScreen(userName: widget.userName),
                    ),
                  );
                },
                isCompact: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDefaultContent() {
    return _buildServiceCard(
      'AKNA\'ya Hoş Geldiniz',
      'Profil ayarlarınızı tamamlayın',
      Icons.person_rounded,
      Color(0xFF3182CE),
      () {},
    );
  }

  Widget _buildServiceCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    bool isCompact = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isCompact ? 20 : 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isCompact ? 20 : 24),
          border: Border.all(color: Color(0xFFE2E8F0), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child:
            isCompact
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: color.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(icon, color: color, size: 20),
                    ),
                    SizedBox(height: 16),
                    Text(
                      title,
                      style: TextStyle(
                        color: Color(0xFF2D3748),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Color(0xFF718096),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
                : Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: color.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(icon, color: color, size: 26),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: Color(0xFF2D3748),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Color(0xFF718096),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Color(0xFFF7FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Color(0xFFE2E8F0)),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color(0xFF718096),
                        size: 16,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Son Aktiviteler',
            style: TextStyle(
              color: Color(0xFF2D3748),
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Color(0xFFE2E8F0), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildActivityItem(
                  'Sevkiyat teslim edildi',
                  'İstanbul → Ankara',
                  '2 saat önce',
                  Icons.check_circle_rounded,
                  Color(0xFF38A169),
                ),
                Divider(height: 1, color: Color(0xFFE2E8F0)),
                _buildActivityItem(
                  'Yeni iş teklifi',
                  'Ankara → İzmir',
                  '4 saat önce',
                  Icons.work_outline_rounded,
                  Color(0xFF3182CE),
                ),
                Divider(height: 1, color: Color(0xFFE2E8F0)),
                _buildActivityItem(
                  'Ödeme alındı',
                  '₺2.450',
                  '1 gün önce',
                  Icons.payment_rounded,
                  Color(0xFFED8936),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    String title,
    String subtitle,
    String time,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withOpacity(0.2), width: 1),
            ),
            child: Icon(icon, color: color, size: 20),
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
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.1,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Color(0xFF718096),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildBottomNavItems(),
        ),
      ),
    );
  }

  List<Widget> _buildBottomNavItems() {
    switch (widget.userType) {
      case 'Shipper':
        return [
          _buildNavItem(Icons.home_rounded, 0),
          _buildNavItem(Icons.local_shipping_rounded, 1),
          _buildNavItem(Icons.add_rounded, 2, isCenter: true),
          _buildNavItem(Icons.receipt_rounded, 3),
          _buildNavItem(Icons.person_rounded, 4),
        ];
      case 'Carrier':
        return [
          _buildNavItem(Icons.home_rounded, 0),
          _buildNavItem(Icons.work_outline_rounded, 1),
          _buildNavItem(Icons.search_rounded, 2, isCenter: true),
          _buildNavItem(Icons.local_shipping_rounded, 3),
          _buildNavItem(Icons.person_rounded, 4),
        ];
      case 'Driver':
        return [
          _buildNavItem(Icons.home_rounded, 0),
          _buildNavItem(Icons.map_rounded, 1),
          _buildNavItem(Icons.assignment_rounded, 2, isCenter: true),
          _buildNavItem(Icons.history_rounded, 3),
          _buildNavItem(Icons.person_rounded, 4),
        ];
      default:
        return [
          _buildNavItem(Icons.home_rounded, 0),
          _buildNavItem(Icons.search_rounded, 1),
          _buildNavItem(Icons.add_rounded, 2, isCenter: true),
          _buildNavItem(Icons.favorite_rounded, 3),
          _buildNavItem(Icons.person_rounded, 4),
        ];
    }
  }

  Widget _buildNavItem(IconData icon, int index, {bool isCenter = false}) {
    bool isSelected = _selectedBottomNavIndex == index;

    if (isCenter) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedBottomNavIndex = index;
          });
          _handleBottomNavTap(index);
        },
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Color(0xFF1A1A1A), size: 28),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBottomNavIndex = index;
        });
        _handleBottomNavTap(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? Colors.white.withOpacity(0.2)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color:
                    isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                size: 24,
              ),
            ),
            if (isSelected)
              Container(
                margin: EdgeInsets.only(top: 4),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleBottomNavTap(int index) {
    switch (widget.userType) {
      case 'Shipper':
        switch (index) {
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        ShipmentHistoryScreen(userName: widget.userName),
              ),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateShipmentScreen()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InvoicesScreen(userName: widget.userName),
              ),
            );
            break;
          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => AccountScreen(
                      userName: widget.userName,
                      userType: widget.userType,
                    ),
              ),
            );
        }
        break;
      case 'Carrier':
        switch (index) {
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => CarrierJobsScreen(userName: widget.userName),
              ),
            );
            break;
          case 2:
            // İş Ara sayfası
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VehiclesManagementScreen(),
              ),
            );
            break;
          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => AccountScreen(
                      userName: widget.userName,
                      userType: widget.userType,
                    ),
              ),
            );
        }
        break;
      case 'Driver':
        switch (index) {
          case 1:
            // Harita sayfası
            break;
          case 2:
            // Görevler sayfası
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        ShipmentHistoryScreen(userName: widget.userName),
              ),
            );
            break;
          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => AccountScreen(
                      userName: widget.userName,
                      userType: widget.userType,
                    ),
              ),
            );
        }
        break;
    }
  }

  void _showNotifications() {
    setState(() {
      _isNotificationRead = true;
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(color: Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Bildirimler',
                            style: TextStyle(
                              color: Color(0xFF2D3748),
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Color(0xFFF7FAFC),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Color(0xFFE2E8F0)),
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                color: Color(0xFF718096),
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      _buildNotificationCard(
                        'Sevkiyat Güncelleme',
                        'İstanbul → Ankara sevkiyatınız yola çıktı',
                        '2 saat önce',
                        Icons.local_shipping_rounded,
                        Color(0xFF3182CE),
                      ),
                      _buildNotificationCard(
                        'Yeni İş Fırsatı',
                        'Size uygun yeni bir iş bulundu',
                        '4 saat önce',
                        Icons.work_rounded,
                        Color(0xFF38A169),
                      ),
                      _buildNotificationCard(
                        'Ödeme Alındı',
                        'Son sevkiyat ücreti hesabınıza yatırıldı',
                        '1 gün önce',
                        Icons.payment_rounded,
                        Color(0xFFED8936),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildNotificationCard(
    String title,
    String message,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withOpacity(0.2), width: 1),
            ),
            child: Icon(icon, color: color, size: 20),
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
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.1,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  message,
                  style: TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Color(0xFF718096),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(color: Color(0xFFE2E8F0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 12, bottom: 20),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        'Profil Ayarları',
                        Icons.person_rounded,
                        () {},
                      ),
                      _buildMenuItem(
                        'Bildirim Ayarları',
                        Icons.notifications_rounded,
                        () {},
                      ),
                      _buildMenuItem('Güvenlik', Icons.security_rounded, () {}),
                      _buildMenuItem(
                        'Yardım & Destek',
                        Icons.help_rounded,
                        () {},
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        height: 1,
                        color: Color(0xFFE2E8F0),
                      ),
                      _buildMenuItem(
                        'Çıkış Yap',
                        Icons.logout_rounded,
                        () {},
                        isDestructive: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
    );
  }

  Widget _buildMenuItem(
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isDestructive
                    ? Color(0xFFE53E3E).withOpacity(0.2)
                    : Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color:
                    isDestructive
                        ? Color(0xFFE53E3E).withOpacity(0.1)
                        : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color:
                      isDestructive
                          ? Color(0xFFE53E3E).withOpacity(0.2)
                          : Color(0xFFE2E8F0),
                ),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Color(0xFFE53E3E) : Color(0xFF4A5568),
                size: 20,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isDestructive ? Color(0xFFE53E3E) : Color(0xFF2D3748),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.1,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFE2E8F0)),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFF718096),
                size: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Methods
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Günaydın';
    if (hour < 17) return 'İyi günler';
    return 'İyi akşamlar';
  }

  String _getSearchHint() {
    switch (widget.userType) {
      case 'Shipper':
        return 'Sevkiyat ara...';
      case 'Carrier':
        return 'İş ara...';
      case 'Driver':
        return 'Görev ara...';
      default:
        return 'Ara...';
    }
  }

  String _getDashboardTitle() {
    switch (widget.userType) {
      case 'Shipper':
        return 'Hızlı İşlemler';
      case 'Carrier':
        return 'İş Yönetimi';
      case 'Driver':
        return 'Günlük Görevler';
      default:
        return 'Başlayın';
    }
  }
}
