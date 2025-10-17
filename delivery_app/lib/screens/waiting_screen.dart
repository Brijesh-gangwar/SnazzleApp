
// import 'package:flutter/material.dart';

// import '../widgets/unverified_profile_screen.dart';
// import '../widgets/verification_pending_screen.dart';

// class WaitingHomeScreen extends StatefulWidget {
//   const WaitingHomeScreen({super.key});

//   @override
//   State<WaitingHomeScreen> createState() => _WaitingHomeScreenState();
// }

// class _WaitingHomeScreenState extends State<WaitingHomeScreen> {
//   int _selectedIndex = 0;

//   static const List<Widget> _screens = <Widget>[
//     VerificationScreen(), // The screen showing verification status
//     UnverifiedProfileScreen(), // The simplified profile screen
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Use an IndexedStack to keep the state of both screens alive
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: _screens,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.hourglass_bottom),
//             label: 'Status',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_outline),
//             label: 'Profile',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blue,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/agent_details_provider.dart';
import '../widgets/unverified_profile_screen.dart';
import '../widgets/verification_pending_screen.dart';

class WaitingHomeScreen extends StatefulWidget {
  const WaitingHomeScreen({super.key});

  @override
  State<WaitingHomeScreen> createState() => _WaitingHomeScreenState();
}

class _WaitingHomeScreenState extends State<WaitingHomeScreen> {
  int _selectedIndex = 0;

  // The two screens managed by this parent screen
  static const List<Widget> _widgetOptions = <Widget>[
    VerificationScreen(),
    UnverifiedProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // ✅ Use Future.microtask to safely call the provider after the first frame.
    // This fetches the agent details as soon as the user enters the waiting area.
    Future.microtask(() {
      // Use context.read for a one-time call within initState.
      context.read<AgentDetailsProvider>().fetchAgentDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_empty),
            label: 'Verification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}