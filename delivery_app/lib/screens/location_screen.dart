// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:latlong2/latlong.dart';
// import '../models/order_model.dart';
// import 'map_screen.dart';

// class LocationHome extends StatefulWidget {
//   final Address address;
//   const LocationHome({super.key, required this.address});


//   @override
//   State<LocationHome> createState() => _LocationHomeState();
// }

// class _LocationHomeState extends State<LocationHome> {
//   LatLng? _currentPosition;
//   bool _isLoading = false;

//   /// ✅ Reused enhanced location function from AddressFormSheet
//   Future<Position> _determinePosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     print("Location services enabled: $serviceEnabled");

//     if (!serviceEnabled) {
//       await Geolocator.openLocationSettings();
//       serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       print("After settings, location enabled: $serviceEnabled");
//       if (!serviceEnabled) throw 'Location services are disabled.';
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     print("Initial permission: $permission");

//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       print("After requesting: $permission");
//       if (permission == LocationPermission.denied) {
//         throw 'Location permission denied.';
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       await Geolocator.openAppSettings();
//       permission = await Geolocator.checkPermission();
//       print("After app settings: $permission");
//       if (permission == LocationPermission.deniedForever ||
//           permission == LocationPermission.denied) {
//         throw 'Location permission permanently denied.';
//       }
//     }

//     return await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//   }

//   Future<void> _getCurrentLocation() async {
//     setState(() => _isLoading = true);
//     try {
//       final position = await _determinePosition();
//       setState(() {
//         _currentPosition = LatLng(position.latitude, position.longitude);
//         _isLoading = false;
//       });

//       print("Fetched position: $_currentPosition");

//       if (_currentPosition == null) return;

//       // ✅ Navigate to map screen  
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => MapScreen(currentLocation: _currentPosition! , address:widget.address,),
//         ),
//       );
//     } catch (e) {
//       setState(() => _isLoading = false);
//       _showError("try again");
//       print("Error fetching location: $e");
//     }
//   }

//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Get Current Location")),
//       body: Center(
//         child: _isLoading
//             ? const CircularProgressIndicator()
//             : ElevatedButton.icon(
//                 onPressed: _getCurrentLocation,
//                 icon: const Icon(Icons.my_location),
//                 label: const Text("Get My Location"),
//               ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/order_model.dart';
import '../screens/map_screen.dart';

class LocationButton extends StatefulWidget {
  final Address address;
  final String buttonText;

  const LocationButton({
    super.key,
    required this.address,
    this.buttonText = "View Location",
  });

  @override
  State<LocationButton> createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButton> {
  bool _isLoading = false;

  /// ✅ Determine current location with permission handling
  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw 'Location services are disabled.';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permission denied.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        throw 'Location permission permanently denied.';
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _handleLocation() async {
    setState(() => _isLoading = true);

    try {
      final position = await _determinePosition();
      final currentLatLng = LatLng(position.latitude, position.longitude);

      // Navigate to MapScreen
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MapScreen(
              currentLocation: currentLatLng,
              address: widget.address,
            ),
          ),
        );
      }
    } catch (e) {
      _showError("Error fetching location: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _handleLocation,
      icon: _isLoading
          ? const SizedBox(
              width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.my_location),
      label: Text(_isLoading ? "Fetching..." : widget.buttonText),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
    );
  }
}
