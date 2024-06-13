import 'package:flutter/material.dart';
import 'package:mobile_login/pages/campaign_history_page.dart';
import 'package:mobile_login/pages/campaign_list.dart';

class OrderPage extends StatelessWidget {
  final String? userId; // Add userId parameter
  const OrderPage({super.key, this.userId});

  bool hasCampaignDetails() {
    String? campaignName;
    String? startingDate;
    String? endingDate;
    return campaignName != null && startingDate != null && endingDate != null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   'User ID: ${userId ?? "No user ID"}',
          //   style: TextStyle(fontSize: 18),
          // ),
          hasCampaignDetails()
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Campaign Name: Your Campaign Name"),
                    const Text("Starting Date: January 1, 2025"),
                    const Text("Ending Date: January 31, 2025"),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Action for "See More" button
                        },
                        child: const Text("See More"),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("You don't have any campaign right now"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CampaignHistoryPage()),
                        );
                      },
                      child: const Text("Go to your previous campaign history"),
                    ),
                  ],
                ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CampaignListPage()),
                );
              },
              child: const Text("Book New Campaign"),
            ),
          ),
        ],
      ),
    );
  }
}
