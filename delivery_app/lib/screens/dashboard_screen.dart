// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart'; // Import the shimmer package

// import '../models/agent_details_model.dart';
// import '../models/order_model.dart';
// import '../providers/order_provider.dart';
// import '../services/details_service.dart';
// import '../widgets/order_card.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   final DetailsService _detailsService = DetailsService();
//   late Future<AgentDetailsModel> _agentDetailsFuture;
//   bool _isOnline = true;
//   bool _deliveringOrdersFetched = false;

//   @override
//   void initState() {
//     super.initState();
//     _agentDetailsFuture = _detailsService.fetchAgentDetails();
//   }

//   void _fetchDeliveringOrders(String employeeId) {
//     final provider = Provider.of<OrderProvider>(context, listen: false);
//     if (provider.deliveringOrders().isEmpty) {
//       provider.fetchOrders(
//         employeeId: employeeId,
//         deliveryAgentStatus: "Delivering",
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<AgentDetailsModel>(
//         future: _agentDetailsFuture,
//         builder: (context, snapshot) {
//           // **Show shimmer effect while waiting for data**
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return _buildShimmerEffect();
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }
//           if (!snapshot.hasData) {
//             return const Center(child: Text("No agent data found."));
//           }

//           final agent = snapshot.data!;
//           final firstName = agent.fullName?.split(' ').first ?? 'Agent';

//           if (!_deliveringOrdersFetched && agent.employeeId != null) {
//             _fetchDeliveringOrders(agent.employeeId!);
//             _deliveringOrdersFetched = true;
//           }

//           return SafeArea(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Hello, $firstName', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   const Text('Ready to deliver fashion?', style: TextStyle(fontSize: 16, color: Colors.grey)),
//                   const SizedBox(height: 24),
//                   _buildOnlineCard(),
//                   const SizedBox(height: 24),
//                   const Text('Today', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 16),
//                   _buildTodayStats(agent),
//                   const SizedBox(height: 24),
//                   const Text('Currently Delivering', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 16),
//                   _buildDeliveringOrdersSection(),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // Widget to display the list of delivering orders
//   Widget _buildDeliveringOrdersSection() {
//     return Consumer<OrderProvider>(
//       builder: (context, provider, child) {
//         final List<OrderModel> orders = provider.deliveringOrders();
//         final bool isLoading = provider.isLoading("Delivering");

//         // **Show shimmer for the order list while it's loading**
//         if (isLoading && orders.isEmpty) {
//           return _buildOrderListShimmer();
//         }

//         if (orders.isEmpty) {
//           return Card(
//             elevation: 2,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             child: const Padding(
//               padding: EdgeInsets.all(24.0),
//               child: Center(
//                 child: Text(
//                   "No orders are currently being delivered.",
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           );
//         }

//         return ListView.separated(
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: orders.length,
//           itemBuilder: (context, index) {
//             return OrderCard(order: orders[index]);
//           },
//           separatorBuilder: (context, index) => const SizedBox(height: 12),
//         );
//       },
//     );
//   }
  
//   // --- UI Helper Widgets (Online Card, Stats) ---

//   Widget _buildOnlineCard() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         child: Row(
//           children: [
//             const Icon(Icons.flash_on, color: Colors.amber, size: 30),
//             const SizedBox(width: 16),
//             const Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Online', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                   Text('Available for deliveries', style: TextStyle(color: Colors.grey)),
//                 ],
//               ),
//             ),
//             Switch(
//               value: _isOnline,
//               onChanged: (value) => setState(() => _isOnline = value),
//               activeColor: Colors.black,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTodayStats(AgentDetailsModel agent) {
//     return Row(
//       children: [
//         Expanded(child: _buildStatCard('3.2 km', 'Distance')),
//         const SizedBox(width: 12),
//         Expanded(child: _buildStatCard('0h 0m', 'Active Ti...')),
//         const SizedBox(width: 12),
//         Expanded(child: _buildStatCard(agent.deliveries?.toString() ?? '0', 'Deliveries')),
//       ],
//     );
//   }

//   Widget _buildStatCard(String value, String label) {
//     return Card(
//       elevation: 0,
//       color: Colors.grey[100],
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
//         child: Column(
//           children: [
//             Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 4),
//             Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- ✨ Shimmer Effect Widgets ✨ ---

//   /// Builds the shimmer effect for the entire dashboard screen.
//   Widget _buildShimmerEffect() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: SingleChildScrollView(
//         physics: const NeverScrollableScrollPhysics(),
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Hello, Name placeholder
//             _buildShimmerPlaceholder(height: 30, width: 200),
//             const SizedBox(height: 8),
//             _buildShimmerPlaceholder(height: 18, width: 250),
//             const SizedBox(height: 24),
//             // Online Card placeholder
//             _buildShimmerPlaceholder(height: 70, width: double.infinity),
//             const SizedBox(height: 24),
//             // Today title placeholder
//             _buildShimmerPlaceholder(height: 22, width: 100),
//             const SizedBox(height: 16),
//             // Stats cards placeholder
//             Row(
//               children: [
//                 Expanded(child: _buildShimmerPlaceholder(height: 80)),
//                 const SizedBox(width: 12),
//                 Expanded(child: _buildShimmerPlaceholder(height: 80)),
//                 const SizedBox(width: 12),
//                 Expanded(child: _buildShimmerPlaceholder(height: 80)),
//               ],
//             ),
//             const SizedBox(height: 24),
//             // Currently Delivering title placeholder
//             _buildShimmerPlaceholder(height: 22, width: 220),
//             const SizedBox(height: 16),
//             // Order list placeholder
//             _buildOrderListShimmer(),
//           ],
//         ),
//       ),
//     );
//   }
  
//   /// Builds a shimmer placeholder for the list of order cards.
//   Widget _buildOrderListShimmer() {
//     return Shimmer.fromColors(
//        baseColor: Colors.grey[300]!,
//        highlightColor: Colors.grey[100]!,
//        child: Column(
//         children: List.generate(2, (_) => 
//           Padding(
//             padding: const EdgeInsets.only(bottom: 12.0),
//             child: _buildShimmerPlaceholder(height: 150, width: double.infinity),
//           )
//         ),
//       ),
//     );
//   }

//   /// Helper to create a single shimmering container.
//   Widget _buildShimmerPlaceholder({required double height, double? width}) {
//     return Container(
//       height: height,
//       width: width,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../models/agent_details_model.dart';
import '../models/order_model.dart';
import '../providers/agent_details_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/online_status_toggle_card.dart';
import '../widgets/order_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  
  bool _initialLoad = true;

  @override
  void initState() {
    super.initState();
    // Use Future.microtask to schedule data fetching immediately after initState
    Future.microtask(() {
      // Using context.read is a modern way to get a provider without listening
      final agentProvider = context.read<AgentDetailsProvider>();
      
      agentProvider.fetchAgentDetails().then((_) {
        // After agent details are fetched, get their orders
        if (agentProvider.agentDetails?.employeeId != null) {
          _fetchDeliveringOrders(agentProvider.agentDetails!.employeeId!);
        }
        
        // Update the state to remove the shimmer effect
        if (mounted) {
          setState(() {
            _initialLoad = false;
          });
        }
      });
    });
  }

  void _fetchDeliveringOrders(String employeeId) {
    // Use context.read here as well
    context.read<OrderProvider>().fetchOrders(

          deliveryAgentStatus: "Delivering",
        );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the provider's state using Consumer
    return Consumer<AgentDetailsProvider>(
      builder: (context, agentProvider, child) {
        // Show shimmer effect on initial load
        if (_initialLoad) {
          return _buildShimmerEffect();
        }

        // Show error message if something went wrong
        if (agentProvider.error != null) {
          return Center(child: Text("Error: ${agentProvider.error}"));
        }

        // Show a message if no data is found
        if (agentProvider.agentDetails == null) {
          return const Center(child: Text("No agent data found."));
        }

        // If data is available, build the dashboard UI
        final agent = agentProvider.agentDetails!;
        final firstName = agent.fullName?.split(' ').first ?? 'Agent';

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello, $firstName', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Ready to deliver fashion?', style: TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 24),
                const OnlineStatusToggleCard(),
                const SizedBox(height: 24),
                const Text('Today', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildTodayStats(agent),
                const SizedBox(height: 24),
                const Text('Currently Delivering', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildDeliveringOrdersSection(),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // --- All other helper and shimmer widgets remain the same ---

  Widget _buildDeliveringOrdersSection() {
    return Consumer<OrderProvider>(
      builder: (context, provider, child) {
        final List<OrderModel> orders = provider.deliveringOrders();
        final bool isLoading = provider.isLoading("Delivering");

        if (isLoading && orders.isEmpty) {
          return _buildOrderListShimmer();
        }

        if (orders.isEmpty) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(
                child: Text(
                  "No orders are currently being delivered.",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return OrderCard(order: orders[index]);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 12),
        );
      },
    );
  }

  Widget _buildTodayStats(AgentDetailsModel agent) {
    return Row(
      children: [
        Expanded(child: _buildStatCard('3.2 km', 'Distance')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('0h 0m', 'Active Ti...')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard(agent.deliveries?.toString() ?? '0', 'Deliveries')),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return SafeArea(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShimmerPlaceholder(height: 30, width: 200),
              const SizedBox(height: 8),
              _buildShimmerPlaceholder(height: 18, width: 250),
              const SizedBox(height: 24),
              _buildShimmerPlaceholder(height: 70, width: double.infinity),
              const SizedBox(height: 24),
              _buildShimmerPlaceholder(height: 22, width: 100),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildShimmerPlaceholder(height: 80)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildShimmerPlaceholder(height: 80)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildShimmerPlaceholder(height: 80)),
                ],
              ),
              const SizedBox(height: 24),
              _buildShimmerPlaceholder(height: 22, width: 220),
              const SizedBox(height: 16),
              _buildOrderListShimmer(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildOrderListShimmer() {
    return Column(
      children: List.generate(2, (_) => 
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildShimmerPlaceholder(height: 150, width: double.infinity),
        )
      ),
    );
  }

  Widget _buildShimmerPlaceholder({required double height, double? width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}