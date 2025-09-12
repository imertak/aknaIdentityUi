// screens/shipper_shipment_history_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildSearchAndFilters(),
            _buildSummaryStats(),
            Expanded(child: _buildShipmentsList()),
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
        'Sevkiyat Geçmişi',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.filter_list, color: Color(0xFFCEFF00)),
          onPressed: _showFilterBottomSheet,
        ),
        IconButton(
          icon: Icon(Icons.download, color: Colors.white),
          onPressed: _exportToExcel,
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(bottom: BorderSide(color: Colors.grey[800]!, width: 1)),
      ),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isSearchActive ? Color(0xFFCEFF00) : Colors.grey[700]!,
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _isSearchActive = value.isNotEmpty;
                });
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Sevkiyat No, Şehir veya Alıcı ara...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                suffixIcon:
                    _isSearchActive
                        ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey[400]),
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

          SizedBox(height: 12),

          // Quick Filters
          Row(
            children: [
              Expanded(
                child: _buildFilterChip(
                  'Durum: $_selectedStatus',
                  Icons.flag,
                  () => _showStatusFilter(),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildFilterChip(
                  _selectedDateRange,
                  Icons.date_range,
                  () => _showDateRangeFilter(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[700]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Color(0xFFCEFF00), size: 16),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStats() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900]!.withOpacity(0.5),
        border: Border(bottom: BorderSide(color: Colors.grey[800]!, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat('142', 'Toplam Sevkiyat', Colors.blue),
          _buildStat('₺285K', 'Toplam Tutar', Color(0xFFCEFF00)),
          _buildStat('97%', 'Başarı Oranı', Colors.green),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
      ],
    );
  }

  Widget _buildShipmentsList() {
    return RefreshIndicator(
      onRefresh: _refreshShipments,
      backgroundColor: Colors.grey[900],
      color: Color(0xFFCEFF00),
      child: ListView.builder(
        padding: EdgeInsets.all(16),
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
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getStatusColor(shipment['status']).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getStatusIcon(shipment['status']),
                    color: _getStatusColor(shipment['status']),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shipment['shipmentNo'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${shipment['origin']} → ${shipment['destination']}',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
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
                        ).withOpacity(0.2),
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
                    SizedBox(height: 4),
                    Text(
                      shipment['amount'],
                      style: TextStyle(
                        color: Color(0xFFCEFF00),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Details
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
                      child: ElevatedButton(
                        onPressed: () => _showShipmentDetails(shipment),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Detaylar'),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _trackShipment(shipment),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFCEFF00),
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Takip Et'),
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
    return Row(
      children: [
        Icon(icon, color: Colors.grey[400], size: 16),
        SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.grey[400], fontSize: 11),
            ),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
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
              color: Colors.grey[900],
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filtrele',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),

                // Status Filter
                Text(
                  'Durum',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
                                      ? Color(0xFFCEFF00).withOpacity(0.2)
                                      : Colors.grey[800],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Color(0xFFCEFF00)
                                        : Colors.grey[700]!,
                              ),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color:
                                    isSelected
                                        ? Color(0xFFCEFF00)
                                        : Colors.white,
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
                    color: Colors.grey[400],
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
                                      ? Color(0xFFCEFF00).withOpacity(0.1)
                                      : Colors.grey[800],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Color(0xFFCEFF00)
                                        : Colors.grey[700]!,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color:
                                      isSelected
                                          ? Color(0xFFCEFF00)
                                          : Colors.grey[600],
                                ),
                                SizedBox(width: 12),
                                Text(
                                  range,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Color(0xFFCEFF00)
                                            : Colors.white,
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
                      backgroundColor: Color(0xFFCEFF00),
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Filtreyi Uygula',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
              color: Colors.grey[900],
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
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                ...(_statusOptions.map((status) {
                  return ListTile(
                    title: Text(status, style: TextStyle(color: Colors.white)),
                    trailing:
                        _selectedStatus == status
                            ? Icon(Icons.check, color: Color(0xFFCEFF00))
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
              color: Colors.grey[900],
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
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                ...(_dateRangeOptions.map((range) {
                  return ListTile(
                    title: Text(range, style: TextStyle(color: Colors.white)),
                    trailing:
                        _selectedDateRange == range
                            ? Icon(Icons.check, color: Color(0xFFCEFF00))
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
              color: Colors.grey[900],
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Shipment Status
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getStatusColor(shipment['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
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
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
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
                          color: Color(0xFFCEFF00),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
                      child: ElevatedButton(
                        onPressed: () => _downloadInvoice(shipment),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Fatura İndir'),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _contactCarrier(shipment),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFCEFF00),
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Taşıyıcı İletişim'),
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
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
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
        backgroundColor: Color(0xFFCEFF00),
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
        backgroundColor: Color(0xFFCEFF00),
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
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'active':
        return Colors.blue;
      default:
        return Colors.grey;
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
      {
        'shipmentNo': 'SHP-2024-005',
        'origin': 'Bursa',
        'destination': 'Trabzon',
        'cargoType': 'Otomotiv Parçaları',
        'weight': '2.1 ton',
        'date': '05 Ara 2024',
        'carrier': 'Karadeniz Kargo',
        'driver': 'Osman Korkmaz',
        'plate': '16 JKL 345',
        'recipient': 'Gamze Yıldız',
        'recipientPhone': '+90 542 777 8888',
        'amount': '₺9,400',
        'paymentStatus': 'Ödendi',
        'status': 'delivered',
      },
      {
        'shipmentNo': 'SHP-2024-006',
        'origin': 'Adana',
        'destination': 'İstanbul',
        'cargoType': 'Tarım Ürünleri',
        'weight': '5.8 ton',
        'date': '03 Ara 2024',
        'carrier': 'Akdeniz Nakliyat',
        'driver': 'Serkan Güneş',
        'plate': '01 MNO 678',
        'recipient': 'Elif Erdoğan',
        'recipientPhone': '+90 534 999 0000',
        'amount': '₺18,900',
        'paymentStatus': 'Kısmi Ödeme',
        'status': 'pending',
      },
      {
        'shipmentNo': 'SHP-2024-007',
        'origin': 'Kayseri',
        'destination': 'Samsun',
        'cargoType': 'İnşaat Malzemesi',
        'weight': '7.2 ton',
        'date': '01 Ara 2024',
        'carrier': 'Anadolu Express',
        'driver': 'Kemal Şahin',
        'plate': '38 PQR 901',
        'recipient': 'Sibel Kılıç',
        'recipientPhone': '+90 505 333 4444',
        'amount': '₺25,300',
        'paymentStatus': 'Ödendi',
        'status': 'delivered',
      },
      {
        'shipmentNo': 'SHP-2024-008',
        'origin': 'Gaziantep',
        'destination': 'İstanbul',
        'cargoType': 'Plastik Ürünler',
        'weight': '1.5 ton',
        'date': '28 Kas 2024',
        'carrier': 'Güneydoğu Lojistik',
        'driver': 'Hatice Arslan',
        'plate': '27 STU 234',
        'recipient': 'İbrahim Çiçek',
        'recipientPhone': '+90 536 666 7777',
        'amount': '₺5,800',
        'paymentStatus': 'Beklemede',
        'status': 'active',
      },
      {
        'shipmentNo': 'SHP-2024-009',
        'origin': 'Konya',
        'destination': 'Mersin',
        'cargoType': 'Kimyasal Ürünler',
        'weight': '3.8 ton',
        'date': '25 Kas 2024',
        'carrier': 'Özel Taşımacılık',
        'driver': 'Murat Kaplan',
        'plate': '42 VWX 567',
        'recipient': 'Leyla Özmen',
        'recipientPhone': '+90 544 222 3333',
        'amount': '₺14,700',
        'paymentStatus': 'İptal',
        'status': 'cancelled',
      },
      {
        'shipmentNo': 'SHP-2024-010',
        'origin': 'Eskişehir',
        'destination': 'Denizli',
        'cargoType': 'Teknoloji Ürünleri',
        'weight': '0.8 ton',
        'date': '22 Kas 2024',
        'carrier': 'Hızlı Teslimat',
        'driver': 'Canan Yıldırım',
        'plate': '26 YZA 890',
        'recipient': 'Recep Öz',
        'recipientPhone': '+90 531 888 9999',
        'amount': '₺4,200',
        'paymentStatus': 'Ödendi',
        'status': 'delivered',
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
}
