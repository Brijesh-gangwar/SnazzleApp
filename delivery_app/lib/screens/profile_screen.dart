import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../models/agent_details_model.dart';
import '../providers/agent_details_provider.dart';
import '../services/auth_service.dart'; 
import '../widgets/online_status_toggle_card.dart';
import '../widgets/personal_info_screen.dart';
import 'login_screen.dart'; // Import for navigation

class AgentDetailsScreen extends StatefulWidget {
  const AgentDetailsScreen({super.key});

  @override
  State<AgentDetailsScreen> createState() => _AgentDetailsScreenState();
}

class _AgentDetailsScreenState extends State<AgentDetailsScreen> {


  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<AgentDetailsProvider>();
      if (provider.agentDetails == null) {
        provider.fetchAgentDetails();
      }
    });
  }

  // --- LOGOUT LOGIC ---
  Future<void> _logout() async {
    final authService = AuthService();
    await authService.logout();
    if (mounted) {
      // Navigate to LoginScreen and remove all previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AgentDetailsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.agentDetails == null) {
              return _buildShimmerEffect();
            }

            if (provider.error != null && provider.agentDetails == null) {
              return Center(child: Text("Error: ${provider.error}"));
            }

            if (provider.agentDetails == null) {
              return const Center(child: Text("No agent details found."));
            }

            final agent = provider.agentDetails!;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text('Profile', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  _buildProfileHeader(agent),
                  const SizedBox(height: 24),
                  const OnlineStatusToggleCard(), // Now correctly linked to the provider
                  const SizedBox(height: 16),
                  _buildStatsRow(agent), // Now correctly formats the date
                  const SizedBox(height: 24),
                  _buildAccountSection(), // Now handles logout
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // --- UI Helper Widgets ---

  Widget _buildProfileHeader(AgentDetailsModel agent) {
    return Center(
      child: Column(
        children: [
          Text(agent.fullName ?? 'Delivery Agent', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(agent.email ?? 'No email', style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                '${agent.rating?.toStringAsFixed(1) ?? 'N/A'} (${agent.deliveries?.toString() ?? '0'} deliveries)',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(AgentDetailsModel agent) {
    return Row(
      children: [
        Expanded(child: _buildStatCard(agent.rating?.toStringAsFixed(1) ?? 'N/A', 'Rating')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard(agent.deliveries?.toString() ?? '0', 'Deliveries')),
        const SizedBox(width: 12),
        // Correctly uses the date formatting helper
        Expanded(child: _buildStatCard(agent.createdAt!, 'Joined')),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
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

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _buildAccountOptionRow(Icons.person_outline, 'Personal Information'),
        _buildAccountOptionRow(Icons.logout, 'Logout'),
      ],
    );
  }

Widget _buildAccountOptionRow(IconData icon, String title) {
    return InkWell(
      onTap: () {
        // ✅ 2. UPDATE THIS LOGIC
        if (title == 'Logout') {
          _logout();
        } else if (title == 'Personal Information') {
          // Navigate to the new screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PersonalInformationScreen(),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: title == 'Logout'
                  ? Colors.red.shade50
                  : Colors.grey.shade100,
              foregroundColor:
                  title == 'Logout' ? Colors.red : Colors.black,
              child: Icon(icon, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: title == 'Logout' ? Colors.red : Colors.black,
                ),
              ),
            ),
            if (title != 'Logout')
              const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
  // --- Shimmer Loading Effect ---

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildShimmerPlaceholder(height: 30, width: 100),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  _buildShimmerPlaceholder(height: 22, width: 200),
                  const SizedBox(height: 6),
                  _buildShimmerPlaceholder(height: 16, width: 250),
                  const SizedBox(height: 8),
                  _buildShimmerPlaceholder(height: 20, width: 180),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildShimmerPlaceholder(height: 60),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildShimmerPlaceholder(height: 85)),
                const SizedBox(width: 12),
                Expanded(child: _buildShimmerPlaceholder(height: 85)),
                const SizedBox(width: 12),
                Expanded(child: _buildShimmerPlaceholder(height: 85)),
              ],
            ),
            const SizedBox(height: 24),
            _buildShimmerPlaceholder(height: 20, width: 120),
            const SizedBox(height: 10),
            _buildShimmerPlaceholder(height: 50),
            _buildShimmerPlaceholder(height: 50), // Shimmer for logout button
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerPlaceholder({required double height, double? width}) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}