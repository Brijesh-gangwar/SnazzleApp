import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import 'order_card.dart';

class DeliveredOrdersScreen extends StatefulWidget {
  const DeliveredOrdersScreen({super.key});

  @override
  State<DeliveredOrdersScreen> createState() => _DeliveredOrdersScreenState();
}

class _DeliveredOrdersScreenState extends State<DeliveredOrdersScreen> {
  final ScrollController _scrollController = ScrollController();
  final String employeeId = "empbrij123";

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<OrderProvider>(context, listen: false);

    // Fetch delivered orders initially if not already loaded
    if (provider.deliveredOrders().isEmpty) {
      provider.fetchOrders(
        // employeeId: employeeId,
        deliveryAgentStatus: "Delivered",
      );
    }

    // Infinite scroll listener
    _scrollController.addListener(() {
      final provider = Provider.of<OrderProvider>(context, listen: false);
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !provider.isLoading("Delivered") &&
          provider.hasMore("Delivered")) {
        provider.fetchOrders(
          // employeeId: employeeId,
          deliveryAgentStatus: "Delivered",
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delivered Orders")),
      body: Consumer<OrderProvider>(
        builder: (context, provider, child) {
          final orders = provider.deliveredOrders();
          final isLoading = provider.isLoading("Delivered");
          final hasMore = provider.hasMore("Delivered");

          if (orders.isEmpty && isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (orders.isEmpty) {
            return const Center(child: Text("No Delivered Orders"));
          }

          return RefreshIndicator(
            onRefresh: () async {
              provider.reset(deliveryAgentStatus: "Delivered");
              await provider.fetchOrders(
                  // employeeId: employeeId,
                   deliveryAgentStatus: "Delivered");
            },
            child: ListView.builder(
              controller: _scrollController,
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
