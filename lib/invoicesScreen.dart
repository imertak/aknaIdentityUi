// invoices_screen.dart - Modernized
import 'package:flutter/material.dart';

class InvoicesScreen extends StatefulWidget {
  final String userName;

  const InvoicesScreen({Key? key, required this.userName}) : super(key: key);

  @override
  _InvoicesScreenState createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  String _selectedFilter = 'Tümü';
  final List<String> _filterOptions = [
    'Tümü',
    'Ödendi',
    'Beklemede',
    'Gecikmiş',
  ];

  // Mock data - gerçek uygulamada API'den gelecek
  List<Invoice> _allInvoices = [
    Invoice(
      id: 'INV-2024-001',
      shipmentId: 'SHP-2024-001',
      amount: 2500.00,
      date: DateTime.now().subtract(Duration(days: 2)),
      dueDate: DateTime.now().add(Duration(days: 28)),
      status: 'Ödendi',
      customerName: 'ABC Lojistik',
      route: 'İstanbul → Ankara',
      pdfUrl: 'https://example.com/invoice001.pdf',
    ),
    Invoice(
      id: 'INV-2024-002',
      shipmentId: 'SHP-2024-002',
      amount: 1850.00,
      date: DateTime.now().subtract(Duration(days: 5)),
      dueDate: DateTime.now().add(Duration(days: 25)),
      status: 'Beklemede',
      customerName: 'XYZ Nakliyat',
      route: 'İstanbul → İzmir',
      pdfUrl: 'https://example.com/invoice002.pdf',
    ),
    Invoice(
      id: 'INV-2024-003',
      shipmentId: 'SHP-2024-003',
      amount: 3200.00,
      date: DateTime.now().subtract(Duration(days: 45)),
      dueDate: DateTime.now().subtract(Duration(days: 15)),
      status: 'Gecikmiş',
      customerName: 'DEF Kargo',
      route: 'İstanbul → Bursa',
      pdfUrl: 'https://example.com/invoice003.pdf',
    ),
    Invoice(
      id: 'INV-2024-004',
      shipmentId: 'SHP-2024-004',
      amount: 1950.00,
      date: DateTime.now().subtract(Duration(days: 10)),
      dueDate: DateTime.now().add(Duration(days: 20)),
      status: 'Ödendi',
      customerName: 'GHI Taşımacılık',
      route: 'İstanbul → Antalya',
      pdfUrl: 'https://example.com/invoice004.pdf',
    ),
  ];

  int _selectedBottomNavIndex = 3;

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

  List<Invoice> get _filteredInvoices {
    if (_selectedFilter == 'Tümü') {
      return _allInvoices;
    }
    return _allInvoices
        .where((invoice) => invoice.status == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F7),
      body: SafeArea(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildHeader(),
                _buildFilterTabs(),
                _buildSummaryCards(),
                Expanded(child: _buildInvoicesList()),
              ],
            ),
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
                  'Faturalar',
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${_allInvoices.length} fatura listeleniyor',
                  style: TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _showFilterOptions,
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
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final option = _filterOptions[index];
          final isSelected = _selectedFilter == option;

          return Container(
            margin: EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = option;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFF2D3748) : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected ? Color(0xFF2D3748) : Color(0xFFE2E8F0),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Color(0xFF718096),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards() {
    final paidAmount = _allInvoices
        .where((invoice) => invoice.status == 'Ödendi')
        .fold(0.0, (sum, invoice) => sum + invoice.amount);

    final pendingAmount = _allInvoices
        .where((invoice) => invoice.status == 'Beklemede')
        .fold(0.0, (sum, invoice) => sum + invoice.amount);

    final overdueAmount = _allInvoices
        .where((invoice) => invoice.status == 'Gecikmiş')
        .fold(0.0, (sum, invoice) => sum + invoice.amount);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Ödenen',
              '₺${paidAmount.toStringAsFixed(0)}',
              Color(0xFF38A169),
              Icons.check_circle_rounded,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Bekleyen',
              '₺${pendingAmount.toStringAsFixed(0)}',
              Color(0xFFED8936),
              Icons.schedule_rounded,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Gecikmiş',
              '₺${overdueAmount.toStringAsFixed(0)}',
              Color(0xFFE53E3E),
              Icons.warning_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String amount,
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
            title,
            style: TextStyle(
              color: Color(0xFF718096),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6),
          Text(
            amount,
            style: TextStyle(
              color: Color(0xFF2D3748),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoicesList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: ListView.builder(
        itemCount: _filteredInvoices.length,
        itemBuilder: (context, index) {
          final invoice = _filteredInvoices[index];
          return _buildInvoiceCard(invoice);
        },
      ),
    );
  }

  Widget _buildInvoiceCard(Invoice invoice) {
    final statusColor = _getStatusColor(invoice.status);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => _showInvoiceDetails(invoice),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            invoice.id,
                            style: TextStyle(
                              color: Color(0xFF2D3748),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            invoice.customerName,
                            style: TextStyle(
                              color: Color(0xFF718096),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: statusColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        invoice.status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Color(0xFFF7FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Color(0xFFE2E8F0)),
                      ),
                      child: Icon(
                        Icons.local_shipping_rounded,
                        color: Color(0xFF718096),
                        size: 16,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        invoice.route,
                        style: TextStyle(
                          color: Color(0xFF2D3748),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Color(0xFFF7FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Color(0xFFE2E8F0)),
                      ),
                      child: Icon(
                        Icons.calendar_today_rounded,
                        color: Color(0xFF718096),
                        size: 16,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      _formatDate(invoice.date),
                      style: TextStyle(
                        color: Color(0xFF2D3748),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '₺${invoice.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Color(0xFF2D3748),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () => _viewPDF(invoice),
                          icon: Icon(Icons.picture_as_pdf_rounded, size: 18),
                          label: Text('PDF Görüntüle'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xFF2D3748),
                            side: BorderSide(color: Color(0xFFE2E8F0)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () => _sharePDF(invoice),
                          icon: Icon(Icons.share_rounded, size: 18),
                          label: Text('Paylaş'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2D3748),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            shadowColor: Color(0xFF2D3748).withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showInvoiceDetails(Invoice invoice) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder:
                (context, scrollController) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Fatura Detayları',
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
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow('Fatura No', invoice.id),
                              _buildDetailRow(
                                'Sevkiyat No',
                                invoice.shipmentId,
                              ),
                              _buildDetailRow('Müşteri', invoice.customerName),
                              _buildDetailRow('Güzergah', invoice.route),
                              _buildDetailRow(
                                'Fatura Tarihi',
                                _formatDate(invoice.date),
                              ),
                              _buildDetailRow(
                                'Vade Tarihi',
                                _formatDate(invoice.dueDate),
                              ),
                              _buildDetailRow(
                                'Tutar',
                                '₺${invoice.amount.toStringAsFixed(2)}',
                              ),
                              _buildDetailRow('Durum', invoice.status),
                              SizedBox(height: 32),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 52,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _viewPDF(invoice);
                                        },
                                        icon: Icon(
                                          Icons.picture_as_pdf_rounded,
                                        ),
                                        label: Text('PDF Görüntüle'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF2D3748),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              26,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Container(
                                      height: 52,
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _sharePDF(invoice);
                                        },
                                        icon: Icon(Icons.share_rounded),
                                        label: Text('Paylaş'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Color(0xFF2D3748),
                                          side: BorderSide(
                                            color: Color(0xFFE2E8F0),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              26,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(16),
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

  void _viewPDF(Invoice invoice) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF açılıyor...'),
        backgroundColor: Color(0xFF2D3748),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  void _sharePDF(Invoice invoice) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fatura paylaşılıyor...'),
        backgroundColor: Color(0xFF2D3748),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  void _showFilterOptions() {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filtreleme Seçenekleri',
                        style: TextStyle(
                          color: Color(0xFF2D3748),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 20),
                      ..._filterOptions.map(
                        (option) => Container(
                          margin: EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Radio<String>(
                              value: option,
                              groupValue: _selectedFilter,
                              onChanged: (value) {
                                setState(() {
                                  _selectedFilter = value!;
                                });
                                Navigator.pop(context);
                              },
                              activeColor: Color(0xFF2D3748),
                            ),
                            title: Text(
                              option,
                              style: TextStyle(
                                color: Color(0xFF2D3748),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedFilter = option;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ),
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
        break;
      case 2: // Create
        break;
      case 3: // Invoices
        // Already on invoices screen
        break;
      case 4: // Profile
        break;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Ödendi':
        return Color(0xFF38A169);
      case 'Beklemede':
        return Color(0xFFED8936);
      case 'Gecikmiş':
        return Color(0xFFE53E3E);
      default:
        return Color(0xFF718096);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class Invoice {
  final String id;
  final String shipmentId;
  final double amount;
  final DateTime date;
  final DateTime dueDate;
  final String status;
  final String customerName;
  final String route;
  final String pdfUrl;

  Invoice({
    required this.id,
    required this.shipmentId,
    required this.amount,
    required this.date,
    required this.dueDate,
    required this.status,
    required this.customerName,
    required this.route,
    required this.pdfUrl,
  });
}
