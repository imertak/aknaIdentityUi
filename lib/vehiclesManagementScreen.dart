// screens/vehicles_management_screen.dart
import 'package:flutter/material.dart';

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
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
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
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Araçlar & Şöförler',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: Colors.white),
          onPressed: () => _showSearchDialog(),
        ),
        IconButton(
          icon: Icon(Icons.filter_list, color: Colors.white),
          onPressed: () => _showFilterDialog(),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Color(0xFFCEFF00),
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey[400],
        labelStyle: TextStyle(fontWeight: FontWeight.w600),
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
                Text('Şöförler'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehiclesTab() {
    return Column(
      children: [
        _buildVehicleStats(),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              return _buildVehicleCard(vehicles[index]);
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
            padding: EdgeInsets.all(20),
            itemCount: drivers.length,
            itemBuilder: (context, index) {
              return _buildDriverCard(drivers[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleStats() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFCEFF00).withOpacity(0.1),
            Color(0xFFCEFF00).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFCEFF00).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('${vehicles.length}', 'Toplam Araç'),
          Container(width: 1, height: 30, color: Colors.grey[700]),
          _buildStatItem(
            '${vehicles.where((v) => v.status == VehicleStatus.active).length}',
            'Aktif',
          ),
          Container(width: 1, height: 30, color: Colors.grey[700]),
          _buildStatItem(
            '${vehicles.where((v) => v.status == VehicleStatus.maintenance).length}',
            'Bakımda',
          ),
        ],
      ),
    );
  }

  Widget _buildDriverStats() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFCEFF00).withOpacity(0.1),
            Color(0xFFCEFF00).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFCEFF00).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('${drivers.length}', 'Toplam Şöför'),
          Container(width: 1, height: 30, color: Colors.grey[700]),
          _buildStatItem(
            '${drivers.where((d) => d.status == DriverStatus.active).length}',
            'Aktif',
          ),
          Container(width: 1, height: 30, color: Colors.grey[700]),
          _buildStatItem('4.8', 'Ort. Puan'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Color(0xFFCEFF00),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
      ],
    );
  }

  Widget _buildVehicleCard(Vehicle vehicle) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getVehicleStatusColor(
                      vehicle.status,
                    ).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.local_shipping,
                    color: _getVehicleStatusColor(vehicle.status),
                    size: 30,
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
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getVehicleStatusColor(
                                vehicle.status,
                              ).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
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
                      SizedBox(height: 4),
                      Text(
                        '${vehicle.brand} ${vehicle.model} (${vehicle.year})',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Kapasite: ${vehicle.capacity}',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[800]!.withOpacity(0.5),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.grey[400], size: 16),
                    SizedBox(width: 8),
                    Text(
                      vehicle.driverName,
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                    Spacer(),
                    Icon(Icons.location_on, color: Colors.grey[400], size: 16),
                    SizedBox(width: 8),
                    Text(
                      vehicle.lastLocation,
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.local_gas_station,
                      color: Colors.grey[400],
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Yakıt: %${vehicle.fuelLevel}',
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: vehicle.fuelLevel / 100,
                        backgroundColor: Colors.grey[700],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          vehicle.fuelLevel > 30 ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => _showVehicleDetails(vehicle),
                      child: Icon(Icons.more_vert, color: Colors.grey[400]),
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
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _getDriverStatusColor(driver.status).withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                driver.name[0].toUpperCase(),
                style: TextStyle(
                  color: _getDriverStatusColor(driver.status),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
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
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getDriverStatusColor(
                          driver.status,
                        ).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
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
                SizedBox(height: 4),
                Text(
                  '${driver.licenseClass} • ${driver.experience}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '${driver.rating}',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(width: 16),
                    Icon(
                      Icons.local_shipping,
                      color: Colors.grey[400],
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      driver.currentVehicle,
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () => _showDriverDetails(driver),
                      child: Icon(Icons.more_vert, color: Colors.grey[400]),
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

  Color _getVehicleStatusColor(VehicleStatus status) {
    switch (status) {
      case VehicleStatus.active:
        return Colors.green;
      case VehicleStatus.inactive:
        return Colors.grey;
      case VehicleStatus.maintenance:
        return Colors.orange;
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
        return Colors.green;
      case DriverStatus.offline:
        return Colors.grey;
      case DriverStatus.busy:
        return Colors.orange;
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

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text('Ara', style: TextStyle(color: Colors.white)),
            content: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Plaka, şöför adı veya marka...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('İptal', style: TextStyle(color: Colors.grey[400])),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFCEFF00),
                  foregroundColor: Colors.black,
                ),
                child: Text('Ara'),
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
            backgroundColor: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text('Filtrele', style: TextStyle(color: Colors.white)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Durum',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                CheckboxListTile(
                  title: Text('Aktif', style: TextStyle(color: Colors.white)),
                  value: true,
                  onChanged: (value) {},
                  activeColor: Color(0xFFCEFF00),
                ),
                CheckboxListTile(
                  title: Text('Bakımda', style: TextStyle(color: Colors.white)),
                  value: false,
                  onChanged: (value) {},
                  activeColor: Color(0xFFCEFF00),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Temizle',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFCEFF00),
                  foregroundColor: Colors.black,
                ),
                child: Text('Uygula'),
              ),
            ],
          ),
    );
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
              color: Colors.grey[900],
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
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
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Color(0xFFCEFF00)),
                          onPressed: () => _editVehicle(vehicle),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteVehicle(vehicle),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _buildDetailRow('Marka', vehicle.brand),
                _buildDetailRow('Model', vehicle.model),
                _buildDetailRow('Yıl', vehicle.year.toString()),
                _buildDetailRow('Kapasite', vehicle.capacity),
                _buildDetailRow('Şöför', vehicle.driverName),
                _buildDetailRow('Son Konum', vehicle.lastLocation),
                _buildDetailRow('Yakıt Seviyesi', '%${vehicle.fuelLevel}'),
                _buildDetailRow('Durum', _getVehicleStatusText(vehicle.status)),
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
              color: Colors.grey[900],
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
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
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Color(0xFFCEFF00)),
                          onPressed: () => _editDriver(driver),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteDriver(driver),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _buildDetailRow('Telefon', driver.phone),
                _buildDetailRow('Ehliyet Sınıfı', driver.licenseClass),
                _buildDetailRow('Deneyim', driver.experience),
                _buildDetailRow('Puan', driver.rating.toString()),
                _buildDetailRow('Araç', driver.currentVehicle),
                _buildDetailRow('Durum', _getDriverStatusText(driver.status)),
              ],
            ),
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 16)),
          Text(value, style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }

  void _editVehicle(Vehicle vehicle) {
    Navigator.pop(context);
    // Navigate to edit vehicle screen
    print('Edit vehicle: ${vehicle.plateNumber}');
  }

  void _deleteVehicle(Vehicle vehicle) {
    Navigator.pop(context);
    // Show confirmation dialog and delete
    print('Delete vehicle: ${vehicle.plateNumber}');
  }

  void _editDriver(Driver driver) {
    Navigator.pop(context);
    // Navigate to edit driver screen
    print('Edit driver: ${driver.name}');
  }

  void _deleteDriver(Driver driver) {
    Navigator.pop(context);
    // Show confirmation dialog and delete
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
