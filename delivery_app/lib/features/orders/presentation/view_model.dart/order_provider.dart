

// // import 'package:flutter/foundation.dart';
// // import '../../data/models/order_model.dart';
// // import '../../data/services/order_service.dart';

// // class OrderProvider with ChangeNotifier {
// //   final OrderService _orderService = OrderService();

// //   // State maps
// //   final Map<String, List<OrderModel>> _ordersByStatus = {
// //     "Assigned": [], "Delivering": [], "Delivered": [],
// //   };
// //   final Map<String, String?> _cursorByStatus = {
// //     "Assigned": null, "Delivering": null, "Delivered": null,
// //   };
// //   final Map<String, bool> _hasMoreByStatus = {
// //     "Assigned": true, "Delivering": true, "Delivered": true,
// //   };
// //   final Map<String, bool> _isLoadingByStatus = {
// //     "Assigned": false, "Delivering": false, "Delivered": false,
// //   };

// //   // Public getters
// //   List<OrderModel> assignedOrders() => _ordersByStatus["Assigned"]!;
// //   List<OrderModel> deliveringOrders() => _ordersByStatus["Delivering"]!;
// //   List<OrderModel> deliveredOrders() => _ordersByStatus["Delivered"]!;
// //   bool isLoading(String status) => _isLoadingByStatus[status] ?? false;
// //   bool hasMore(String status) => _hasMoreByStatus[status] ?? true;

// //   // DATA FETCHING
// //   // ✅ FIXED: Re-added the required employeeId parameter.
// //   Future<void> fetchOrders({

// //     required String deliveryAgentStatus,
// //     int limit = 10,
// //   }) async {
// //     if (!_isLoadingByStatus.containsKey(deliveryAgentStatus) || isLoading(deliveryAgentStatus) || !hasMore(deliveryAgentStatus)) return;

// //     _isLoadingByStatus[deliveryAgentStatus] = true;
// //     notifyListeners();

// //     try {
// //       final data = await _orderService.fetchOrders(
// //         deliveryAgentStatus: deliveryAgentStatus,
// //         cursor: _cursorByStatus[deliveryAgentStatus],
// //         limit: limit,
// //       );

// //       final List<OrderModel> newOrders = data["orders"];
// //       final String? nextCursor = data["nextCursor"];

// //       _cursorByStatus[deliveryAgentStatus] = nextCursor;
// //       _ordersByStatus[deliveryAgentStatus]!.addAll(newOrders);

// //       if (nextCursor == null) {
// //         _hasMoreByStatus[deliveryAgentStatus] = false;
// //       }
// //     } catch (e) {
// //       debugPrint("Error fetching orders for $deliveryAgentStatus: $e");
// //     } finally {
// //       _isLoadingByStatus[deliveryAgentStatus] = false;
// //       notifyListeners();
// //     }
// //   }

// //   // DATA MANIPULATION
// //   Future<bool> updateDeliveryAgentStatus({
// //     required String orderId,
// //     required String currentStatus,
// //     required String newStatus,
// //   }) async {
// //     final bool success = await _orderService.updateAgentOrderStatus(
// //       orderId: orderId,
// //       newStatus: newStatus,
// //     );

// //     if (success) {
// //       final orderIndex = _ordersByStatus[currentStatus]?.indexWhere((order) => order.sId == orderId);
// //       if (orderIndex != null && orderIndex != -1) {
// //         final orderToMove = _ordersByStatus[currentStatus]!.removeAt(orderIndex);
// //         orderToMove.deliveryAgentStatus = newStatus;

// //         if (_ordersByStatus.containsKey(newStatus)) {
// //           _ordersByStatus[newStatus]!.insert(0, orderToMove);
// //         }
// //         notifyListeners();
// //       }
// //     }
// //     return success;
// //   }

// //   Future<bool> updatePaymentStatus({
// //     required String orderId,
// //     required String newPaymentStatus,
// //   }) async {
// //     final bool success = await _orderService.updatePaymentStatus(
// //       orderId: orderId,
// //       paymentStatus: newPaymentStatus,
// //     );

// //     if (success) {
// //       _updateLocalOrder(orderId, (order) {
// //         order.paymentStatus = newPaymentStatus;
// //       });
// //       notifyListeners();
// //     }
// //     return success;
// //   }

// //   Future<bool> updateMainOrderStatus({
// //     required String orderId,
// //     required String newOrderStatus,
// //   }) async {
// //     final bool success = await _orderService.updateOrderStatus(
// //       orderId: orderId,
// //       newOrderStatus: newOrderStatus,
// //     );

// //     if (success) {
// //       _updateLocalOrder(orderId, (order) {
// //         order.orderStatus = newOrderStatus;
// //       });
// //       notifyListeners();
// //     }
// //     return success;
// //   }

// //   void _updateLocalOrder(String orderId, void Function(OrderModel order) updateAction) {
// //     for (var orderList in _ordersByStatus.values) {
// //       final index = orderList.indexWhere((o) => o.sId == orderId);
// //       if (index != -1) {
// //         updateAction(orderList[index]);
// //         return;
// //       }
// //     }
// //   }

// //   void reset({String? deliveryAgentStatus}) {
// //     if (deliveryAgentStatus != null && _ordersByStatus.containsKey(deliveryAgentStatus)) {
// //       _ordersByStatus[deliveryAgentStatus]?.clear();
// //       _cursorByStatus[deliveryAgentStatus] = null;
// //       _hasMoreByStatus[deliveryAgentStatus] = true;
// //       _isLoadingByStatus[deliveryAgentStatus] = false;
// //     } else {
// //       _ordersByStatus.forEach((key, value) => value.clear());
// //       _cursorByStatus.updateAll((key, value) => null);
// //       _hasMoreByStatus.updateAll((key, value) => true);
// //       _isLoadingByStatus.updateAll((key, value) => false);
// //     }
// //     notifyListeners();
// //   }
// // }


// import 'package:flutter/foundation.dart';
// import '../../data/models/order_model.dart';
// import '../../data/services/order_service.dart';

// class OrderProvider with ChangeNotifier {
//   final OrderService _orderService = OrderService();

//   // State maps
//   final Map<String, List<OrderModel>> _ordersByStatus = {
//     "Assigned": [], "Delivering": [], "Delivered": [],
//   };
//   final Map<String, String?> _cursorByStatus = {
//     "Assigned": null, "Delivering": null, "Delivered": null,
//   };
//   final Map<String, bool> _hasMoreByStatus = {
//     "Assigned": true, "Delivering": true, "Delivered": true,
//   };
//   final Map<String, bool> _isLoadingByStatus = {
//     "Assigned": false, "Delivering": false, "Delivered": false,
//   };

//   // Public getters
//   List<OrderModel> assignedOrders() => _ordersByStatus["Assigned"]!;
//   List<OrderModel> deliveringOrders() => _ordersByStatus["Delivering"]!;
//   List<OrderModel> deliveredOrders() => _ordersByStatus["Delivered"]!;
//   bool isLoading(String status) => _isLoadingByStatus[status] ?? false;
//   bool hasMore(String status) => _hasMoreByStatus[status] ?? true;

//   // DATA FETCHING
//   Future<void> fetchOrders({
//     required String deliveryAgentStatus,
//     int limit = 10,
//   }) async {
//     if (!_isLoadingByStatus.containsKey(deliveryAgentStatus) || isLoading(deliveryAgentStatus) || !hasMore(deliveryAgentStatus)) return;

//     _isLoadingByStatus[deliveryAgentStatus] = true;
//     notifyListeners();

//     try {
//       final data = await _orderService.fetchOrders(
//         deliveryAgentStatus: deliveryAgentStatus,
//         cursor: _cursorByStatus[deliveryAgentStatus],
//         limit: limit,
//       );

//       final List<OrderModel> newOrders = data["orders"];
//       final String? nextCursor = data["nextCursor"];

//       _cursorByStatus[deliveryAgentStatus] = nextCursor;
//       _ordersByStatus[deliveryAgentStatus]!.addAll(newOrders);

//       // ✅ **THE FIX**: Corrected a typo here.
//       // If the server returns no next cursor, it means we have reached the end.
//       if (nextCursor == null) {
//         _hasMoreByStatus[deliveryAgentStatus] = false;
//       }
//     } catch (e) {
//       debugPrint("Error fetching orders for $deliveryAgentStatus: $e");
//     } finally {
//       _isLoadingByStatus[deliveryAgentStatus] = false;
//       notifyListeners();
//     }
//   }

//   // DATA MANIPULATION
//   Future<bool> updateDeliveryAgentStatus({
//     required String orderId,
//     required String currentStatus,
//     required String newStatus,
//   }) async {
//     final bool success = await _orderService.updateAgentOrderStatus(
//       orderId: orderId,
//       newStatus: newStatus,
//     );

//     if (success) {
//       final orderIndex = _ordersByStatus[currentStatus]?.indexWhere((order) => order.sId == orderId);
//       if (orderIndex != null && orderIndex != -1) {
//         final orderToMove = _ordersByStatus[currentStatus]!.removeAt(orderIndex);
//         orderToMove.deliveryAgentStatus = newStatus;

//         if (_ordersByStatus.containsKey(newStatus)) {
//           _ordersByStatus[newStatus]!.insert(0, orderToMove);
//         }
//         notifyListeners();
//       }
//     }
//     return success;
//   }

//   Future<bool> updatePaymentStatus({
//     required String orderId,
//     required String newPaymentStatus,
//   }) async {
//     final bool success = await _orderService.updatePaymentStatus(
//       orderId: orderId,
//       paymentStatus: newPaymentStatus,
//     );

//     if (success) {
//       _updateLocalOrder(orderId, (order) {
//         order.paymentStatus = newPaymentStatus;
//       });
//       notifyListeners();
//     }
//     return success;
//   }

//   Future<bool> updateMainOrderStatus({
//     required String orderId,
//     required String newOrderStatus,
//   }) async {
//     final bool success = await _orderService.updateOrderStatus(
//       orderId: orderId,
//       newOrderStatus: newOrderStatus,
//     );

//     if (success) {
//       _updateLocalOrder(orderId, (order) {
//         order.orderStatus = newOrderStatus;
//       });
//       notifyListeners();
//     }
//     return success;
//   }

//   void _updateLocalOrder(String orderId, void Function(OrderModel order) updateAction) {
//     for (var orderList in _ordersByStatus.values) {
//       final index = orderList.indexWhere((o) => o.sId == orderId);
//       if (index != -1) {
//         updateAction(orderList[index]);
//         return;
//       }
//     }
//   }

//   void reset({String? deliveryAgentStatus}) {
//     if (deliveryAgentStatus != null && _ordersByStatus.containsKey(deliveryAgentStatus)) {
//       _ordersByStatus[deliveryAgentStatus]?.clear();
//       _cursorByStatus[deliveryAgentStatus] = null;
//       _hasMoreByStatus[deliveryAgentStatus] = true;
//       _isLoadingByStatus[deliveryAgentStatus] = false;
//     } else {
//       _ordersByStatus.forEach((key, value) => value.clear());
//       _cursorByStatus.updateAll((key, value) => null);
//       _hasMoreByStatus.updateAll((key, value) => true);
//       _isLoadingByStatus.updateAll((key, value) => false);
//     }
//     notifyListeners();
//   }
// }



import 'package:flutter/foundation.dart';
import '../../data/models/order_model.dart';
import '../../data/services/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();

  // State maps
  final Map<String, List<OrderModel>> _ordersByStatus = {
    "Assigned": [], "Delivering": [], "Delivered": [],
  };
  final Map<String, String?> _cursorByStatus = {
    "Assigned": null, "Delivering": null, "Delivered": null,
  };
  final Map<String, bool> _hasMoreByStatus = {
    "Assigned": true, "Delivering": true, "Delivered": true,
  };
  final Map<String, bool> _isLoadingByStatus = {
    "Assigned": false, "Delivering": false, "Delivered": false,
  };

  // Public getters
  List<OrderModel> assignedOrders() => _ordersByStatus["Assigned"]!;
  List<OrderModel> deliveringOrders() => _ordersByStatus["Delivering"]!;
  List<OrderModel> deliveredOrders() => _ordersByStatus["Delivered"]!;
  bool isLoading(String status) => _isLoadingByStatus[status] ?? false;
  bool hasMore(String status) => _hasMoreByStatus[status] ?? true;

  // DATA FETCHING
  // ✅ UPDATED: The employeeId parameter has been removed as requested.
  Future<void> fetchOrders({
    required String deliveryAgentStatus,
    int limit = 10,
  }) async {
    if (!_isLoadingByStatus.containsKey(deliveryAgentStatus) || isLoading(deliveryAgentStatus) || !hasMore(deliveryAgentStatus)) return;

    _isLoadingByStatus[deliveryAgentStatus] = true;
    notifyListeners();

    try {
      // The call to the service is now simpler.
      final data = await _orderService.fetchOrders(
        deliveryAgentStatus: deliveryAgentStatus,
        cursor: _cursorByStatus[deliveryAgentStatus],
        limit: limit,
      );

      final List<OrderModel> newOrders = data["orders"];
      final String? nextCursor = data["nextCursor"];

      _cursorByStatus[deliveryAgentStatus] = nextCursor;
      _ordersByStatus[deliveryAgentStatus]!.addAll(newOrders);

      if (nextCursor == null) {
        _hasMoreByStatus[deliveryAgentStatus] = false;
      }
    } catch (e) {
      debugPrint("Error fetching orders for $deliveryAgentStatus: $e");
    } finally {
      _isLoadingByStatus[deliveryAgentStatus] = false;
      notifyListeners();
    }
  }

  // DATA MANIPULATION
  // ✅ UPDATED: The employeeId parameter has been removed here as well.
  Future<bool> updateDeliveryAgentStatus({
    required String orderId,
    required String currentStatus,
    required String newStatus,
  }) async {
    final bool success = await _orderService.updateAgentOrderStatus(
      orderId: orderId,
      newStatus: newStatus,
    );

    if (success) {
      final orderIndex = _ordersByStatus[currentStatus]?.indexWhere((order) => order.sId == orderId);
      if (orderIndex != null && orderIndex != -1) {
        final orderToMove = _ordersByStatus[currentStatus]!.removeAt(orderIndex);
        orderToMove.deliveryAgentStatus = newStatus;

        if (_ordersByStatus.containsKey(newStatus)) {
          _ordersByStatus[newStatus]!.insert(0, orderToMove);
        }
        
        if (newStatus == "Delivered") {
          reset(deliveryAgentStatus: "Delivered");
          // The background fetch no longer needs the employeeId.
          fetchOrders(deliveryAgentStatus: "Delivered");
        } else {
           notifyListeners();
        }
      }
    }
    return success;
  }

  Future<bool> updatePaymentStatus({
    required String orderId,
    required String newPaymentStatus,
  }) async {
    final bool success = await _orderService.updatePaymentStatus(
      orderId: orderId,
      paymentStatus: newPaymentStatus,
    );

    if (success) {
      _updateLocalOrder(orderId, (order) {
        order.paymentStatus = newPaymentStatus;
      });
      notifyListeners();
    }
    return success;
  }

  Future<bool> updateMainOrderStatus({
    required String orderId,
    required String newOrderStatus,
  }) async {
    final bool success = await _orderService.updateOrderStatus(
      orderId: orderId,
      newOrderStatus: newOrderStatus,
    );

    if (success) {
      _updateLocalOrder(orderId, (order) {
        order.orderStatus = newOrderStatus;
      });
      notifyListeners();
    }
    return success;
  }

  void _updateLocalOrder(String orderId, void Function(OrderModel order) updateAction) {
    for (var orderList in _ordersByStatus.values) {
      final index = orderList.indexWhere((o) => o.sId == orderId);
      if (index != -1) {
        updateAction(orderList[index]);
        return;
      }
    }
  }

  void reset({String? deliveryAgentStatus}) {
    if (deliveryAgentStatus != null && _ordersByStatus.containsKey(deliveryAgentStatus)) {
      _ordersByStatus[deliveryAgentStatus]?.clear();
      _cursorByStatus[deliveryAgentStatus] = null;
      _hasMoreByStatus[deliveryAgentStatus] = true;
      _isLoadingByStatus[deliveryAgentStatus] = false;
    } else {
      _ordersByStatus.forEach((key, value) => value.clear());
      _cursorByStatus.updateAll((key, value) => null);
      _hasMoreByStatus.updateAll((key, value) => true);
      _isLoadingByStatus.updateAll((key, value) => false);
    }
    notifyListeners();
  }
}
