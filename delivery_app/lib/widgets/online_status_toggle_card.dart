import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/agent_details_provider.dart';

class OnlineStatusToggleCard extends StatelessWidget {
  const OnlineStatusToggleCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a Consumer to get the latest agent details and rebuild on change
    return Consumer<AgentDetailsProvider>(
      builder: (context, provider, child) {
        // Determine the switch's value from the provider's state
        // Default to false if details are not yet loaded
        final bool isOnline = provider.agentDetails?.status == 'Online';

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.flash_on, color: Colors.amber, size: 30),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Online', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Available for deliveries', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                Switch(
                  value: isOnline,
                  onChanged: (value) {
                    // Determine the new status string
                    final newStatus = value ? 'Online' : 'Offline';
                    // Call the provider method to update the status
                    // Use context.read inside a callback for a one-time action
                    context.read<AgentDetailsProvider>().updateStatus(newStatus);
                  },
                  activeColor: Colors.black,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}