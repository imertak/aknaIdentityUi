// shipment_history_screen.dart - Modernized
import 'package:flutter/material.dart';

class ShipmentHistoryScreen extends StatefulWidget {
  final String userName;

  const ShipmentHistoryScreen({Key? key, required this.userName})
    : super(key: key);

  @override
  _ShipmentHistoryScreenState createState() => _ShipmentHistoryScreenState();
}

class _ShipmentHistoryScreenState extends State<ShipmentHistoryScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  int _selectedBottomNavIndex = 1; // Default to Shipments tab

  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'Tümü';
  String _selectedDateRange = 'Son 30 Gün';
  bool _isSearchActive = false;

  final List<String> _statusOptions = [
    'Tümü',
    'Teslim Edildi',
    'İptal Edildi',
    'Beklemede',
    'Aktif',
  ];

  final List<String> _dateRangeOptions = [
    'Son 7 Gün',
    'Son 30 Gün',
    'Son 3 Ay',
    'Son 6 Ay',
    'Son 1 Yıl',
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F7),
      bottomNavigationBar: _buildBottomNavigation(),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchAndFilters(),
              _buildSummaryStats(),
              Expanded(child: _buildShipmentsList()),
            ],
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
                  'Sevkiyat Geçmişi',
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${widget.userName} - Tüm İşlemler',
                  style: TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: _showFilterBottomSheet,
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
                    Icons.tune_rounded,
                    color: Color(0xFF2D3748),
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 12),
              GestureDetector(
                onTap: _exportToExcel,
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
                    Icons.download_rounded,
                    color: Color(0xFF2D3748),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isSearchActive ? Color(0xFF2D3748) : Color(0xFFE2E8F0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _isSearchActive = value.isNotEmpty;
                });
              },
              style: TextStyle(color: Color(0xFF2D3748)),
              decoration: InputDecoration(
                hintText: 'Sevkiyat No, Şehir veya Alıcı ara...',
                hintStyle: TextStyle(color: Color(0xFF718096)),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Color(0xFF718096),
                ),
                suffixIcon:
                    _isSearchActive
                        ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color: Color(0xFF718096),
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _isSearchActive = false;
                            });
                          },
                        )
                        : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          SizedBox(height: 16),

          // Quick Filters
          Row(
            children: [
              Expanded(
                child: _buildFilterChip(
                  'Durum: $_selectedStatus',
                  Icons.flag_rounded,
                  () => _showStatusFilter(),
                ),
              ),
              Container(width: 8),
              Expanded(
                child: _buildFilterChip(
                  _selectedDateRange,
                  Icons.date_range_rounded,
                  () => _showDateRangeFilter(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
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
            ),
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'Filtrele',
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 24),

                // Status Filter
                Text(
                  'Durum',
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      _statusOptions.map((status) {
                        final isSelected = _selectedStatus == status;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedStatus = status),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Color(0xFF2D3748).withOpacity(0.1)
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Color(0xFF2D3748)
                                        : Color(0xFFE2E8F0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color:
                                    isSelected
                                        ? Color(0xFF2D3748)
                                        : Color(0xFF718096),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),

                SizedBox(height: 24),

                // Date Range Filter
                Text(
                  'Tarih Aralığı',
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 12),
                Column(
                  children:
                      _dateRangeOptions.map((range) {
                        final isSelected = _selectedDateRange == range;
                        return GestureDetector(
                          onTap:
                              () => setState(() => _selectedDateRange = range),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 8),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Color(0xFF2D3748).withOpacity(0.05)
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Color(0xFF2D3748)
                                        : Color(0xFFE2E8F0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color:
                                      isSelected
                                          ? Color(0xFF2D3748)
                                          : Color(0xFF718096),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  range,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Color(0xFF2D3748)
                                            : Color(0xFF718096),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),

                Spacer(),

                // Apply Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2D3748),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Filtreyi Uygula',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _showStatusFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Durum Seçin',
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16),
                ...(_statusOptions.map((status) {
                  return ListTile(
                    title: Text(
                      status,
                      style: TextStyle(color: Color(0xFF2D3748)),
                    ),
                    trailing:
                        _selectedStatus == status
                            ? Icon(Icons.check, color: Color(0xFF2D3748))
                            : null,
                    onTap: () {
                      setState(() => _selectedStatus = status);
                      Navigator.pop(context);
                    },
                  );
                }).toList()),
              ],
            ),
          ),
    );
  }

  void _showDateRangeFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tarih Aralığı Seçin',
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16),
                ...(_dateRangeOptions.map((range) {
                  return ListTile(
                    title: Text(
                      range,
                      style: TextStyle(color: Color(0xFF2D3748)),
                    ),
                    trailing:
                        _selectedDateRange == range
                            ? Icon(Icons.check, color: Color(0xFF2D3748))
                            : null,
                    onTap: () {
                      setState(() => _selectedDateRange = range);
                      Navigator.pop(context);
                    },
                  );
                }).toList()),
              ],
            ),
          ),
    );
  }

  void _showShipmentDetails(Map<String, dynamic> shipment) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Sevkiyat Detayları',
                        style: TextStyle(
                          color: Color(0xFF2D3748),
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Color(0xFF718096)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Shipment Status
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _getStatusColor(shipment['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _getStatusColor(
                        shipment['status'],
                      ).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getStatusIcon(shipment['status']),
                        color: _getStatusColor(shipment['status']),
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shipment['shipmentNo'],
                              style: TextStyle(
                                color: Color(0xFF2D3748),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              _getStatusText(shipment['status']),
                              style: TextStyle(
                                color: _getStatusColor(shipment['status']),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        shipment['amount'],
                        style: TextStyle(
                          color: Color(0xFF2D3748),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                // Details List
                Expanded(
                  child: ListView(
                    children: [
                      _buildDetailRow('Sevkiyat No', shipment['shipmentNo']),
                      _buildDetailRow('Kalkış', shipment['origin']),
                      _buildDetailRow('Varış', shipment['destination']),
                      _buildDetailRow('Yük Türü', shipment['cargoType']),
                      _buildDetailRow('Ağırlık', shipment['weight']),
                      _buildDetailRow('Tarih', shipment['date']),
                      _buildDetailRow('Taşıyıcı', shipment['carrier']),
                      _buildDetailRow('Sürücü', shipment['driver']),
                      _buildDetailRow('Plaka', shipment['plate']),
                      _buildDetailRow('Alıcı', shipment['recipient']),
                      _buildDetailRow('Alıcı Tel', shipment['recipientPhone']),
                      _buildDetailRow('Tutar', shipment['amount']),
                      _buildDetailRow(
                        'Ödeme Durumu',
                        shipment['paymentStatus'],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () => _downloadInvoice(shipment),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xFF2D3748),
                            side: BorderSide(color: Color(0xFFE2E8F0)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: Text('Fatura İndir'),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => _contactCarrier(shipment),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2D3748),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: Text('Taşıyıcı İletişim'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: TextStyle(
                color: Color(0xFF718096),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Color(0xFF2D3748),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshShipments() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // Refresh shipments data
    });
  }

  void _exportToExcel() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Excel dosyası indiriliyor...'),
        backgroundColor: Color(0xFF2D3748),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _trackShipment(Map<String, dynamic> shipment) {
    // Navigate to shipment tracking screen
  }

  void _downloadInvoice(Map<String, dynamic> shipment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fatura indiriliyor...'),
        backgroundColor: Color(0xFF2D3748),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _contactCarrier(Map<String, dynamic> shipment) {
    // Show contact options
  }

  // Helper Methods
  Color _getStatusColor(String status) {
    switch (status) {
      case 'delivered':
        return Color(0xFF38A169);
      case 'cancelled':
        return Color(0xFFE53E3E);
      case 'pending':
        return Color(0xFFED8936);
      case 'active':
        return Color(0xFF3182CE);
      default:
        return Color(0xFF718096);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      case 'pending':
        return Icons.schedule;
      case 'active':
        return Icons.local_shipping;
      default:
        return Icons.info;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'delivered':
        return 'Teslim Edildi';
      case 'cancelled':
        return 'İptal Edildi';
      case 'pending':
        return 'Beklemede';
      case 'active':
        return 'Aktif';
      default:
        return 'Bilinmiyor';
    }
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
            _buildNavItem(Icons.local_shipping_rounded, 1),
            _buildNavItem(Icons.add_rounded, 2, isCenter: true),
            _buildNavItem(Icons.receipt_rounded, 3),
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
      case 1: // Shipments
        // Already on shipments screen
        break;
      case 2: // Create
        break;
      case 3: // Invoices
        break;
      case 4: // Profile
        break;
    }
  }

  List<Map<String, dynamic>> _getFilteredShipments() {
    // Mock data - gerçek uygulamada API'den gelecek
    List<Map<String, dynamic>> allShipments = [
      {
        'shipmentNo': 'SHP-2024-001',
        'origin': 'İstanbul',
        'destination': 'Ankara',
        'cargoType': 'Elektronik Eşya',
        'weight': '2.5 ton',
        'date': '15 Ara 2024',
        'carrier': 'Hızlı Kargo Ltd.',
        'driver': 'Ahmet Yılmaz',
        'plate': '34 ABC 123',
        'recipient': 'Mehmet Özkan',
        'recipientPhone': '+90 532 123 4567',
        'amount': '₺8,500',
        'paymentStatus': 'Ödendi',
        'status': 'delivered',
      },
      {
        'shipmentNo': 'SHP-2024-002',
        'origin': 'İzmir',
        'destination': 'Bursa',
        'cargoType': 'Tekstil Ürünleri',
        'weight': '1.8 ton',
        'date': '12 Ara 2024',
        'carrier': 'Express Taşıma',
        'driver': 'Fatma Demir',
        'plate': '35 XYZ 456',
        'recipient': 'Ayşe Kaya',
        'recipientPhone': '+90 541 987 6543',
        'amount': '₺6,200',
        'paymentStatus': 'Beklemede',
        'status': 'active',
      },
      {
        'shipmentNo': 'SHP-2024-003',
        'origin': 'Ankara',
        'destination': 'Antalya',
        'cargoType': 'Gıda Ürünleri',
        'weight': '3.2 ton',
        'date': '10 Ara 2024',
        'carrier': 'Güvenli Nakliyat',
        'driver': 'Ali Çelik',
        'plate': '06 DEF 789',
        'recipient': 'Mustafa Aydın',
        'recipientPhone': '+90 555 111 2222',
        'amount': '₺12,800',
        'paymentStatus': 'Ödendi',
        'status': 'delivered',
      },
      {
        'shipmentNo': 'SHP-2024-004',
        'origin': 'İstanbul',
        'destination': 'İzmir',
        'cargoType': 'Mobilya',
        'weight': '4.5 ton',
        'date': '08 Ara 2024',
        'carrier': 'Mega Lojistik',
        'driver': 'Zeynep Aksoy',
        'plate': '34 GHI 012',
        'recipient': 'Hasan Öztürk',
        'recipientPhone': '+90 533 444 5555',
        'amount': '₺15,600',
        'paymentStatus': 'İptal',
        'status': 'cancelled',
      },
    ];

    // Apply filters
    List<Map<String, dynamic>> filteredShipments =
        allShipments.where((shipment) {
          // Status filter
          if (_selectedStatus != 'Tümü') {
            String statusFilter = '';
            switch (_selectedStatus) {
              case 'Teslim Edildi':
                statusFilter = 'delivered';
                break;
              case 'İptal Edildi':
                statusFilter = 'cancelled';
                break;
              case 'Beklemede':
                statusFilter = 'pending';
                break;
              case 'Aktif':
                statusFilter = 'active';
                break;
            }
            if (shipment['status'] != statusFilter) return false;
          }

          // Search filter
          if (_searchController.text.isNotEmpty) {
            final searchText = _searchController.text.toLowerCase();
            final shipmentText =
                '${shipment['shipmentNo']} ${shipment['origin']} ${shipment['destination']} ${shipment['recipient']} ${shipment['carrier']}'
                    .toLowerCase();
            if (!shipmentText.contains(searchText)) return false;
          }

          return true;
        }).toList();

    // Sort by date (newest first)
    filteredShipments.sort((a, b) {
      return b['date'].compareTo(a['date']);
    });

    return filteredShipments;
  }

  Widget _buildFilterChip(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Color(0xFF2D3748), size: 16),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Color(0xFF2D3748),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Color(0xFF718096), size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStats() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              '142',
              'Toplam\nSevkiyat',
              Color(0xFF3182CE),
              Icons.local_shipping_rounded,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              '₺285K',
              'Toplam\nTutar',
              Color(0xFF38A169),
              Icons.payments_rounded,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              '97%',
              'Başarı\nOranı',
              Color(0xFFED8936),
              Icons.star_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    Color color,
    IconData icon,
  ) {
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
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF2D3748),
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
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

  Widget _buildShipmentsList() {
    return RefreshIndicator(
      onRefresh: _refreshShipments,
      backgroundColor: Colors.white,
      color: Color(0xFF2D3748),
      child: ListView.builder(
        padding: EdgeInsets.all(24),
        itemCount: _getFilteredShipments().length,
        itemBuilder: (context, index) {
          final shipment = _getFilteredShipments()[index];
          return _buildShipmentCard(shipment);
        },
      ),
    );
  }

  Widget _buildShipmentCard(Map<String, dynamic> shipment) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getStatusColor(shipment['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getStatusIcon(shipment['status']),
                    color: _getStatusColor(shipment['status']),
                    size: 20,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shipment['shipmentNo'],
                        style: TextStyle(
                          color: Color(0xFF2D3748),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '${shipment['origin']} → ${shipment['destination']}',
                        style: TextStyle(
                          color: Color(0xFF718096),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          shipment['status'],
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(shipment['status']),
                        style: TextStyle(
                          color: _getStatusColor(shipment['status']),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      shipment['amount'],
                      style: TextStyle(
                        color: Color(0xFF2D3748),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Details
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Color(0xFFF7FAFC),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        'Yük Türü',
                        shipment['cargoType'],
                        Icons.inventory_2,
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        'Ağırlık',
                        shipment['weight'],
                        Icons.scale,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        'Tarih',
                        shipment['date'],
                        Icons.calendar_today,
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        'Taşıyıcı',
                        shipment['carrier'],
                        Icons.local_shipping,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => _showShipmentDetails(shipment),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xFF2D3748),
                            side: BorderSide(color: Color(0xFFE2E8F0)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Text('Detaylar'),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => _trackShipment(shipment),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2D3748),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            shadowColor: Color(0xFF2D3748).withOpacity(0.3),
                          ),
                          child: Text('Takip Et'),
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

  Widget _buildDetailItem(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
                  title,
                  style: TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
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
}
