// pubspec.yaml dependencies to add:
// flutter_map: ^6.0.1
// latlong2: ^0.9.1
// geocoding: ^2.1.1
// http: ^1.1.0

// screens/create_shipment_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class CreateShipmentScreen extends StatefulWidget {
  @override
  _CreateShipmentScreenState createState() => _CreateShipmentScreenState();
}

class _CreateShipmentScreenState extends State<CreateShipmentScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Form Controllers
  final _pickupLocationController = TextEditingController();
  final _deliveryLocationController = TextEditingController();
  final _cargoDescriptionController = TextEditingController();
  final _weightController = TextEditingController();
  final _volumeController = TextEditingController();
  final _notesController = TextEditingController();

  // Form State
  String _selectedCargoType = 'Genel Kargo';
  String _selectedVehicleType = 'Kamyon';
  String _selectedUrgency = 'Normal';
  DateTime? _pickupDateTime;
  DateTime? _deliveryDateTime;
  bool _isInsuranceRequired = false;
  bool _isFragile = false;
  bool _requiresSpecialHandling = false;

  // Map State
  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  List<Polyline> _polylines = [];
  LatLng? _pickupLatLng;
  LatLng? _deliveryLatLng;
  bool _showRoute = false;
  double? _estimatedDistance;
  double? _estimatedPrice;
  Timer? _debounceTimer;

  // Initial map center (Turkey)
  static const LatLng _turkeyCenter = LatLng(39.9334, 32.8597);

  final List<String> _cargoTypes = [
    'Genel Kargo',
    'Elektronik',
    'Tekstil',
    'Gıda',
    'Otomotiv',
    'İnşaat Malzemesi',
    'Kimyasal',
    'Kırılabilir',
    'Diğer',
  ];

  final List<String> _vehicleTypes = [
    'Kamyon',
    'Minibüs',
    'Pickup',
    'Kamyonet',
    'Çekici',
    'Konteyner',
  ];

  final List<String> _urgencyLevels = ['Normal', 'Acil', 'Çok Acil'];

  // Turkish month and day names
  static const List<String> _turkishMonths = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];

  static const List<String> _turkishDays = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
  ];

  String _formatTurkishDate(DateTime date) {
    final day = date.day;
    final month = _turkishMonths[date.month - 1];
    final year = date.year;
    final weekday = _turkishDays[date.weekday - 1];
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day $month $year, $weekday $hour:$minute';
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    if (difference.inDays > 0) {
      return '${difference.inDays} gün sonra';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat sonra';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika sonra';
    } else {
      return 'Şimdi';
    }
  }

  // Turkish cities coordinates for fallback
  final Map<String, LatLng> _turkishCities = {
    'istanbul': LatLng(41.0082, 28.9784),
    'ankara': LatLng(39.9334, 32.8597),
    'izmir': LatLng(38.4192, 27.1287),
    'bursa': LatLng(40.1826, 29.0665),
    'antalya': LatLng(36.8969, 30.7133),
    'adana': LatLng(37.0000, 35.3213),
    'konya': LatLng(37.8746, 32.4932),
    'gaziantep': LatLng(37.0662, 37.3833),
    'şanlıurfa': LatLng(37.1591, 38.7969),
    'kocaeli': LatLng(40.8533, 29.8815),
    'mersin': LatLng(36.8121, 34.6415),
    'diyarbakır': LatLng(37.9144, 40.2306),
    'kayseri': LatLng(38.7312, 35.4787),
    'eskişehir': LatLng(39.7767, 30.5206),
    'urfa': LatLng(37.1591, 38.7969),
    'malatya': LatLng(38.3552, 38.3095),
    'kahramanmaraş': LatLng(37.5858, 36.9371),
    'erzurum': LatLng(39.9000, 41.2700),
    'van': LatLng(38.4891, 43.4089),
    'batman': LatLng(37.8812, 41.1351),
    'elazığ': LatLng(38.6810, 39.2264),
    'iğdır': LatLng(39.8880, 44.0048),
    'tekirdağ': LatLng(40.9833, 27.5167),
    'balıkesir': LatLng(39.6484, 27.8826),
    'trabzon': LatLng(41.0015, 39.7178),
    'manisa': LatLng(38.6191, 27.4289),
    'samsun': LatLng(41.2928, 36.3313),
    'aydın': LatLng(37.8560, 27.8416),
    'denizli': LatLng(37.7765, 29.0864),
    'muğla': LatLng(37.2153, 28.3636),
    'afyon': LatLng(38.7507, 30.5567),
    'mardin': LatLng(37.3212, 40.7245),
    'tokat': LatLng(40.3167, 36.5500),
    'çorum': LatLng(40.5506, 34.9556),
    'ordu': LatLng(40.9839, 37.8764),
    'kırıkkale': LatLng(39.8467, 33.5153),
    'kırşehir': LatLng(39.1425, 34.1709),
    'uşak': LatLng(38.6823, 29.4082),
    'düzce': LatLng(40.8438, 31.1565),
    'osmaniye': LatLng(37.0742, 36.2477),
    'çankırı': LatLng(40.6013, 33.6134),
  };

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _setupLocationListeners();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  void _setupLocationListeners() {
    _pickupLocationController.addListener(_onLocationChanged);
    _deliveryLocationController.addListener(_onLocationChanged);
  }

  void _onLocationChanged() {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // Start new timer
    _debounceTimer = Timer(Duration(milliseconds: 1500), () {
      if (_pickupLocationController.text.isNotEmpty &&
          _deliveryLocationController.text.isNotEmpty) {
        _geocodeAddresses();
      } else {
        setState(() {
          _showRoute = false;
          _markers.clear();
          _polylines.clear();
          _estimatedDistance = null;
          _estimatedPrice = null;
        });
      }
    });
  }

  Future<LatLng?> _geocodeWithNominatim(String address) async {
    try {
      // Clean and prepare the address for better search
      String cleanAddress = address.trim();

      // First try with detailed search
      var queries = [
        '$cleanAddress, Turkey',
        '$cleanAddress, Türkiye',
        cleanAddress,
      ];

      for (String query in queries) {
        final encodedQuery = Uri.encodeComponent(query);
        final url =
            'https://nominatim.openstreetmap.org/search?q=$encodedQuery&format=json&limit=5&countrycodes=tr&addressdetails=1';

        print('Trying Nominatim query: $query');

        final response = await http
            .get(Uri.parse(url), headers: {'User-Agent': 'AknaApp/1.0'})
            .timeout(Duration(seconds: 15));

        if (response.statusCode == 200) {
          final List<dynamic> results = json.decode(response.body);
          print('Nominatim results count: ${results.length}');

          if (results.isNotEmpty) {
            // Prefer results with higher importance or specific address details
            var bestResult = results.first;
            for (var result in results) {
              final importance =
                  double.tryParse(result['importance']?.toString() ?? '0') ?? 0;
              final bestImportance =
                  double.tryParse(
                    bestResult['importance']?.toString() ?? '0',
                  ) ??
                  0;

              // Prefer results with street/district information
              if (result['address'] != null) {
                final address = result['address'];
                if (address['road'] != null ||
                    address['suburb'] != null ||
                    address['district'] != null) {
                  if (importance >= bestImportance) {
                    bestResult = result;
                  }
                }
              }
            }

            print('Selected result: ${bestResult['display_name']}');
            return LatLng(
              double.parse(bestResult['lat']),
              double.parse(bestResult['lon']),
            );
          }
        }

        // Wait between requests to respect rate limits
        await Future.delayed(Duration(milliseconds: 500));
      }
    } catch (e) {
      print('Nominatim geocoding error: $e');
    }
    return null;
  }

  Future<double> _calculateRoadDistance(LatLng start, LatLng end) async {
    try {
      // Use OSRM (Open Source Routing Machine) for road distance
      final url =
          'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=false&alternatives=false&steps=false';

      final response = await http
          .get(Uri.parse(url), headers: {'User-Agent': 'AknaApp/1.0'})
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final distance =
              data['routes'][0]['distance'] / 1000.0; // Convert to km
          final duration =
              data['routes'][0]['duration'] / 60.0; // Convert to minutes

          print('Road distance: ${distance.toStringAsFixed(1)} km');
          print('Estimated duration: ${duration.toStringAsFixed(0)} minutes');

          return distance;
        }
      }
    } catch (e) {
      print('Road distance calculation error: $e');
    }

    // Fallback to direct distance with road factor
    final Distance distance = Distance();
    final directDistance = distance.as(LengthUnit.Kilometer, start, end);

    // Apply road factor (typically roads are 1.2-1.5x longer than direct distance)
    return directDistance * 1.3;
  }

  LatLng? _findCityInFallback(String input) {
    final cleanInput =
        input
            .toLowerCase()
            .replaceAll('ı', 'i')
            .replaceAll('ğ', 'g')
            .replaceAll('ü', 'u')
            .replaceAll('ş', 's')
            .replaceAll('ö', 'o')
            .replaceAll('ç', 'c')
            .trim();

    // Split input into words for better matching
    final words = cleanInput.split(RegExp(r'[\s,]+'));

    // Direct city match
    for (String city in _turkishCities.keys) {
      if (words.contains(city) || cleanInput.contains(city)) {
        return _turkishCities[city];
      }
    }

    // Partial match for city names
    for (String city in _turkishCities.keys) {
      for (String word in words) {
        if (word.length >= 3 && (city.contains(word) || word.contains(city))) {
          return _turkishCities[city];
        }
      }
    }

    return null;
  }

  Future<void> _geocodeAddresses() async {
    try {
      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text('Adresler kontrol ediliyor...'),
              ],
            ),
            backgroundColor: Colors.grey[800],
            duration: Duration(seconds: 3),
          ),
        );
      }

      LatLng? pickupLocation;
      LatLng? deliveryLocation;

      // Try multiple geocoding methods for pickup
      try {
        List<Location> pickupLocations = await locationFromAddress(
          _pickupLocationController.text + ', Turkey',
        );
        if (pickupLocations.isNotEmpty) {
          pickupLocation = LatLng(
            pickupLocations.first.latitude,
            pickupLocations.first.longitude,
          );
        }
      } catch (e) {
        print('Flutter geocoding failed for pickup: $e');
      }

      // Fallback to Nominatim for pickup
      if (pickupLocation == null) {
        pickupLocation = await _geocodeWithNominatim(
          _pickupLocationController.text,
        );
      }

      // Fallback to city database for pickup
      if (pickupLocation == null) {
        pickupLocation = _findCityInFallback(_pickupLocationController.text);
      }

      // Try multiple geocoding methods for delivery
      try {
        List<Location> deliveryLocations = await locationFromAddress(
          _deliveryLocationController.text + ', Turkey',
        );
        if (deliveryLocations.isNotEmpty) {
          deliveryLocation = LatLng(
            deliveryLocations.first.latitude,
            deliveryLocations.first.longitude,
          );
        }
      } catch (e) {
        print('Flutter geocoding failed for delivery: $e');
      }

      // Fallback to Nominatim for delivery
      if (deliveryLocation == null) {
        deliveryLocation = await _geocodeWithNominatim(
          _deliveryLocationController.text,
        );
      }

      // Fallback to city database for delivery
      if (deliveryLocation == null) {
        deliveryLocation = _findCityInFallback(
          _deliveryLocationController.text,
        );
      }

      if (pickupLocation != null && deliveryLocation != null) {
        _pickupLatLng = pickupLocation;
        _deliveryLatLng = deliveryLocation;
        await _updateMapWithRoute();

        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Adresler bulundu! Yol mesafesi hesaplanıyor...'),
                ],
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Adres bulunamadı!'),
                  SizedBox(height: 4),
                  Text(
                    'Örnekler: "İstanbul Kadıköy Moda", "Ankara Çankaya Kızılay", "İzmir Konak Alsancak"',
                    style: TextStyle(fontSize: 12, color: Colors.orange[200]),
                  ),
                ],
              ),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bir hata oluştu. Lütfen tekrar deneyin.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('Geocoding error: $e');
    }
  }

  Future<void> _updateMapWithRoute() async {
    if (_pickupLatLng != null && _deliveryLatLng != null) {
      // Calculate road distance
      final roadDistance = await _calculateRoadDistance(
        _pickupLatLng!,
        _deliveryLatLng!,
      );

      setState(() {
        _showRoute = true;
        _estimatedDistance = roadDistance;
        _estimatedPrice = _calculatePrice();

        // Clear existing markers and polylines
        _markers.clear();
        _polylines.clear();

        // Add pickup marker
        _markers.add(
          Marker(
            point: _pickupLatLng!,
            width: 60,
            height: 60,
            child: Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(Icons.upload, color: Colors.white, size: 20),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2),
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'BAŞLANGIÇ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Add delivery marker
        _markers.add(
          Marker(
            point: _deliveryLatLng!,
            width: 60,
            height: 60,
            child: Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(Icons.flag, color: Colors.white, size: 20),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2),
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'VARIŞ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Add route polyline
        _polylines.add(
          Polyline(
            points: [_pickupLatLng!, _deliveryLatLng!],
            color: Color(0xFFCEFF00),
            strokeWidth: 4.0,
          ),
        );
      });

      // Animate map to show both points
      _fitMapToMarkers();
    }
  }

  void _fitMapToMarkers() {
    if (_pickupLatLng != null && _deliveryLatLng != null) {
      // Calculate center and zoom level manually
      final center = LatLng(
        (_pickupLatLng!.latitude + _deliveryLatLng!.latitude) / 2,
        (_pickupLatLng!.longitude + _deliveryLatLng!.longitude) / 2,
      );

      // Calculate zoom based on distance
      final distance = _estimatedDistance ?? 100;
      double zoom = 6.0;
      if (distance < 50)
        zoom = 10.0;
      else if (distance < 200)
        zoom = 8.0;
      else if (distance < 500)
        zoom = 7.0;

      _mapController.move(center, zoom);
    }
  }

  double _calculateDistance() {
    if (_pickupLatLng != null && _deliveryLatLng != null) {
      final Distance distance = Distance();
      return distance.as(
        LengthUnit.Kilometer,
        _pickupLatLng!,
        _deliveryLatLng!,
      );
    }
    return 0;
  }

  double _calculatePrice() {
    if (_estimatedDistance == null) return 0;

    double basePrice = _estimatedDistance! * 2.5; // Base rate per km

    // Apply multipliers based on cargo and vehicle type
    switch (_selectedCargoType) {
      case 'Elektronik':
      case 'Kırılabilir':
        basePrice *= 1.3;
        break;
      case 'Kimyasal':
        basePrice *= 1.5;
        break;
    }

    switch (_selectedVehicleType) {
      case 'Çekici':
      case 'Konteyner':
        basePrice *= 1.4;
        break;
      case 'Pickup':
        basePrice *= 0.8;
        break;
    }

    switch (_selectedUrgency) {
      case 'Acil':
        basePrice *= 1.2;
        break;
      case 'Çok Acil':
        basePrice *= 1.5;
        break;
    }

    return basePrice;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _fadeController.dispose();
    _slideController.dispose();
    _pickupLocationController.dispose();
    _deliveryLocationController.dispose();
    _cargoDescriptionController.dispose();
    _weightController.dispose();
    _volumeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildMapSection(),
              _buildFormSection(),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Yük Oluştur',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.save_outlined, color: Color(0xFFCEFF00)),
          onPressed: _saveDraft,
        ),
      ],
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 280,
      margin: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // OpenStreetMap using flutter_map
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _turkeyCenter,
                initialZoom: 6.0,
                minZoom: 5.0,
                maxZoom: 18.0,
                interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                if (_polylines.isNotEmpty) PolylineLayer(polylines: _polylines),
                if (_markers.isNotEmpty) MarkerLayer(markers: _markers),
              ],
            ),

            // Dark overlay for better contrast
            Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
            ),

            // Map Controls
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.my_location,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        _mapController.move(_turkeyCenter, 6.0);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh, color: Colors.white, size: 20),
                      onPressed: () {
                        if (_pickupLocationController.text.isNotEmpty &&
                            _deliveryLocationController.text.isNotEmpty) {
                          _geocodeAddresses();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Route Info Overlay
            if (_showRoute && _estimatedDistance != null)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xFFCEFF00).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildRouteInfo(
                        Icons.straighten,
                        '${_estimatedDistance!.toStringAsFixed(1)} km',
                        'Mesafe',
                      ),
                      Container(width: 1, height: 30, color: Colors.grey[600]),
                      _buildRouteInfo(
                        Icons.access_time,
                        '${(_estimatedDistance! / 70).toStringAsFixed(1)}s',
                        'Tahmini Süre',
                      ),
                      Container(width: 1, height: 30, color: Colors.grey[600]),
                      _buildRouteInfo(
                        Icons.attach_money,
                        '₺${_estimatedPrice!.toStringAsFixed(0)}',
                        'Tahmini',
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

  Widget _buildRouteInfo(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Color(0xFFCEFF00), size: 16),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 10)),
      ],
    );
  }

  Widget _buildFormSection() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Lokasyon Bilgileri', Icons.location_on),
            SizedBox(height: 16),
            _buildLocationFields(),

            SizedBox(height: 32),
            _buildSectionTitle('Kargo Bilgileri', Icons.inventory_2),
            SizedBox(height: 16),
            _buildCargoFields(),

            SizedBox(height: 32),
            _buildSectionTitle('Taşıma Detayları', Icons.local_shipping),
            SizedBox(height: 16),
            _buildTransportFields(),

            SizedBox(height: 32),
            _buildSectionTitle('Ek Bilgiler', Icons.note),
            SizedBox(height: 16),
            _buildAdditionalFields(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFCEFF00).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Color(0xFFCEFF00), size: 20),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationFields() {
    return Column(
      children: [
        _buildTextField(
          controller: _pickupLocationController,
          label: 'Alım Yeri',
          hint: 'Tam adres girin (örn: İstanbul Kadıköy Moda Caddesi)',
          icon: Icons.upload,
          iconColor: Colors.green,
        ),
        SizedBox(height: 16),
        _buildTextField(
          controller: _deliveryLocationController,
          label: 'Teslim Yeri',
          hint: 'Tam adres girin (örn: Ankara Çankaya Kızılay Meydanı)',
          icon: Icons.download,
          iconColor: Colors.red,
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDateTimeField(
                label: 'Alım Tarihi & Saati',
                selectedDateTime: _pickupDateTime,
                onDateTimeSelected:
                    (dateTime) => setState(() => _pickupDateTime = dateTime),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildDateTimeField(
                label: 'Teslim Tarihi & Saati',
                selectedDateTime: _deliveryDateTime,
                onDateTimeSelected:
                    (dateTime) => setState(() => _deliveryDateTime = dateTime),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCargoFields() {
    return Column(
      children: [
        _buildDropdownField(
          label: 'Kargo Türü',
          value: _selectedCargoType,
          items: _cargoTypes,
          onChanged: (value) {
            setState(() {
              _selectedCargoType = value!;
              _estimatedPrice = _calculatePrice(); // Recalculate price
            });
          },
          icon: Icons.category,
        ),
        SizedBox(height: 16),
        _buildTextField(
          controller: _cargoDescriptionController,
          label: 'Kargo Açıklaması',
          hint: 'Kargo içeriğini detaylandırın',
          icon: Icons.description,
          maxLines: 2,
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _weightController,
                label: 'Ağırlık (kg)',
                hint: '0',
                icon: Icons.scale,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _volumeController,
                label: 'Hacim (m³)',
                hint: '0',
                icon: Icons.cable_outlined,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransportFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                label: 'Araç Türü',
                value: _selectedVehicleType,
                items: _vehicleTypes,
                onChanged: (value) {
                  setState(() {
                    _selectedVehicleType = value!;
                    _estimatedPrice = _calculatePrice(); // Recalculate price
                  });
                },
                icon: Icons.local_shipping,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildDropdownField(
                label: 'Aciliyet',
                value: _selectedUrgency,
                items: _urgencyLevels,
                onChanged: (value) {
                  setState(() {
                    _selectedUrgency = value!;
                    _estimatedPrice = _calculatePrice(); // Recalculate price
                  });
                },
                icon: Icons.speed,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        _buildCheckboxOptions(),
      ],
    );
  }

  Widget _buildCheckboxOptions() {
    return Column(
      children: [
        _buildCheckboxTile(
          title: 'Sigorta Gerekli',
          subtitle: 'Kargo için sigorta yaptırılsın',
          value: _isInsuranceRequired,
          onChanged: (value) => setState(() => _isInsuranceRequired = value!),
          icon: Icons.shield,
        ),
        _buildCheckboxTile(
          title: 'Kırılabilir',
          subtitle: 'Özel dikkat gerektiren kargo',
          value: _isFragile,
          onChanged: (value) => setState(() => _isFragile = value!),
          icon: Icons.warning,
        ),
        _buildCheckboxTile(
          title: 'Özel Elleçleme',
          subtitle: 'Yükleme/boşaltmada özel ekipman gerekli',
          value: _requiresSpecialHandling,
          onChanged:
              (value) => setState(() => _requiresSpecialHandling = value!),
          icon: Icons.precision_manufacturing,
        ),
      ],
    );
  }

  Widget _buildAdditionalFields() {
    return Column(
      children: [
        _buildTextField(
          controller: _notesController,
          label: 'Ek Notlar',
          hint: 'Özel talimatlar, iletişim bilgileri vs.',
          icon: Icons.note,
          maxLines: 3,
        ),
        SizedBox(height: 16),
        if (_estimatedPrice != null)
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFCEFF00).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFCEFF00).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.calculate, color: Color(0xFFCEFF00), size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tahmini Maliyet',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '₺${_estimatedPrice!.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Color(0xFFCEFF00),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Tahmini',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    Color? iconColor,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[800]!),
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(color: Colors.white),
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[600]),
              prefixIcon: Icon(
                icon,
                color: iconColor ?? Color(0xFFCEFF00),
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[800]!),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            items:
                items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
            onChanged: onChanged,
            style: TextStyle(color: Colors.white),
            dropdownColor: Colors.grey[900],
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Color(0xFFCEFF00), size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeField({
    required String label,
    required DateTime? selectedDateTime,
    required Function(DateTime) onDateTimeSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showModernDateTimePicker(onDateTimeSelected),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Color(0xFFCEFF00), size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedDateTime != null
                            ? _formatTurkishDate(selectedDateTime!)
                            : 'Tarih ve saat seçin',
                        style: TextStyle(
                          color:
                              selectedDateTime != null
                                  ? Colors.white
                                  : Colors.grey[600],
                          fontSize: 16,
                          fontWeight:
                              selectedDateTime != null
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                        ),
                      ),
                      if (selectedDateTime != null)
                        Text(
                          _getTimeAgo(selectedDateTime!),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(Icons.access_time, color: Color(0xFFCEFF00), size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showModernDateTimePicker(
    Function(DateTime) onDateTimeSelected,
  ) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => ModernDateTimePicker(
            onDateTimeSelected: onDateTimeSelected,
            initialDateTime: DateTime.now(),
          ),
    );
  }

  Widget _buildCheckboxTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool?) onChanged,
    required IconData icon,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: CheckboxListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
        secondary: Icon(icon, color: Color(0xFFCEFF00)),
        value: value,
        onChanged: onChanged,
        activeColor: Color(0xFFCEFF00),
        checkColor: Colors.black,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(top: BorderSide(color: Colors.grey[800]!, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _saveDraft,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFFCEFF00)),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Taslak Kaydet',
                    style: TextStyle(
                      color: Color(0xFFCEFF00),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _createShipment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFCEFF00),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Yük Oluştur',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveDraft() {
    // Save draft logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Taslak kaydedildi'),
        backgroundColor: Color(0xFFCEFF00),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _createShipment() {
    if (_validateForm()) {
      // Create shipment logic
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text('Başarılı!', style: TextStyle(color: Colors.white)),
              content: Text(
                'Yükünüz başarıyla oluşturuldu!\nTaşıyıcılar kısa sürede tekliflerini gönderecek.',
                style: TextStyle(color: Colors.grey[300]),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Tamam',
                    style: TextStyle(color: Color(0xFFCEFF00)),
                  ),
                ),
              ],
            ),
      );
    }
  }

  bool _validateForm() {
    if (_pickupLocationController.text.isEmpty) {
      _showValidationError('Alım yeri zorunludur');
      return false;
    }
    if (_deliveryLocationController.text.isEmpty) {
      _showValidationError('Teslim yeri zorunludur');
      return false;
    }
    if (_cargoDescriptionController.text.isEmpty) {
      _showValidationError('Kargo açıklaması zorunludur');
      return false;
    }
    if (_weightController.text.isEmpty) {
      _showValidationError('Ağırlık bilgisi zorunludur');
      return false;
    }
    if (_pickupDateTime == null) {
      _showValidationError('Alım tarihi ve saati seçilmelidir');
      return false;
    }
    if (_deliveryDateTime == null) {
      _showValidationError('Teslim tarihi ve saati seçilmelidir');
      return false;
    }
    if (_deliveryDateTime!.isBefore(_pickupDateTime!)) {
      _showValidationError('Teslim tarihi alım tarihinden önce olamaz');
      return false;
    }
    return true;
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ModernDateTimePicker widget
class ModernDateTimePicker extends StatefulWidget {
  final Function(DateTime) onDateTimeSelected;
  final DateTime initialDateTime;

  const ModernDateTimePicker({
    Key? key,
    required this.onDateTimeSelected,
    required this.initialDateTime,
  }) : super(key: key);

  @override
  _ModernDateTimePickerState createState() => _ModernDateTimePickerState();
}

class _ModernDateTimePickerState extends State<ModernDateTimePicker> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  bool isSelectingDate = true;

  static const List<String> _turkishMonths = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];

  static const List<String> _turkishDaysShort = [
    'Pzt',
    'Sal',
    'Çar',
    'Per',
    'Cum',
    'Cmt',
    'Paz',
  ];

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime(
      widget.initialDateTime.year,
      widget.initialDateTime.month,
      widget.initialDateTime.day,
    );
    selectedTime = TimeOfDay.fromDateTime(widget.initialDateTime);
  }

  @override
  Widget build(BuildContext context) {
    // Modern picker UI burada olacak (örnek, sade bir görünüm):
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Tarih ve Saat Seç',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          // Tarih seçici
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
                builder:
                    (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.dark(
                          primary: Color(0xFFCEFF00),
                          surface: Colors.grey[900]!,
                        ),
                      ),
                      child: child!,
                    ),
              );
              if (picked != null) {
                setState(() {
                  selectedDate = picked;
                });
              }
            },
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Color(0xFFCEFF00)),
                SizedBox(width: 12),
                Text(
                  '${selectedDate.day} ${_turkishMonths[selectedDate.month - 1]} ${selectedDate.year}',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Saat seçici
          GestureDetector(
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: selectedTime,
                builder:
                    (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.dark(
                          primary: Color(0xFFCEFF00),
                          surface: Colors.grey[900]!,
                        ),
                      ),
                      child: child!,
                    ),
              );
              if (picked != null) {
                setState(() {
                  selectedTime = picked;
                });
              }
            },
            child: Row(
              children: [
                Icon(Icons.access_time, color: Color(0xFFCEFF00)),
                SizedBox(width: 12),
                Text(
                  '${selectedTime.format(context)}',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final result = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute,
              );
              widget.onDateTimeSelected(result);
              Navigator.pop(context);
            },
            child: Text('Onayla'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFCEFF00),
              foregroundColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
