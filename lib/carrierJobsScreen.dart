// carrier_jobs_screen.dart - Modernized
import 'package:flutter/material.dart';

class CarrierJobsScreen extends StatefulWidget {
  final String userName;

  const CarrierJobsScreen({Key? key, required this.userName}) : super(key: key);

  @override
  _CarrierJobsScreenState createState() => _CarrierJobsScreenState();
}

class _CarrierJobsScreenState extends State<CarrierJobsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  int _selectedBottomNavIndex = 1; // Default to Jobs tab

  String _selectedFilter = 'Tümü';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

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
    _tabController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  String get value => '${widget.userName} - Taşıyıcı';

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Color(0xFF718096).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Color(0xFF718096), size: 14),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F7),
      bottomNavigationBar: _buildBottomNavigation(),
      body: SafeArea(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildHeader(),
                _buildFilterSection(),
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildActiveJobs(),
                      _buildPendingJobs(),
                      _buildCompletedJobs(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
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
              child: Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF2D3748),
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'İşlerim',
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Filtrele',
              style: TextStyle(
                color: Color(0xFF2D3748),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFilterOption('Tümü'),
                _buildFilterOption('Yüksek Ücret'),
                _buildFilterOption('Yakın Mesafe'),
                _buildFilterOption('Acil'),
              ],
            ),
          ),
    );
  }

  Widget _buildFilterOption(String option) {
    return RadioListTile<String>(
      title: Text(
        option,
        style: TextStyle(
          color: Color(0xFF2D3748),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      value: option,
      groupValue: _selectedFilter,
      activeColor: Color(0xFF2D3748),
      onChanged: (value) {
        setState(() {
          _selectedFilter = value!;
        });
        Navigator.pop(context);
      },
    );
  }

  Future<void> _refreshJobs() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  void _trackShipment(String jobId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$jobId takip ekranına yönlendiriliyor...'),
        backgroundColor: Color(0xFF2D3748),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  void _assignDriver(String jobId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$jobId için sürücü atama ekranına yönlendiriliyor...'),
        backgroundColor: Color(0xFF2D3748),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  void _viewJobDetails(String jobId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$jobId detay ekranına yönlendiriliyor...'),
        backgroundColor: Color(0xFF2D3748),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
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
          children: [
            _buildNavItem(Icons.home_rounded, 0),
            _buildNavItem(Icons.work_outline_rounded, 1),
            _buildNavItem(Icons.search_rounded, 2, isCenter: true),
            _buildNavItem(Icons.local_shipping_rounded, 3),
            _buildNavItem(Icons.person_rounded, 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, {bool isCenter = false}) {
    bool isSelected = _selectedBottomNavIndex == index;

    if (isCenter) {
      return GestureDetector(
        onTap: () => _handleBottomNavTap(index),
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
      onTap: () => _handleBottomNavTap(index),
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
    setState(() {
      _selectedBottomNavIndex = index;
    });

    switch (index) {
      case 0: // Home
        Navigator.pop(context);
        break;
      case 1: // Jobs
        // Already on jobs screen
        break;
      case 2: // Search
        // Navigate to search screen
        break;
      case 3: // Vehicles
        break;
      case 4: // Profile
        break;
    }
  }

  Widget _buildFilterSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Color(0xFF2D3748).withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Color(0xFF2D3748).withOpacity(0.2)),
            ),
            child: Icon(Icons.work_rounded, color: Color(0xFF2D3748), size: 18),
          ),
          SizedBox(width: 16),
          Text(
            'Toplam 12 aktif iş',
            style: TextStyle(
              color: Color(0xFF2D3748),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: _showFilterDialog,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                _selectedFilter,
                style: TextStyle(
                  color: Color(0xFF2D3748),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Color(0xFF2D3748),
          borderRadius: BorderRadius.circular(22),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Color(0xFF718096),
        labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        dividerColor: Colors.transparent,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_circle_outline_rounded, size: 18),
                SizedBox(width: 6),
                Text('Aktif'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.schedule_rounded, size: 18),
                SizedBox(width: 6),
                Text('Beklemede'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline_rounded, size: 18),
                SizedBox(width: 6),
                Text('Tamamlanan'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveJobs() {
    return RefreshIndicator(
      onRefresh: _refreshJobs,
      backgroundColor: Colors.white,
      color: Color(0xFF2D3748),
      child: ListView(
        padding: EdgeInsets.all(24),
        children: [
          _buildJobCard(
            jobId: 'AK2024001',
            from: 'İstanbul/Şişli',
            to: 'Ankara/Çankaya',
            cargo: 'Elektronik Eşya',
            weight: '2.5 ton',
            price: '3,500 ₺',
            status: 'Yolda',
            statusColor: Color(0xFFED8936),
            progress: 0.65,
            driverName: 'Mehmet Demir',
            estimatedTime: '4 saat',
            isActive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPendingJobs() {
    return RefreshIndicator(
      onRefresh: _refreshJobs,
      backgroundColor: Colors.white,
      color: Color(0xFF2D3748),
      child: ListView(
        padding: EdgeInsets.all(24),
        children: [
          _buildJobCard(
            jobId: 'AK2024004',
            from: 'Eskişehir/Odunpazarı',
            to: 'Konya/Selçuklu',
            cargo: 'Mobilya',
            weight: '4.5 ton',
            price: '5,800 ₺',
            status: 'Sürücü Bekliyor',
            statusColor: Color(0xFFED8936),
            isPending: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedJobs() {
    return RefreshIndicator(
      onRefresh: _refreshJobs,
      backgroundColor: Colors.white,
      color: Color(0xFF2D3748),
      child: ListView(
        padding: EdgeInsets.all(24),
        children: [
          _buildJobCard(
            jobId: 'AK2024006',
            from: 'Samsun/İlkadım',
            to: 'Trabzon/Ortahisar',
            cargo: 'Tarım Ürünleri',
            weight: '2.8 ton',
            price: '3,900 ₺',
            status: 'Teslim Edildi',
            statusColor: Color(0xFF38A169),
            isCompleted: true,
            completedDate: '2 gün önce',
            rating: 4.8,
          ),
        ],
      ),
    );
  }

  Widget _buildRoutePoint(String location, bool isStart) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isStart ? Color(0xFF38A169) : Color(0xFFE53E3E),
            shape: BoxShape.circle,
          ),
          child:
              !isStart
                  ? Icon(Icons.location_on, color: Colors.white, size: 10)
                  : null,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            location,
            style: TextStyle(
              color: Color(0xFF2D3748),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJobCard({
    required String jobId,
    required String from,
    required String to,
    required String cargo,
    required String weight,
    required String price,
    required String status,
    required Color statusColor,
    double? progress,
    String? driverName,
    String? estimatedTime,
    bool isActive = false,
    bool isPending = false,
    bool isCompleted = false,
    String? completedDate,
    double? rating,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
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
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFF2D3748).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xFF2D3748).withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    jobId,
                    style: TextStyle(
                      color: Color(0xFF2D3748),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withOpacity(0.2)),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Route info
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildRoutePoint(from, true),
                Container(
                  margin: EdgeInsets.only(left: 7),
                  height: 24,
                  child: VerticalDivider(
                    color: Color(0xFFE2E8F0),
                    thickness: 2,
                    width: 2,
                  ),
                ),
                _buildRoutePoint(to, false),
              ],
            ),
          ),

          if (isActive && progress != null) ...[
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              height: 8,
              decoration: BoxDecoration(
                color: Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF2D3748),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],

          SizedBox(height: 20),

          // Cargo details
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        'Yük',
                        cargo,
                        Icons.inventory_2_rounded,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildDetailItem(
                        'Ağırlık',
                        weight,
                        Icons.scale_rounded,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        'Ücret',
                        price,
                        Icons.payments_rounded,
                      ),
                    ),
                    if (isActive && driverName != null) ...[
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildDetailItem(
                          'Sürücü',
                          driverName,
                          Icons.person_rounded,
                        ),
                      ),
                    ],
                    if (isCompleted && rating != null) ...[
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildDetailItem(
                          'Puan',
                          rating.toString(),
                          Icons.star_rounded,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          if (isActive && estimatedTime != null) ...[
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color(0xFFF7FAFC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.access_time_rounded,
                      color: Color(0xFF718096),
                      size: 14,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Tahmini kalan süre: $estimatedTime',
                    style: TextStyle(
                      color: Color(0xFF718096),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (isCompleted && completedDate != null) ...[
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color(0xFF38A169).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF38A169),
                      size: 14,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Teslim edildi - $completedDate',
                    style: TextStyle(
                      color: Color(0xFF718096),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 24),

          // Action buttons
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                if (isActive || isPending)
                  Expanded(
                    child: Container(
                      height: 48,
                      child: ElevatedButton(
                        onPressed:
                            () =>
                                isActive
                                    ? _trackShipment(jobId)
                                    : _assignDriver(jobId),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2D3748),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          shadowColor: Color(0xFF2D3748).withOpacity(0.3),
                        ),
                        child: Text(
                          isActive ? 'Takip Et' : 'Sürücü Ata',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (isActive || isPending) SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => _viewJobDetails(jobId),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF2D3748),
                        side: BorderSide(color: Color(0xFFE2E8F0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Detaylar',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
