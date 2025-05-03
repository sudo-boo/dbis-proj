// import 'package:flutter/material.dart';
// import 'home_page.dart';
// import 'categories_page.dart';
// // import 'cart_page.dart';
//
// class NavigationBarPage extends StatefulWidget {
//   const NavigationBarPage({super.key});
//
//   @override
//   State<NavigationBarPage> createState() => _NavigationBarPageState();
// }
//
// class _NavigationBarPageState extends State<NavigationBarPage> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _pages = [
//     HomePage(),
//     CategoriesPage(),
//     // CartPage(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.green[800],
//         unselectedItemColor: Colors.black,
//         selectedFontSize: 12,
//         unselectedFontSize: 12,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_outlined),
//             label: 'Saver',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.grid_view_rounded),
//             label: 'Categories',
//           ),
//           // BottomNavigationBarItem(
//           //   icon: Icon(Icons.shopping_cart_outlined),
//           //   label: 'Cart',
//           // ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'ordersfile.dart';
import 'add_update_stock_page.dart';
import 'profile.dart';  // make sure you have a ProfilePage widget here

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int _selectedIndex = 0;

  // 1. OrdersPage first, then AddUpdateStockPage, then ProfilePage
  final List<Widget> _pages = [
    // pass in an actual list of orders here instead of empty for real data
    OrdersPage(),
    AddUpdateStockPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.black,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Stock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
