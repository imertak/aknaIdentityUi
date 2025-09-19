// screens/vehicles_management_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';

import 'accountScreen.dart';
import 'carrierJobsScreen.dart';
import 'mainDashboardScreen.dart';

class VehiclesManagementScreen extends StatefulWidget {
  final String userType;
  final String userName;

  const VehiclesManagementScreen({
    Key? key,
    this.userType = 'Carrier',
    this.userName = 'Kullanıcı',
  }) : super(key: key);

  @override
  _VehiclesManagementScreenState createState() =>
      _VehiclesManagementScreenState();
}

class _VehiclesManagementScreenState extends State<VehiclesManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  int _selectedBottomNavIndex = 3; // Vehicles tab selected
  String _searchQuery = '';

  // Sample data - In real app, this would come from API
  List<Vehicle> vehicles = [
    Vehicle(
      id: '1',
      plateNumber: '34 ABC 123',
      brand: 'Mercedes',
      model: 'Actros',
      year: 2020,
      capacity: '40 Ton',
      status: VehicleStatus.active,
      driverName: 'Mehmet Yılmaz',
      lastLocation: 'İstanbul',
      fuelLevel: 85,
    ),
    Vehicle(
      id: '2',
      plateNumber: '06 DEF 456',
      brand: 'Volvo',
      model: 'FH16',
      year: 2019,
      capacity: '25 Ton',
      status: VehicleStatus.maintenance,
      driverName: 'Ali Demir',
      lastLocation: 'Ankara',
      fuelLevel: 45,
    ),
    Vehicle(
      id: '3',
      plateNumber: '35 GHI 789',
      brand: 'Scania',
      model: 'R450',
      year: 2021,
      capacity: '30 Ton',
      status: VehicleStatus.active,
      driverName: 'Fatih Kaya',
      lastLocation: 'İzmir',
      fuelLevel: 70,
    ),
  ];

  List<Driver> drivers = [
    Driver(
      id: '1',
      name: 'Mehmet Yılmaz',
      phone: '+90 555 123 45 67',
      licenseClass: 'E Sınıfı',
      experience: '15 Yıl',
      rating: 4.8,
      status: DriverStatus.active,
      currentVehicle: '34 ABC 123',
    ),
    Driver(
      id: '2',
      name: 'Ali Demir',
      phone: '+90 555 234 56 78',
      licenseClass: 'E Sınıfı',
      experience: '12 Yıl',
      rating: 4.6,
      status: DriverStatus.offline,
      currentVehicle: '06 DEF 456',
    ),
    Driver(
      id: '3',
      name: 'Fatih Kaya',
      phone: '+90 555 345 67 89',
      licenseClass: 'E Sınıfı',
      experience: '8 Yıl',
      rating: 4.9,
      status: DriverStatus.active,
      currentVehicle: '35 GHI 789',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

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
                    _buildTabBar(),
                    _buildContent(),
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
              GestureDetector(
                onTap: () => Navigator.pop(context),
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
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF4A5568),
                    size: 22,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filo Yönetimi',
                      style: TextStyle(
                        color: Color(0xFF2D3748),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Araçlar ve şöförler',
                      style: TextStyle(
                        color: Color(0xFF718096),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildHeaderButton(
                    icon: Icons.add_rounded,
                    onTap: _showAddDialog,
                  ),
                  SizedBox(width: 12),
                  _buildHeaderButton(
                    icon: Icons.more_vert_rounded,
                    onTap: _showOptionsMenu,
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
        child: Icon(icon, color: Color(0xFF4A5568), size: 22),
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
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Plaka, şöför adı veya marka ara...',
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
          suffixIcon: GestureDetector(
            onTap: _showFilterDialog,
            child: Container(
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
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Color(0xFF2D3748),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Color(0xFF718096),
        labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_shipping_rounded, size: 20),
                SizedBox(width: 8),
                Text('Araçlar'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_rounded, size: 20),
                SizedBox(width: 8),
                Text('Şöförler'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: TabBarView(
        controller: _tabController,
        children: [_buildVehiclesTab(), _buildDriversTab()],
      ),
    );
  }

  Widget _buildVehiclesTab() {
    return Column(
      children: [
        _buildVehicleStats(),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 24),
            itemCount: _getFilteredVehicles().length,
            itemBuilder: (context, index) {
              return _buildVehicleCard(_getFilteredVehicles()[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDriversTab() {
    return Column(
      children: [
        _buildDriverStats(),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 24),
            itemCount: _getFilteredDrivers().length,
            itemBuilder: (context, index) {
              return _buildDriverCard(_getFilteredDrivers()[index]);
            },
          ),
        ),
      ],
    );
  }

  List<Vehicle> _getFilteredVehicles() {
    if (_searchQuery.isEmpty) return vehicles;
    return vehicles.where((vehicle) {
      return vehicle.plateNumber.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          vehicle.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          vehicle.model.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          vehicle.driverName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  List<Driver> _getFilteredDrivers() {
    if (_searchQuery.isEmpty) return drivers;
    return drivers.where((driver) {
      return driver.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          driver.currentVehicle.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
    }).toList();
  }

  Widget _buildVehicleStats() {
    return Container(
      margin: EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              '${vehicles.length}',
              'Toplam Araç',
              Color(0xFF3182CE),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              '${vehicles.where((v) => v.status == VehicleStatus.active).length}',
              'Aktif',
              Color(0xFF38A169),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              '${vehicles.where((v) => v.status == VehicleStatus.maintenance).length}',
              'Bakımda',
              Color(0xFFED8936),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverStats() {
    return Container(
      margin: EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              '${drivers.length}',
              'Toplam Şöför',
              Color(0xFF3182CE),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              '${drivers.where((d) => d.status == DriverStatus.active).length}',
              'Aktif',
              Color(0xFF38A169),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('4.8', 'Ort. Puan', Color(0xFFED8936)),
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

  Widget _buildVehicleCard(Vehicle vehicle) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _getVehicleStatusColor(
                      vehicle.status,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: _getVehicleStatusColor(
                        vehicle.status,
                      ).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.local_shipping_rounded,
                    color: _getVehicleStatusColor(vehicle.status),
                    size: 26,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            vehicle.plateNumber,
                            style: TextStyle(
                              color: Color(0xFF2D3748),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getVehicleStatusColor(
                                vehicle.status,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _getVehicleStatusColor(
                                  vehicle.status,
                                ).withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              _getVehicleStatusText(vehicle.status),
                              style: TextStyle(
                                color: _getVehicleStatusColor(vehicle.status),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(
                        '${vehicle.brand} ${vehicle.model} (${vehicle.year})',
                        style: TextStyle(
                          color: Color(0xFF718096),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Kapasite: ${vehicle.capacity}',
                        style: TextStyle(
                          color: Color(0xFF718096),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFFF7FAFC),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border(
                top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person_rounded,
                      color: Color(0xFF718096),
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      vehicle.driverName,
                      style: TextStyle(
                        color: Color(0xFF4A5568),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.location_on_rounded,
                      color: Color(0xFF718096),
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      vehicle.lastLocation,
                      style: TextStyle(
                        color: Color(0xFF4A5568),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.local_gas_station_rounded,
                      color: Color(0xFF718096),
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Yakıt: %${vehicle.fuelLevel}',
                      style: TextStyle(
                        color: Color(0xFF4A5568),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: vehicle.fuelLevel / 100,
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  vehicle.fuelLevel > 30
                                      ? Color(0xFF38A169)
                                      : Color(0xFFE53E3E),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => _showVehicleDetails(vehicle),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.more_vert_rounded,
                          color: Color(0xFF718096),
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverCard(Driver driver) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: _getDriverStatusColor(driver.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: _getDriverStatusColor(driver.status).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                driver.name[0].toUpperCase(),
                style: TextStyle(
                  color: _getDriverStatusColor(driver.status),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      driver.name,
                      style: TextStyle(
                        color: Color(0xFF2D3748),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.1,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getDriverStatusColor(
                          driver.status,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _getDriverStatusColor(
                            driver.status,
                          ).withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        _getDriverStatusText(driver.status),
                        style: TextStyle(
                          color: _getDriverStatusColor(driver.status),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  '${driver.licenseClass} • ${driver.experience}',
                  style: TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: Color(0xFFED8936),
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${driver.rating}',
                      style: TextStyle(
                        color: Color(0xFF2D3748),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(
                      Icons.local_shipping_rounded,
                      color: Color(0xFF718096),
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      driver.currentVehicle,
                      style: TextStyle(
                        color: Color(0xFF718096),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () => _showDriverDetails(driver),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Color(0xFFF7FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.more_vert_rounded,
                          color: Color(0xFF718096),
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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
    if (index != 3) {
      // Don't navigate if already on vehicles screen
      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => MainDashboardScreen(
                    userType: widget.userType,
                    userName: widget.userName,
                  ),
            ),
          );
          break;
        case 1:
          Navigator.pushReplacement(
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
        case 4:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AccountScreen(
                    userName: widget.userName,
                    userType: widget.userType,
                  ),
            ),
          );
          break;
      }
    }
  }

  void _showAddDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.4,
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
                      Text(
                        'Yeni Ekle',
                        style: TextStyle(
                          color: Color(0xFF2D3748),
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 24),
                      _buildAddOption(
                        'Yeni Araç',
                        'Filoya araç ekle',
                        Icons.local_shipping_rounded,
                        Color(0xFF3182CE),
                        () => _addVehicle(),
                      ),
                      SizedBox(height: 16),
                      _buildAddOption(
                        'Yeni Şöför',
                        'Şöför ekle',
                        Icons.person_add_rounded,
                        Color(0xFF38A169),
                        () => _addDriver(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildAddOption(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(16),
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
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
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

  void _showOptionsMenu() {
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
                        'Dışa Aktar',
                        Icons.file_download_rounded,
                        () {},
                      ),
                      _buildMenuItem(
                        'Filtrele',
                        Icons.filter_list_rounded,
                        () {},
                      ),
                      _buildMenuItem('Sırala', Icons.sort_rounded, () {}),
                      _buildMenuItem(
                        'Yenile',
                        Icons.refresh_rounded,
                        () => _onRefresh(),
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

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(16),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Color(0xFFE2E8F0)),
              ),
              child: Icon(icon, color: Color(0xFF4A5568), size: 20),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Color(0xFF2D3748),
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Durum',
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                CheckboxListTile(
                  title: Text(
                    'Aktif',
                    style: TextStyle(
                      color: Color(0xFF2D3748),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: true,
                  onChanged: (value) {},
                  activeColor: Color(0xFF3182CE),
                  contentPadding: EdgeInsets.zero,
                ),
                CheckboxListTile(
                  title: Text(
                    'Bakımda',
                    style: TextStyle(
                      color: Color(0xFF2D3748),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  value: false,
                  onChanged: (value) {},
                  activeColor: Color(0xFF3182CE),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Temizle',
                  style: TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2D3748),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Uygula'),
              ),
            ],
          ),
    );
  }

  Color _getVehicleStatusColor(VehicleStatus status) {
    switch (status) {
      case VehicleStatus.active:
        return Color(0xFF38A169);
      case VehicleStatus.inactive:
        return Color(0xFF718096);
      case VehicleStatus.maintenance:
        return Color(0xFFED8936);
    }
  }

  String _getVehicleStatusText(VehicleStatus status) {
    switch (status) {
      case VehicleStatus.active:
        return 'Aktif';
      case VehicleStatus.inactive:
        return 'Pasif';
      case VehicleStatus.maintenance:
        return 'Bakım';
    }
  }

  Color _getDriverStatusColor(DriverStatus status) {
    switch (status) {
      case DriverStatus.active:
        return Color(0xFF38A169);
      case DriverStatus.offline:
        return Color(0xFF718096);
      case DriverStatus.busy:
        return Color(0xFFED8936);
    }
  }

  String _getDriverStatusText(DriverStatus status) {
    switch (status) {
      case DriverStatus.active:
        return 'Aktif';
      case DriverStatus.offline:
        return 'Çevrimdışı';
      case DriverStatus.busy:
        return 'Meşgul';
    }
  }

  void _showVehicleDetails(Vehicle vehicle) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
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
                            vehicle.plateNumber,
                            style: TextStyle(
                              color: Color(0xFF2D3748),
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Row(
                            children: [
                              _buildActionButton(
                                Icons.edit_rounded,
                                Color(0xFF3182CE),
                                () => _editVehicle(vehicle),
                              ),
                              SizedBox(width: 12),
                              _buildActionButton(
                                Icons.delete_rounded,
                                Color(0xFFE53E3E),
                                () => _deleteVehicle(vehicle),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      _buildDetailRow('Marka', vehicle.brand),
                      _buildDetailRow('Model', vehicle.model),
                      _buildDetailRow('Yıl', vehicle.year.toString()),
                      _buildDetailRow('Kapasite', vehicle.capacity),
                      _buildDetailRow('Şöför', vehicle.driverName),
                      _buildDetailRow('Son Konum', vehicle.lastLocation),
                      _buildDetailRow(
                        'Yakıt Seviyesi',
                        '%${vehicle.fuelLevel}',
                      ),
                      _buildDetailRow(
                        'Durum',
                        _getVehicleStatusText(vehicle.status),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _showDriverDetails(Driver driver) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
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
                            driver.name,
                            style: TextStyle(
                              color: Color(0xFF2D3748),
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Row(
                            children: [
                              _buildActionButton(
                                Icons.edit_rounded,
                                Color(0xFF3182CE),
                                () => _editDriver(driver),
                              ),
                              SizedBox(width: 12),
                              _buildActionButton(
                                Icons.delete_rounded,
                                Color(0xFFE53E3E),
                                () => _deleteDriver(driver),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      _buildDetailRow('Telefon', driver.phone),
                      _buildDetailRow('Ehliyet Sınıfı', driver.licenseClass),
                      _buildDetailRow('Deneyim', driver.experience),
                      _buildDetailRow('Puan', driver.rating.toString()),
                      _buildDetailRow('Araç', driver.currentVehicle),
                      _buildDetailRow(
                        'Durum',
                        _getDriverStatusText(driver.status),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF718096),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
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
    );
  }

  void _addVehicle() {
    Navigator.pop(context);
    print('Add new vehicle');
  }

  void _addDriver() {
    Navigator.pop(context);
    print('Add new driver');
  }

  void _editVehicle(Vehicle vehicle) {
    Navigator.pop(context);
    print('Edit vehicle: ${vehicle.plateNumber}');
  }

  void _deleteVehicle(Vehicle vehicle) {
    Navigator.pop(context);
    print('Delete vehicle: ${vehicle.plateNumber}');
  }

  void _editDriver(Driver driver) {
    Navigator.pop(context);
    print('Edit driver: ${driver.name}');
  }

  void _deleteDriver(Driver driver) {
    Navigator.pop(context);
    print('Delete driver: ${driver.name}');
  }
}

// Model classes
class Vehicle {
  final String id;
  final String plateNumber;
  final String brand;
  final String model;
  final int year;
  final String capacity;
  final VehicleStatus status;
  final String driverName;
  final String lastLocation;
  final int fuelLevel;

  Vehicle({
    required this.id,
    required this.plateNumber,
    required this.brand,
    required this.model,
    required this.year,
    required this.capacity,
    required this.status,
    required this.driverName,
    required this.lastLocation,
    required this.fuelLevel,
  });
}

class Driver {
  final String id;
  final String name;
  final String phone;
  final String licenseClass;
  final String experience;
  final double rating;
  final DriverStatus status;
  final String currentVehicle;

  Driver({
    required this.id,
    required this.name,
    required this.phone,
    required this.licenseClass,
    required this.experience,
    required this.rating,
    required this.status,
    required this.currentVehicle,
  });
}

enum VehicleStatus { active, inactive, maintenance }

enum DriverStatus { active, offline, busy }
