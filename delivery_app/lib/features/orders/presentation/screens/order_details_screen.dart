
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../data/models/order_model.dart';
// import '../view_model.dart/order_provider.dart';
// import '../widgets/location_screen.dart';

// class OrderDetailsScreen extends StatefulWidget {
//   final OrderModel order;

//   const OrderDetailsScreen({super.key, required this.order});

//   @override
//   State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
// }

// class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
//   bool _isDeliveryLoading = false;
//   bool _isPaymentLoading = false;

//   // Determines the next delivery action based on the current status.
//   Map<String, String>? _getDeliveryAction() {
//     switch (widget.order.deliveryAgentStatus) {
//       case "Assigned":
//         return {"nextStatus": "Delivering", "buttonText": "Start Delivery"};
//       case "Delivering":
//         return {"nextStatus": "Delivered", "buttonText": "Mark as Delivered"};
//       default:
//         return null;
//     }
//   }

//   // Handles updating the delivery agent status and the main order status.
//   Future<void> _handleUpdateDeliveryStatus() async {
//     final action = _getDeliveryAction();
//     if (action == null) return;

//     setState(() => _isDeliveryLoading = true);

//     final orderId = widget.order.sId;
//     final currentStatus = widget.order.deliveryAgentStatus;
//     final newStatus = action["nextStatus"]!;

//     if (orderId == null || currentStatus == null) {
//       _showSnackBar("Error: Missing order information.", isError: true);
//       setState(() => _isDeliveryLoading = false);
//       return;
//     }

//     final success =
//         await context.read<OrderProvider>().updateDeliveryAgentStatus(
//               orderId: orderId,
//               currentStatus: currentStatus,
//               newStatus: newStatus,
//             );

//     if (success && newStatus == "Delivered") {
//       context.read<OrderProvider>().updateMainOrderStatus(
//             orderId: orderId,
//             newOrderStatus: "Delivered",
//           );
//     }

//     _showSnackBar(
//       success
//           ? "Delivery status updated successfully!"
//           : "Failed to update delivery status.",
//       isError: !success,
//     );

//     if (success && mounted) {
//       Navigator.pop(context);
//     } else {
//       setState(() => _isDeliveryLoading = false);
//     }
//   }

//   // Shows a dialog for the agent to select a new payment status.
//   Future<void> _showPaymentStatusDialog() async {
//     final List<String> options = ["Paid", "Failed"];

//     final String? selectedStatus = await showDialog<String>(
//       context: context,
//       builder: (BuildContext context) {
//         return SimpleDialog(
//           title: const Text('Update Payment Status'),
//           children: options.map((status) {
//             return SimpleDialogOption(
//               onPressed: () {
//                 Navigator.pop(context, status); // Return the selected status
//               },
//               child: Text(status),
//             );
//           }).toList(),
//         );
//       },
//     );

//     if (selectedStatus != null) {
//       await _handleUpdatePaymentStatus(selectedStatus);
//     }
//   }

//   // Handles updating the payment status for COD orders.
//   Future<void> _handleUpdatePaymentStatus(String newPaymentStatus) async {
//     final orderId = widget.order.sId;
//     if (orderId == null) {
//       _showSnackBar("Error: Missing order information.", isError: true);
//       return;
//     }

//     setState(() => _isPaymentLoading = true);

//     final success = await context.read<OrderProvider>().updatePaymentStatus(
//         orderId: orderId, newPaymentStatus: newPaymentStatus);

//     _showSnackBar(
//       success
//           ? "Payment status updated to $newPaymentStatus!"
//           : "Failed to update payment status.",
//       isError: !success,
//     );

//     setState(() => _isPaymentLoading = false);
//   }

//   void _showSnackBar(String message, {bool isError = false}) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: isError ? Colors.red : Colors.green,
//         ),
//       );
//     }
//   }
  
//   // ✅ NEW HELPER: Finds the most up-to-date version of the order from the provider.
//   OrderModel _findLatestOrder(BuildContext context) {
//     final provider = context.watch<OrderProvider>();
//     // Combine all order lists to search through them.
//     final allOrders = [...provider.assignedOrders(), ...provider.deliveringOrders()];
    
//     // Find the order with the matching ID.
//     final index = allOrders.indexWhere((o) => o.sId == widget.order.sId);

//     // If found, return the reactive order from the provider.
//     // Otherwise, fall back to the initial order passed to the widget.
//     return index != -1 ? allOrders[index] : widget.order;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Order Details"),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildOrderInfoSection(),
//             const Divider(height: 32, thickness: 1),
//             _buildPaymentSection(),
//             const Divider(height: 32, thickness: 1),
//             _buildAddressSection(),
//             const Divider(height: 32, thickness: 1),
//             _buildItemsSection(),
//             const SizedBox(height: 24),
//             widget.order.deliveryAgentStatus == "Delivering" &&
//                     widget.order.paymentMethod == "Cash on Delivery" &&
//                     widget.order.paymentStatus != "Paid"
//                 ? const SizedBox.shrink()
//                 : _buildActionButtons(),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- UI Helper Widgets ---

//   Widget _buildOrderInfoSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Order ID: ${widget.order.orderId ?? 'N/A'}",
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         Text("Agent Status: ${widget.order.deliveryAgentStatus ?? 'N/A'}"),
//         Text("Order Status: ${widget.order.orderStatus ?? 'N/A'}"),
//         Text("Delivery Mode: ${widget.order.deliveryMode ?? 'N/A'}"),
//         Text("Estimated Time: ${widget.order.estimatedTime ?? 'N/A'}"),
//       ],
//     );
//   }
  
//   // ✅ UPDATED: This section is now fully reactive for all order types.
//   Widget _buildPaymentSection() {
//     // Use the helper to get the latest, reactive order data.
//     final order = _findLatestOrder(context);
    
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Payment Details",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         Text("Payment Method: ${order.paymentMethod ?? 'N/A'}"),
//         Text("Payment Status: ${order.paymentStatus ?? 'N/A'}"),
//         Text("Total Amount: ₹${order.total ?? 0}"),
        
//         // This condition now works correctly for any order (Assigned, Delivering, etc.)
//         if (order.deliveryAgentStatus == "Delivering" &&
//           order.paymentMethod == "Cash on Delivery" &&
//             order.paymentStatus != "Paid") ...[
//           const SizedBox(height: 16),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: _isPaymentLoading ? null : _showPaymentStatusDialog,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//               ),
//               child: _isPaymentLoading
//                   ? const SizedBox(
//                       height: 20,
//                       width: 20,
//                       child: CircularProgressIndicator(
//                           strokeWidth: 2, color: Colors.white))
//                   : const Text("Update Payment Status"),
//             ),
//           )
//         ],
//       ],
//     );
//   }

//   Widget _buildAddressSection() {
//     final address = widget.order.address;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Delivery Address",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         if (address != null) ...[
//           Text("Street: ${address.street ?? 'N/A'}"),
//           Text("City: ${address.city ?? 'N/A'}"),
//           Text("State: ${address.state ?? 'N/A'}"),
//           Text("ZIP: ${address.zip ?? 'N/A'}"),
//           const SizedBox(height: 8),
//           LocationButton(address: address)
//         ],
//       ],
//     );
//   }

//   Widget _buildItemsSection() {
//     final items = widget.order.items ?? [];
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Items",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         ...items.map((item) => Card(
//               margin: const EdgeInsets.symmetric(vertical: 6),
//               child: ListTile(
//                 leading: item.image != null
//                     ? Image.network(item.image!,
//                         width: 50, height: 50, fit: BoxFit.cover)
//                     : const Icon(Icons.image),
//                 title: Text(item.name ?? 'Item'),
//                 subtitle: Text("Quantity: ${item.quantity ?? 0}"),
//                 trailing: Text("₹${item.price ?? 0}"),
//               ),
//             )),
//       ],
//     );
//   }

//   Widget _buildActionButtons() {
//     final deliveryAction = _getDeliveryAction();
//     if (deliveryAction == null) return const SizedBox.shrink();

//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: _isDeliveryLoading ? null : _handleUpdateDeliveryStatus,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.black,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         child: _isDeliveryLoading
//             ? const SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: CircularProgressIndicator(
//                     strokeWidth: 2, color: Colors.white))
//             : Text(deliveryAction["buttonText"]!,
//                 style: const TextStyle(fontSize: 16)),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../profile/presentation/view_model/agent_details_provider.dart';
import '../../data/models/order_model.dart';
import '../view_model.dart/order_provider.dart';
import '../widgets/location_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _isDeliveryLoading = false;
  bool _isPaymentLoading = false;

  // Determines the next delivery action based on the current status.
  Map<String, String>? _getDeliveryAction() {
    switch (widget.order.deliveryAgentStatus) {
      case "Assigned":
        return {"nextStatus": "Delivering", "buttonText": "Start Delivery"};
      case "Delivering":
        return {"nextStatus": "Delivered", "buttonText": "Mark as Delivered"};
      default:
        return null;
    }
  }

  // Handles updating the delivery agent status and the main order status.
  Future<void> _handleUpdateDeliveryStatus() async {
    final action = _getDeliveryAction();
    if (action == null) return;

    setState(() => _isDeliveryLoading = true);

    final orderId = widget.order.sId;
    final currentStatus = widget.order.deliveryAgentStatus;
    final newStatus = action["nextStatus"]!;

    if (orderId == null || currentStatus == null) {
      _showSnackBar("Error: Missing order information.", isError: true);
      setState(() => _isDeliveryLoading = false);
      return;
    }

    final success =
        await context.read<OrderProvider>().updateDeliveryAgentStatus(
              orderId: orderId,
              currentStatus: currentStatus,
              newStatus: newStatus,
            );

    if (success && newStatus == "Delivered") {
      // Also update the main order status in the backend
      context.read<OrderProvider>().updateMainOrderStatus(
            orderId: orderId,
            newOrderStatus: "Delivered",
          );
      
      // ✅ ADDED: Increment the delivery count in the UI
      context.read<AgentDetailsProvider>().incrementDeliveries();
    }

    _showSnackBar(
      success
          ? "Delivery status updated successfully!"
          : "Failed to update delivery status.",
      isError: !success,
    );

    if (success && mounted) {
      Navigator.pop(context);
    } else {
      setState(() => _isDeliveryLoading = false);
    }
  }

  // Shows a dialog for the agent to select a new payment status.
  Future<void> _showPaymentStatusDialog() async {
    // ✅ UPDATED: Options are now "Paid" and "Failed"
    final List<String> options = ["Paid", "Failed"];

    final String? selectedStatus = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Update Payment Status'),
          children: options.map((status) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, status);
              },
              child: Text(status),
            );
          }).toList(),
        );
      },
    );

    if (selectedStatus != null) {
      await _handleUpdatePaymentStatus(selectedStatus);
    }
  }

  // Handles updating the payment status for COD orders.
  Future<void> _handleUpdatePaymentStatus(String newPaymentStatus) async {
    final orderId = widget.order.sId;
    if (orderId == null) {
      _showSnackBar("Error: Missing order information.", isError: true);
      return;
    }

    setState(() => _isPaymentLoading = true);

    final success = await context.read<OrderProvider>().updatePaymentStatus(
        orderId: orderId, newPaymentStatus: newPaymentStatus);

    _showSnackBar(
      success
          ? "Payment status updated to $newPaymentStatus!"
          : "Failed to update payment status.",
      isError: !success,
    );

    setState(() => _isPaymentLoading = false);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
    }
  }
  
  // Helper to find the most up-to-date version of the order from the provider.
  OrderModel _findLatestOrder(BuildContext context) {
    final provider = context.watch<OrderProvider>();
    final allOrders = [...provider.assignedOrders(), ...provider.deliveringOrders()];
    
    final index = allOrders.indexWhere((o) => o.sId == widget.order.sId);

    return index != -1 ? allOrders[index] : widget.order;
  }

  @override
  Widget build(BuildContext context) {
    // Get the latest reactive version of the order
    final order = _findLatestOrder(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderInfoSection(order),
            const Divider(height: 32, thickness: 1),
            _buildPaymentSection(order),
            const Divider(height: 32, thickness: 1),
            _buildAddressSection(order),
            const Divider(height: 32, thickness: 1),
            _buildItemsSection(order),
            const SizedBox(height: 24),

            // ✅ NEW LOGIC: Conditionally show the delivery action button.
            // It will be hidden for pending COD orders that are being delivered.
            if (order.deliveryAgentStatus == "Delivering" &&
                order.paymentMethod == "Cash on Delivery" &&
                order.paymentStatus != "Paid")
              const SizedBox.shrink() // Hide the button
            else
              _buildActionButtons(), // Show the button
          ],
        ),
      ),
    );
  }

  // --- UI Helper Widgets ---

  Widget _buildOrderInfoSection(OrderModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Order ID: ${order.orderId ?? 'N/A'}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text("Agent Status: ${order.deliveryAgentStatus ?? 'N/A'}"),
        Text("Order Status: ${order.orderStatus ?? 'N/A'}"),
        Text("Delivery Mode: ${order.deliveryMode ?? 'N/A'}"),
        Text("Estimated Time: ${order.estimatedTime ?? 'N/A'}"),
      ],
    );
  }
  
  Widget _buildPaymentSection(OrderModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Payment Details",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text("Payment Method: ${order.paymentMethod ?? 'N/A'}"),
        Text("Payment Status: ${order.paymentStatus ?? 'N/A'}"),
        Text("Total Amount: ₹${order.total ?? 0}"),
        
        // ✅ UPDATED: Condition is more specific to "Pending"
        if (order.paymentMethod == "Cash on Delivery" &&
            order.paymentStatus == "Pending") ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isPaymentLoading ? null : _showPaymentStatusDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: _isPaymentLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text("Update Payment Status"),
            ),
          )
        ],
      ],
    );
  }

  Widget _buildAddressSection(OrderModel order) {
    final address = order.address;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Delivery Address",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (address != null) ...[
          Text("Street: ${address.street ?? 'N/A'}"),
          Text("City: ${address.city ?? 'N/A'}"),
          Text("State: ${address.state ?? 'N/A'}"),
          Text("ZIP: ${address.zip ?? 'N/A'}"),
          const SizedBox(height: 8),
          LocationButton(address: address)
        ],
      ],
    );
  }

  Widget _buildItemsSection(OrderModel order) {
    final items = order.items ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Items",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: item.image != null
                    ? Image.network(item.image!,
                        width: 50, height: 50, fit: BoxFit.cover)
                    : const Icon(Icons.image),
                title: Text(item.name ?? 'Item'),
                subtitle: Text("Quantity: ${item.quantity ?? 0}"),
                trailing: Text("₹${item.price ?? 0}"),
              ),
            )),
      ],
    );
  }

  Widget _buildActionButtons() {
    final deliveryAction = _getDeliveryAction();
    if (deliveryAction == null) return const SizedBox.shrink();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isDeliveryLoading ? null : _handleUpdateDeliveryStatus,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _isDeliveryLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
            : Text(deliveryAction["buttonText"]!,
                style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}