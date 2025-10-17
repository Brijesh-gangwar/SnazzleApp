
// import 'package:flutter/material.dart';
// import 'orders_screen.dart';
// import 'profile_screen.dart';
// import '../services/auth_service.dart';
// import 'login_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;

//   final List<Widget> _screens = [
//     const Center(child: Text("Welcome!\nYou are logged in as Delivery Agent ✅", textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
//     const OrderScreen(),
//     const AgentDetailsScreen(),
    
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   Future<void> _logout() async {
//     final authService = AuthService();
//     await authService.logout();
//     if (context.mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const LoginScreen()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   // title: const Text("Delivery Agent App"),
//       //   actions: [
//       //     IconButton(
//       //       icon: const Icon(Icons.logout),
//       //       onPressed: _logout,
//       //     ),
//       //   ],
//       // ),
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: const [

//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: "Home",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.list_alt),
//             label: "Orders",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: "Profile",
//           ),
          
//         ],
//       ),
//     );
//   }
// }


// home_screen.dart

import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Your screens list remains the same
  static const List<Widget> _screens = [
    DashboardScreen(),

    OrderScreen(),
    AgentDetailsScreen(), // Assuming this is your profile screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ CHANGE THIS: Replace the direct access with an IndexedStack
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[600],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}