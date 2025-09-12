import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_type.dart';
import '../providers/user_data_provider.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final String userType;

  const CustomBottomNavigation({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.userType,
  }) : super(key: key);

  static const Color _backgroundColor = Color(0xFF1A1A1A);
  static const Color _selectedColor = Colors.white;
  static const Color _unselectedColor = Color(0xFF666666);

  List<NavItem> _getNavItems() {
    final userTypeEnum = UserType.fromString(userType);
    switch (userTypeEnum) {
      case UserType.carrier:
        return [
          NavItem(icon: Icons.home_outlined, label: 'Ana Sayfa'),
          NavItem(icon: Icons.work_outline, label: 'İşler'),
          NavItem(icon: Icons.search, label: 'Arama'),
          NavItem(icon: Icons.local_shipping_outlined, label: 'Araçlar'),
          NavItem(icon: Icons.person_outline, label: 'Profil'),
        ];
      case UserType.driver:
        return [
          NavItem(icon: Icons.home_outlined, label: 'Ana Sayfa'),
          NavItem(icon: Icons.work_outline, label: 'İşlerim'),
          NavItem(icon: Icons.search, label: 'Arama'),
          NavItem(icon: Icons.route_outlined, label: 'Rota'),
          NavItem(icon: Icons.person_outline, label: 'Profil'),
        ];
      case UserType.shipper:
        return [
          NavItem(icon: Icons.home_outlined, label: 'Ana Sayfa'),
          NavItem(icon: Icons.local_shipping_outlined, label: 'Taşımalar'),
          NavItem(icon: Icons.search, label: 'Arama'),
          NavItem(icon: Icons.history_outlined, label: 'Geçmiş'),
          NavItem(icon: Icons.person_outline, label: 'Profil'),
        ];
      default:
        return [
          NavItem(icon: Icons.home_outlined, label: 'Ana Sayfa'),
          NavItem(icon: Icons.search, label: 'Arama'),
          NavItem(icon: Icons.local_shipping_outlined, label: 'Taşımalar'),
          NavItem(icon: Icons.history_outlined, label: 'Geçmiş'),
          NavItem(icon: Icons.person_outline, label: 'Profil'),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final navItems = _getNavItems();
    return Container(
      height: 80,
      decoration: BoxDecoration(color: _backgroundColor),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(navItems.length, (index) {
              final item = navItems[index];
              final bool isCenter = index == (navItems.length ~/ 2);
              if (isCenter) {
                return SizedBox(width: 70); // Space for center button
              }
              return _buildNavItem(item, index);
            }),
          ),
          Center(child: _buildSearchButton(navItems[2])),
        ],
      ),
    );
  }

  Widget _buildNavItem(NavItem item, int index) {
    final bool isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => onItemSelected(index),
      child: Container(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              color: isSelected ? _selectedColor : _unselectedColor,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                color: isSelected ? _selectedColor : _unselectedColor,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchButton(NavItem item) {
    return GestureDetector(
      onTap: () => onItemSelected(2),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(item.icon, color: _backgroundColor, size: 28),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;

  NavItem({required this.icon, required this.label});
}
