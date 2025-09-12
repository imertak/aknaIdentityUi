// screens/main_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_type.dart';
import '../providers/user_data_provider.dart';

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({Key? key}) : super(key: key);

  @override
  _MainDashboardScreenState createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

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
    return SafeArea(
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
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Merhaba, ${Provider.of<UserDataProvider>(context).userName}',
                style: TextStyle(
                  color: Color(0xFF2D3748),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Hoş geldiniz!',
                style: TextStyle(
                  color: Color(0xFF718096),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined),
                iconSize: 28,
                color: Color(0xFF2D3748),
                onPressed: () {
                  setState(() {
                    _isNotificationRead = true;
                  });
                  _showNotifications();
                },
              ),
              if (!_isNotificationRead)
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _buildStatCard(Icons.local_shipping_outlined, '12', 'Aktif Sevkiyat'),
          SizedBox(width: 10),
          _buildStatCard(
            Icons.account_balance_wallet_outlined,
            '₺24.5K',
            'Bu Ay',
          ),
          SizedBox(width: 10),
          _buildStatCard(Icons.star_outline, '4.8', 'Puan'),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Color(0xFF2D3748)),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: Color(0xFF2D3748),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: Color(0xFF718096), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTypeDashboard() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hızlı İşlemler',
            style: TextStyle(
              color: Color(0xFF2D3748),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          _buildActionGrid(),
        ],
      ),
    );
  }

  Widget _buildActionGrid() {
    List<Map<String, dynamic>> actions = _getActionsByUserType();

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.5,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        return _buildActionCard(
          icon: actions[index]['icon'],
          title: actions[index]['title'],
          color: actions[index]['color'],
          onTap: () {},
        );
      },
    );
  }

  List<Map<String, dynamic>> _getActionsByUserType() {
    final userType =
        Provider.of<UserDataProvider>(context, listen: false).userType;
    return switch (userType) {
      UserType.shipper => [
        {
          'icon': Icons.add_box_outlined,
          'title': 'Yeni Sevkiyat',
          'color': Colors.blue,
        },
        {
          'icon': Icons.local_shipping_outlined,
          'title': 'Taşımalarım',
          'color': Colors.green,
        },
        {'icon': Icons.history, 'title': 'Geçmiş', 'color': Colors.orange},
        {
          'icon': Icons.account_balance_wallet_outlined,
          'title': 'Ödemeler',
          'color': Colors.purple,
        },
      ],
      UserType.carrier => [
        {
          'icon': Icons.search_outlined,
          'title': 'İş Bul',
          'color': Colors.blue,
        },
        {
          'icon': Icons.work_outline,
          'title': 'Aktif İşler',
          'color': Colors.green,
        },
        {
          'icon': Icons.directions_car_outlined,
          'title': 'Araçlar',
          'color': Colors.orange,
        },
        {
          'icon': Icons.account_balance_wallet_outlined,
          'title': 'Finansal',
          'color': Colors.purple,
        },
      ],
      UserType.driver => [
        {
          'icon': Icons.assignment_outlined,
          'title': 'Görevler',
          'color': Colors.blue,
        },
        {
          'icon': Icons.navigation_outlined,
          'title': 'Navigasyon',
          'color': Colors.green,
        },
        {'icon': Icons.history, 'title': 'Geçmiş', 'color': Colors.orange},
        {
          'icon': Icons.person_outline,
          'title': 'Profil',
          'color': Colors.purple,
        },
      ],
    };
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Color(0xFF2D3748),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Son Aktiviteler',
            style: TextStyle(
              color: Color(0xFF2D3748),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          _buildActivityItem(
            'Yeni Sipariş',
            'Sipariş #1234 oluşturuldu',
            '2 saat önce',
            Icons.local_shipping,
            Colors.blue,
          ),
          _buildActivityItem(
            'Ödeme Alındı',
            'Sipariş #1233 için ödeme alındı',
            '5 saat önce',
            Icons.payment,
            Colors.green,
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Color(0xFF718096), fontSize: 14),
                ),
              ],
            ),
          ),
          Text(time, style: TextStyle(color: Color(0xFF718096), fontSize: 12)),
        ],
      ),
    );
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Bildirimler',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildNotificationItem(
                  'Yeni sipariş talebi',
                  'Sipariş #1234 için teklif verildi',
                  '2 saat önce',
                ),
                _buildNotificationItem(
                  'Ödeme alındı',
                  'Sipariş #1233 ödemesi hesabınıza geçti',
                  '5 saat önce',
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildNotificationItem(String title, String message, String time) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: Icon(Icons.notifications_none, color: Colors.blue),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
                Text(
                  message,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          Text(time, style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
