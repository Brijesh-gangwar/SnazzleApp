// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import '../view_model.dart/order_provider.dart';
// // import '../widgets/order_card.dart';

// // class DeliveredOrdersScreen extends StatefulWidget {
// //   const DeliveredOrdersScreen({super.key});

// //   @override
// //   State<DeliveredOrdersScreen> createState() => _DeliveredOrdersScreenState();
// // }

// // class _DeliveredOrdersScreenState extends State<DeliveredOrdersScreen> {
// //   final ScrollController _scrollController = ScrollController();
// //   final String employeeId = "empbrij123";

// //   @override
// //   void initState() {
// //     super.initState();
// //     final provider = Provider.of<OrderProvider>(context, listen: false);

// //     // Fetch delivered orders initially if not already loaded
// //     if (provider.deliveredOrders().isEmpty) {
// //       provider.fetchOrders(
// //         // employeeId: employeeId,
// //         deliveryAgentStatus: "Delivered",
// //       );
// //     }

// //     // Infinite scroll listener
// //     _scrollController.addListener(() {
// //       final provider = Provider.of<OrderProvider>(context, listen: false);
// //       if (_scrollController.position.pixels >=
// //               _scrollController.position.maxScrollExtent - 200 &&
// //           !provider.isLoading("Delivered") &&
// //           provider.hasMore("Delivered")) {
// //         provider.fetchOrders(
// //           // employeeId: employeeId,
// //           deliveryAgentStatus: "Delivered",
// //         );
// //       }
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _scrollController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Delivered Orders")),
// //       body: Consumer<OrderProvider>(
// //         builder: (context, provider, child) {
// //           final orders = provider.deliveredOrders();
// //           final isLoading = provider.isLoading("Delivered");
// //           final hasMore = provider.hasMore("Delivered");

// //           if (orders.isEmpty && isLoading) {
// //             return const Center(child: CircularProgressIndicator());
// //           }

// //           if (orders.isEmpty) {
// //             return const Center(child: Text("No Delivered Orders"));
// //           }

// //           return RefreshIndicator(
// //             onRefresh: () async {
// //               provider.reset(deliveryAgentStatus: "Delivered");
// //               await provider.fetchOrders(
// //                   // employeeId: employeeId,
// //                    deliveryAgentStatus: "Delivered");
// //             },
// //             child: ListView.builder(
// //               controller: _scrollController,
// //               itemCount: orders.length + (hasMore ? 1 : 0),
// //               itemBuilder: (context, index) {
// //                 if (index == orders.length) {
// //                   return const Padding(
// //                     padding: EdgeInsets.all(16.0),
// //                     child: Center(child: CircularProgressIndicator()),
// //                   );
// //                 }
// //                 final order = orders[index];
// //                 return OrderCard(order: order);
// //               },
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../view_model.dart/order_provider.dart';
// import '../widgets/order_card.dart';

// class DeliveredOrdersScreen extends StatefulWidget {
//   const DeliveredOrdersScreen({super.key});

//   @override
//   State<DeliveredOrdersScreen> createState() => _DeliveredOrdersScreenState();
// }

// class _DeliveredOrdersScreenState extends State<DeliveredOrdersScreen> {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     // Use Future.microtask to safely access context after the first frame
//     Future.microtask(() {
//       final provider = context.read<OrderProvider>();

//       if (provider.deliveredOrders().isEmpty) {
//         provider.fetchOrders(deliveryAgentStatus: "Delivered");
//       }
//     });

//     _scrollController.addListener(_handleScroll);
//   }

//   void _handleScroll() {
//     final provider = context.read<OrderProvider>();
//     // Check scroll position and provider state to fetch more data
//     if (_scrollController.position.pixels >=
//             _scrollController.position.maxScrollExtent - 200 &&
//         !provider.isLoading("Delivered") &&
//         provider.hasMore("Delivered")) {
//       provider.fetchOrders(deliveryAgentStatus: "Delivered");
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_handleScroll);
//     _scrollController.dispose();
//     super.dispose();
//   }

//   // Handles the pull-to-refresh action
//   Future<void> _onRefresh() async {
//     final provider = context.read<OrderProvider>();
//     provider.reset(deliveryAgentStatus: "Delivered");
//     await provider.fetchOrders(deliveryAgentStatus: "Delivered");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Delivered Orders")),
//       body: Consumer<OrderProvider>(
//         builder: (context, provider, child) {
//           final orders = provider.deliveredOrders();
//           final isLoading = provider.isLoading("Delivered");
//           final hasMore = provider.hasMore("Delivered");

//           // Show a loading indicator on initial fetch
//           if (orders.isEmpty && isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           // Show a message if no orders are found after fetching
//           if (orders.isEmpty) {
//             return const Center(child: Text("No Delivered Orders Found"));
//           }

//           return RefreshIndicator(
//             onRefresh: _onRefresh,
//             child: ListView.builder(
//               controller: _scrollController,
//               itemCount: orders.length + (hasMore ? 1 : 0),
//               itemBuilder: (context, index) {
//                 // If we've reached the end of the list and there's more data, show a loader
//                 if (index == orders.length) {
//                   return const Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Center(child: CircularProgressIndicator()),
//                   );
//                 }
//                 // Otherwise, display the order card
//                 final order = orders[index];
//                 return OrderCard(order: order);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model.dart/order_provider.dart';
import '../widgets/order_card.dart';

class DeliveredOrdersScreen extends StatefulWidget {
  const DeliveredOrdersScreen({super.key});

  @override
  State<DeliveredOrdersScreen> createState() => _DeliveredOrdersScreenState();
}

class _DeliveredOrdersScreenState extends State<DeliveredOrdersScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<OrderProvider>();
      if (provider.deliveredOrders().isEmpty) {
        provider.fetchOrders(deliveryAgentStatus: "Delivered");
      }
    });
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final provider = context.read<OrderProvider>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !provider.isLoading("Delivered") &&
        provider.hasMore("Delivered")) {
      provider.fetchOrders(deliveryAgentStatus: "Delivered");
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    final provider = context.read<OrderProvider>();
    provider.reset(deliveryAgentStatus: "Delivered");
    await provider.fetchOrders(deliveryAgentStatus: "Delivered");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Delivered Orders", maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: Consumer<OrderProvider>(
        builder: (context, provider, child) {
          final orders = provider.deliveredOrders();
          final isLoading = provider.isLoading("Delivered");
          final hasMore = provider.hasMore("Delivered");

          if (orders.isEmpty && isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (orders.isEmpty) {
            return const Center(child: Text("No Delivered Orders Found"));
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.zero,
              itemCount: orders.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == orders.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final order = orders[index];
                return OrderCard(order: order);
              },
            ),
          );
        },
      ),
    );
  }
}