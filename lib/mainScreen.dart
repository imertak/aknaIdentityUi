import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/custom_bottom_navigation.dart';
import 'vehiclesManagementScreen.dart';
import 'carrierJobsScreen.dart';
import 'accountScreen.dart';
import 'models/user_type.dart';
import 'providers/user_data_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
        userType: Provider.of<UserDataProvider>(context).userTypeStr,
      ),
    );
  }

  Widget _buildBody() {
    final userProvider = Provider.of<UserDataProvider>(context);
    final userType = userProvider.userType;

    // Her kullanıcı tipi için farklı içerikler gösterilecek
    if (userType == UserType.carrier) {
      switch (_selectedIndex) {
        case 0: // Ana Sayfa
          return Center(child: Text('Ana Sayfa'));
        case 1: // İşler
          return CarrierJobsScreen(userName: userProvider.userName);
        case 2: // Arama
          return Center(child: Text('Arama'));
        case 3: // Araçlar
          return VehiclesManagementScreen();
        case 4: // Profil
          return AccountScreen(
            userName: userProvider.userName,
            userType: userProvider.userTypeStr,
          );
        default:
          return Center(child: Text('Ana Sayfa'));
      }
    } else if (userType == UserType.driver) {
      switch (_selectedIndex) {
        case 0: // Ana Sayfa
          return Center(child: Text('Sürücü Ana Sayfa'));
        case 1: // İşlerim
          return Center(child: Text('Aktif İşlerim'));
        case 2: // Arama
          return Center(child: Text('Arama'));
        case 3: // Rota
          return Center(child: Text('Aktif Rota'));
        case 4: // Profil
          return AccountScreen(
            userName: userProvider.userName,
            userType: userProvider.userTypeStr,
          );
        default:
          return Center(child: Text('Sürücü Ana Sayfa'));
      }
    } else if (userType == UserType.shipper) {
      switch (_selectedIndex) {
        case 0: // Ana Sayfa
          return Center(child: Text('Yük Sahibi Ana Sayfa'));
        case 1: // Taşımalar
          return Center(child: Text('Taşımalarım'));
        case 2: // Arama
          return Center(child: Text('Arama'));
        case 3: // Geçmiş
          return Center(child: Text('Geçmiş Taşımalar'));
        case 4: // Profil
          return AccountScreen(
            userName: userProvider.userName,
            userType: userProvider.userTypeStr,
          );
        default:
          return Center(child: Text('Yük Sahibi Ana Sayfa'));
      }
    }
    // In case of invalid user type
    return Center(child: Text('Geçersiz kullanıcı türü'));
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
