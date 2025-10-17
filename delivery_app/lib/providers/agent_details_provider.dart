// // lib/providers/agent_details_provider.dart

// import 'package:flutter/material.dart';
// import '../models/agent_details_model.dart';
// import '../services/details_service.dart';

// class AgentDetailsProvider with ChangeNotifier {
//   final DetailsService _detailsService = DetailsService();

//   AgentDetailsModel? _agentDetails;
//   bool _isLoading = false;
//   String? _error;

//   // Getters to access the state from the UI
//   AgentDetailsModel? get agentDetails => _agentDetails;
//   bool get isLoading => _isLoading;
//   String? get error => _error;

//   // Method to fetch the agent details
//   Future<void> fetchAgentDetails() async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners(); // Notify UI to show loading indicator

//     try {
//       // Fetch data from the service
//       _agentDetails = await _detailsService.fetchAgentDetails();
//     } catch (e) {
//       // If an error occurs, store the error message
//       _error = e.toString();
//     } finally {
//       // Once done, set loading to false and notify the UI
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }


// lib/providers/agent_details_provider.dart

import 'package:flutter/material.dart';
import '../models/agent_details_model.dart';
import '../services/details_service.dart';

class AgentDetailsProvider with ChangeNotifier {
  final DetailsService _detailsService = DetailsService();

  AgentDetailsModel? _agentDetails;
  bool _isLoading = false;
  String? _error;

  AgentDetailsModel? get agentDetails => _agentDetails;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAgentDetails() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _agentDetails = await _detailsService.fetchAgentDetails();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ NEW: Method to update status and notify listeners
  Future<void> updateStatus(String newStatus) async {
    if (_agentDetails == null) return; // Guard clause

    try {
      // Call the service to update the status on the backend
      await _detailsService.updateAgentStatus(newStatus);

      // If successful, update the local state
      _agentDetails!.status = newStatus;

      // Notify all listening widgets to rebuild
      notifyListeners();
      
    } catch (e) {
      // If the API call fails, you can handle the error,
      // for example by showing a snackbar.
      _error = "Failed to update status: $e";
      notifyListeners();
    }
  }
}