// import 'package:flutter/material.dart';

// import '../services/auth_service.dart';
// import 'home_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _employeeIdController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }

//   Future<void> _checkLoginStatus() async {
//     final authService = AuthService();
//     final savedId = await authService.getSavedEmployeeId();
//     if (savedId != null && mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
//       );
//     }
//   }

//   Future<void> _login() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       final authService = AuthService();
//       final success = await authService.login(
//         _emailController.text.trim(),
//         _employeeIdController.text.trim(),
//       );

//       if (success) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Login successful ✅")),
//           );
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const HomeScreen()),
//           );
//         }
//       } else {
//         setState(() => _errorMessage = "Invalid credentials");
//       }
//     } catch (e) {
//       setState(() => _errorMessage = e.toString());
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Delivery Agent Login")),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: "Email",
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) =>
//                     value == null || value.isEmpty ? "Enter your email" : null,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _employeeIdController,
//                 decoration: const InputDecoration(
//                   labelText: "Employee ID",
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) =>
//                     value == null || value.isEmpty ? "Enter your employee ID" : null,
//               ),
//               const SizedBox(height: 20),
//               if (_errorMessage != null)
//                 Text(
//                   _errorMessage!,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               const SizedBox(height: 10),
//               _isLoading
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                       onPressed: _login,
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: const Size.fromHeight(50),
//                       ),
//                       child: const Text("Login"),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'home_screen.dart';

import 'waiting_screen.dart'; // Import the waiting screen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _employeeIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  // The _checkLoginStatus method has been removed, as this logic
  // is correctly handled by the SplashScreen.

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = AuthService();
      // 1. Get the result map from the login service
      final loginResult = await authService.login(
        _emailController.text.trim(),
        _employeeIdController.text.trim(),
      );

      if (loginResult["success"] == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login successful ✅")),
        );

        // 2. Check the licenseStatus to determine navigation
        if (loginResult["licenseStatus"] == "Verified") {
          // Navigate to the main dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        } else {
          // Navigate to the waiting screen for unverified users
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const WaitingHomeScreen()),
          );
        }
      } else {
        setState(() => _errorMessage = "Invalid credentials. Please try again.");
      }
    } catch (e) {
      setState(() => _errorMessage = "An error occurred: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delivery Agent Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter your email" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _employeeIdController,
                decoration: const InputDecoration(
                  labelText: "Employee ID",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter your employee ID" : null,
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 10),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text("Login"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
