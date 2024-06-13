import 'package:flutter/material.dart';
import 'package:mobile_login/model/campaign_data.dart';

class CampaignHistoryPage extends StatelessWidget {
  // const CampaignHistoryPage({super.key});
  final String? userId;

  const CampaignHistoryPage({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    final history = CampaignData().historyStructures;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Campaign History"),
      ),
      body: history.isEmpty
          ? const Center(
              child: Text("No campaign history available."),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset(history[index].imagePath),
                  title: Text(history[index].title),
                  subtitle: Text(history[index].subtitle),
                );
              },
            ),
    );
  }
}
