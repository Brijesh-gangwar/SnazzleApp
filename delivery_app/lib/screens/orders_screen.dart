
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/order_model.dart';
// import '../providers/agent_details_provider.dart';
// import '../providers/order_provider.dart';
// import '../widgets/delivered_order_screen.dart';
// import '../widgets/order_card.dart';

// class OrderScreen extends StatefulWidget {
//   const OrderScreen({super.key});

//   @override
//   State<OrderScreen> createState() => _OrderScreenState();
// }

// class _OrderScreenState extends State<OrderScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String? _employeeId;
//   bool _ordersFetched = false; 

//   final List<String> statuses = ["Assigned", "Delivering"];
//   final Map<String, ScrollController> _scrollControllers = {};

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: statuses.length, vsync: this);

//     for (var status in statuses) {
//       _scrollControllers[status] = ScrollController();
//       _scrollControllers[status]!.addListener(() => _handleScroll(status));
//     }
//   }
  
//   // This function is now called reactively from the build method
//   void _fetchInitialOrders() {
//     if (_employeeId != null && !_ordersFetched) {
//       for (var status in statuses) {
//         _fetchOrdersForStatus(status);
//       }
//       // Mark as fetched to prevent this from running again unnecessarily
//       setState(() {
//         _ordersFetched = true;
//       });
//     }
//   }

//   void _fetchOrdersForStatus(String status) {
//     if (_employeeId == null) return;

//     final provider = context.read<OrderProvider>();
//     List<OrderModel> currentOrders;

//     switch (status) {
//       case "Assigned":
//         currentOrders = provider.assignedOrders();
//         break;
//       case "Delivering":
//         currentOrders = provider.deliveringOrders();
//         break;
//       default:
//         return;
//     }

//     // Only fetch if the list for this status is empty
//     if (currentOrders.isEmpty) {
//       provider.fetchOrders(
//         // employeeId: _employeeId!,
//         deliveryAgentStatus: status,
//       );
//     }
//   }

//   void _handleScroll(String status) {
//     if (_employeeId == null) return;

//     final provider = context.read<OrderProvider>();
//     final controller = _scrollControllers[status];

//     if (controller != null &&
//         controller.position.pixels >=
//             controller.position.maxScrollExtent - 200 &&
//         !provider.isLoading(status) &&
//         provider.hasMore(status)) {
//       provider.fetchOrders(
//          deliveryAgentStatus: status);
//     }
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _scrollControllers.forEach((_, controller) => controller.dispose());
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This Consumer makes the widget tree reactive to changes in agent details.
//     return Consumer<AgentDetailsProvider>(
//       builder: (context, agentProvider, child) {
//         // If agent details are available and we haven't fetched orders yet...
//         if (agentProvider.agentDetails != null && !_ordersFetched) {
//           // ...get the ID and trigger the initial fetch.
//           _employeeId = agentProvider.agentDetails!.employeeId;
//           // Use a microtask to avoid calling setState during a build
//           Future.microtask(() => _fetchInitialOrders());
//         }

//         return Scaffold(
//           appBar: AppBar(
//             title: const Text("Orders"),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.history),
//                 tooltip: "Delivered Orders",
//                 onPressed: _showDeliveredOrders,
//               ),
//             ],
//             bottom: TabBar(
//               controller: _tabController,
//               tabs: statuses.map((s) => Tab(text: s)).toList(),
//             ),
//           ),
//           // Show a loading indicator until the employeeId is available.
//           body: _employeeId == null
//               ? const Center(child: CircularProgressIndicator())
//               : TabBarView(
//                   controller: _tabController,
//                   children: statuses.map((status) => _buildTab(status)).toList(),
//                 ),
//         );
//       },
//     );
//   }

//   Widget _buildTab(String status) {
//     return Consumer<OrderProvider>(
//       builder: (context, provider, child) {
//         List<OrderModel> orders;

//         switch (status) {
//           case "Assigned":
//             orders = provider.assignedOrders();
//             break;
//           case "Delivering":
//             orders = provider.deliveringOrders();
//             break;
//           default:
//             orders = [];
//         }

//         if (orders.isEmpty && provider.isLoading(status)) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (orders.isEmpty) {
//           return const Center(child: Text("No Orders Found"));
//         }

//         return RefreshIndicator(
//           onRefresh: () async {
//             provider.reset(deliveryAgentStatus: status);
//             await provider.fetchOrders(
//               // employeeId: _employeeId!,
//               deliveryAgentStatus: status,
//             );
//           },
//           child: ListView.builder(
//             controller: _scrollControllers[status],
//             itemCount: orders.length + (provider.hasMore(status) ? 1 : 0),
//             itemBuilder: (context, index) {
//               if (index == orders.length) {
//                 return const Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Center(child: CircularProgressIndicator()),
//                 );
//               }
//               return OrderCard(order: orders[index]);
//             },
//           ),
//         );
//       },
//     );
//   }

//   void _showDeliveredOrders() {
//     if (_employeeId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Cannot show history. Please wait for user details to load.")),
//       );
//       return;
//     }

//     final provider = context.read<OrderProvider>();
//     if (provider.deliveredOrders().isEmpty) {
//       provider.fetchOrders(
//         // employeeId: _employeeId!,
//         deliveryAgentStatus: "Delivered",
//       );
//     }

//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const DeliveredOrdersScreen()),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order_model.dart';
import '../providers/agent_details_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/delivered_order_screen.dart';
import '../widgets/order_card.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _employeeId;
  bool _ordersFetched = false;

  final List<String> statuses = ["Assigned", "Delivering"];
  final Map<String, ScrollController> _scrollControllers = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: statuses.length, vsync: this);

    for (var status in statuses) {
      _scrollControllers[status] = ScrollController();
      _scrollControllers[status]!.addListener(() => _handleScroll(status));
    }
  }

  void _fetchInitialOrders() {
    if (_employeeId != null && !_ordersFetched) {
      for (var status in statuses) {
        _fetchOrdersForStatus(status);
      }
      setState(() {
        _ordersFetched = true;
      });
    }
  }

  void _fetchOrdersForStatus(String status) {
    if (_employeeId == null) return;
    final provider = context.read<OrderProvider>();
    List<OrderModel> currentOrders;
    switch (status) {
      case "Assigned":
        currentOrders = provider.assignedOrders();
        break;
      case "Delivering":
        currentOrders = provider.deliveringOrders();
        break;
      default:
        return;
    }
    if (currentOrders.isEmpty) {
      provider.fetchOrders(deliveryAgentStatus: status);
    }
  }

  void _handleScroll(String status) {
    if (_employeeId == null) return;
    final provider = context.read<OrderProvider>();
    final controller = _scrollControllers[status];
    if (controller != null &&
        controller.position.pixels >=
            controller.position.maxScrollExtent - 200 &&
        !provider.isLoading(status) &&
        provider.hasMore(status)) {
      provider.fetchOrders(deliveryAgentStatus: status);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AgentDetailsProvider>(
      builder: (context, agentProvider, child) {
        if (agentProvider.agentDetails != null && !_ordersFetched) {
          _employeeId = agentProvider.agentDetails!.employeeId;
          Future.microtask(() => _fetchInitialOrders());
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("Orders"),
            actions: [
              IconButton(
                icon: const Icon(Icons.history),
                tooltip: "Delivered Orders",
                onPressed: _showDeliveredOrders,
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: statuses.map((s) => Tab(text: s)).toList(),
            ),
          ),
          body: _employeeId == null
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: statuses.map((status) => _buildTab(status)).toList(),
                ),
        );
      },
    );
  }

  Widget _buildTab(String status) {
    return Consumer<OrderProvider>(
      builder: (context, provider, child) {
        List<OrderModel> orders;
        // ✅ CLEANED UP: The unused "Collected" case is removed.
        switch (status) {
          case "Assigned":
            orders = provider.assignedOrders();
            break;
          case "Delivering":
            orders = provider.deliveringOrders();
            break;
          default:
            orders = [];
        }

        if (orders.isEmpty && provider.isLoading(status)) {
          return const Center(child: CircularProgressIndicator());
        }
        if (orders.isEmpty) {
          return const Center(child: Text("No Orders Found"));
        }

        return RefreshIndicator(
          onRefresh: () async {
            provider.reset(deliveryAgentStatus: status);
            await provider.fetchOrders(deliveryAgentStatus: status);
          },
          child: ListView.builder(
            controller: _scrollControllers[status],
            itemCount: orders.length + (provider.hasMore(status) ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == orders.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return OrderCard(order: orders[index]);
            },
          ),
        );
      },
    );
  }

  void _showDeliveredOrders() {
    if (_employeeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Cannot show history. Please wait for user details to load.")),
      );
      return;
    }
    final provider = context.read<OrderProvider>();
    if (provider.deliveredOrders().isEmpty) {
      provider.fetchOrders(deliveryAgentStatus: "Delivered");
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DeliveredOrdersScreen()),
    );
  }
}