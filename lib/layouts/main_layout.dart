import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/user_data_provider.dart';
import '../components/custom_bottom_navigation.dart';
import '../mainDashboardScreen.dart';
import '../carrierJobsScreen.dart';
import '../shipmentHistoryScreen.dart';
import '../vehiclesManagementScreen.dart';
import '../accountScreen.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({Key? key}) : super(key: key);

  Widget _getScreen(BuildContext context, int index, String userType) {
    final userName =
        Provider.of<UserDataProvider>(context, listen: false).userName;

    switch (userType) {
      case "Carrier":
        switch (index) {
          case 0:
            return MainDashboardScreen();
          case 1:
            return CarrierJobsScreen(userName: userName);
          case 2:
            return Container(); // Search screen
          case 3:
            return VehiclesManagementScreen();
          case 4:
            return AccountScreen(userType: userType, userName: userName);
          default:
            return MainDashboardScreen();
        }
      case "Shipper":
        switch (index) {
          case 0:
            return MainDashboardScreen();
          case 1:
            return ShipmentHistoryScreen(userName: userName);
          case 2:
            return Container(); // Search screen
          case 3:
            return ShipmentHistoryScreen(userName: userName);
          case 4:
            return AccountScreen(userType: userType, userName: userName);
          default:
            return MainDashboardScreen();
        }
      case "Driver":
        switch (index) {
          case 0:
            return MainDashboardScreen();
          case 1:
            return CarrierJobsScreen(userName: userName);
          case 2:
            return Container(); // Search screen
          case 3:
            return ShipmentHistoryScreen(userName: userName); // Route screen
          case 4:
            return AccountScreen(userType: userType, userName: userName);
          default:
            return MainDashboardScreen();
        }
      default:
        return MainDashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<NavigationProvider, UserDataProvider>(
      builder: (context, navigationProvider, userDataProvider, child) {
        return Scaffold(
          body: _getScreen(
            context,
            navigationProvider.selectedIndex,
            userDataProvider.userType.toString(),
          ),
          bottomNavigationBar: CustomBottomNavigation(
            selectedIndex: navigationProvider.selectedIndex,
            onItemSelected: (index) {
              navigationProvider.setIndex(index);
            },
            userType: userDataProvider.userType.toString(),
          ),
        );
      },
    );
  }
}
