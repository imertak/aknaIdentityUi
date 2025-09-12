// vehicles_management_screen.dart
import 'package:flutter/material.dart';
import 'components/custom_bottom_navigation.dart';

enum VehicleStatus { active, inactive, maintenance }

enum DriverStatus { active, offline, busy }

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

class VehiclesManagementScreen extends StatefulWidget {
  const VehiclesManagementScreen({Key? key}) : super(key: key);

  @override
  _VehiclesManagementScreenState createState() =>
      _VehiclesManagementScreenState();
}

class _VehiclesManagementScreenState extends State<VehiclesManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  int _selectedBottomNavIndex = 3;

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
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F7),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [_buildVehiclesTab(), _buildDriversTab()],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
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
                  'Araçlar & Şoförler',
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Filo yönetimi ve sürücü takibi',
                  style: TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                Icon(Icons.local_shipping, size: 20),
                SizedBox(width: 8),
                Text('Araçlar'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 20),
                SizedBox(width: 8),
                Text('Şoförler'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehiclesTab() {
    return ListView.builder(
      padding: EdgeInsets.all(24),
      itemCount: vehicles.length,
      itemBuilder: (context, index) {
        return _buildVehicleCard(vehicles[index]);
      },
    );
  }

  Widget _buildDriversTab() {
    return ListView.builder(
      padding: EdgeInsets.all(24),
      itemCount: drivers.length,
      itemBuilder: (context, index) {
        return _buildDriverCard(drivers[index]);
      },
    );
  }

  Widget _buildVehicleCard(Vehicle vehicle) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
          ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: _getVehicleStatusColor(
                vehicle.status,
              ).withOpacity(0.1),
              radius: 24,
              child: Icon(
                Icons.local_shipping,
                color: _getVehicleStatusColor(vehicle.status),
                size: 24,
              ),
            ),
            title: Text(
              vehicle.plateNumber,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            subtitle: Text(
              '${vehicle.brand} ${vehicle.model}',
              style: TextStyle(color: Color(0xFF718096), fontSize: 14),
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getVehicleStatusColor(vehicle.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getVehicleStatusText(vehicle.status),
                style: TextStyle(
                  color: _getVehicleStatusColor(vehicle.status),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow(Icons.person_outline, vehicle.driverName),
                SizedBox(height: 8),
                _buildInfoRow(Icons.location_on_outlined, vehicle.lastLocation),
                SizedBox(height: 8),
                _buildFuelIndicator(vehicle.fuelLevel),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
          ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: _getDriverStatusColor(
                driver.status,
              ).withOpacity(0.1),
              radius: 24,
              child: Text(
                driver.name[0].toUpperCase(),
                style: TextStyle(
                  color: _getDriverStatusColor(driver.status),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            title: Text(
              driver.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            subtitle: Text(
              driver.phone,
              style: TextStyle(color: Color(0xFF718096), fontSize: 14),
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getDriverStatusColor(driver.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getDriverStatusText(driver.status),
                style: TextStyle(
                  color: _getDriverStatusColor(driver.status),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow(
                  Icons.card_membership_outlined,
                  driver.licenseClass,
                ),
                SizedBox(height: 8),
                _buildInfoRow(Icons.access_time_outlined, driver.experience),
                SizedBox(height: 8),
                _buildRatingIndicator(driver.rating),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Color(0xFF718096)),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFuelIndicator(int fuelLevel) {
    return Row(
      children: [
        Icon(Icons.local_gas_station, size: 16, color: Color(0xFF718096)),
        SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fuelLevel / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: _getFuelColor(fuelLevel),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        Text(
          '%$fuelLevel',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingIndicator(double rating) {
    return Row(
      children: [
        Icon(Icons.star, size: 16, color: Colors.amber),
        SizedBox(width: 8),
        Text(
          rating.toString(),
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return CustomBottomNavigation(
      selectedIndex: _selectedBottomNavIndex,
      onItemSelected: _onNavItemTapped,
      userType: "Carrier",
    );
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedBottomNavIndex = index;
    });

    switch (index) {
      case 0: // Ana Sayfa
        Navigator.pop(context);
        break;
      case 1: // Araçlar
        // Already on vehicles screen
        break;
      case 2: // İşler
        // Navigate to jobs screen
        break;
      case 3: // Şoförler
        // Navigate to drivers screen
        break;
      case 4: // Ayarlar
        // Navigate to settings screen
        break;
    }
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
        return 'Bakımda';
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

  Color _getFuelColor(int level) {
    if (level > 50) {
      return Color(0xFF38A169);
    } else if (level > 20) {
      return Color(0xFFED8936);
    } else {
      return Color(0xFFE53E3E);
    }
  }
}
