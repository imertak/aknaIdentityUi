import 'dart:ui';

import 'package:flutter/material.dart';

class ShipmentDetailScreen extends StatefulWidget {
  final Map<String, dynamic> shipment;

  const ShipmentDetailScreen({Key? key, required this.shipment})
    : super(key: key);

  @override
  _ShipmentDetailScreenState createState() => _ShipmentDetailScreenState();
}

class _ShipmentDetailScreenState extends State<ShipmentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar
            _buildAppBar(),

            // Harita ve Canlı Konum
            _buildLiveLocationSection(),

            // Sevkiyat Detayları
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildShipmentInfoCard(),
                      SizedBox(height: 16),
                      _buildLoadDetailsCard(),
                      SizedBox(height: 16),
                      _buildDocumentsSection(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFD2D2D7), width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF1D1D1F),
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.shipment['trackingNumber'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D1D1F),
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  widget.shipment['description'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF86868B),
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(widget.shipment['status']),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.shipment['status'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveLocationSection() {
    return Container(
      height: 200,
      margin: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFD2D2D7), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Burada gerçek harita entegrasyonu yapılabilir
          Center(
            child: Text(
              'Canlı Konum Haritası',
              style: TextStyle(color: Color(0xFF86868B), fontSize: 16),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFFFF9500),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Mevcut Konum: İstanbul, Avcılar',
                        style: TextStyle(
                          color: Color(0xFF1D1D1F),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '15 dk önce',
                    style: TextStyle(color: Color(0xFF86868B), fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShipmentInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFD2D2D7), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sevkiyat Bilgileri',
              style: TextStyle(
                color: Color(0xFF1D1D1F),
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 16),
            _buildInfoRow('Gönderen', 'Akna Lojistik A.Ş.'),
            _buildInfoRow('Alıcı', 'Teknoloji Çözümleri Ltd. Şti.'),
            _buildInfoRow('Çıkış Yeri', widget.shipment['origin']),
            _buildInfoRow('Varış Yeri', widget.shipment['destination']),
            _buildInfoRow('Tarih', widget.shipment['date']),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFD2D2D7), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Yük Detayları',
              style: TextStyle(
                color: Color(0xFF1D1D1F),
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 16),
            _buildInfoRow('Yük Tipi', 'Elektronik Ekipman'),
            _buildInfoRow('Ağırlık', '1.250 kg'),
            _buildInfoRow('Hacim', '4.5 m³'),
            _buildInfoRow('Paket Sayısı', '12 Adet'),
            _buildInfoRow('Özel Notlar', 'Kırılgan malzeme, özenle taşınmalı'),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFD2D2D7), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Belgeler',
              style: TextStyle(
                color: Color(0xFF1D1D1F),
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 16),
            _buildDocumentItem('İrsaliye', 'AKN-2023-001-İRS'),
            _buildDocumentItem('Fatura', 'AKN-2023-001-FTR'),
            _buildDocumentItem('Taşıma İzin Belgesi', 'AKN-2023-001-TİB'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF86868B),
              fontSize: 15,
              letterSpacing: -0.2,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF1D1D1F),
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(String title, String code) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF1D1D1F),
              fontSize: 15,
              letterSpacing: -0.2,
            ),
          ),
          Row(
            children: [
              Text(
                code,
                style: TextStyle(
                  color: Color(0xFF86868B),
                  fontSize: 15,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.download_rounded, color: Color(0xFFFF9500), size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Yolda':
        return Color(0xFF007AFF);
      case 'Tamamlandı':
        return Color(0xFF34C759);
      case 'Bekliyor':
        return Color(0xFFFF9500);
      default:
        return Color(0xFF86868B);
    }
  }
}
