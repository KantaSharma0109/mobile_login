import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CampaignHistoryPage extends StatefulWidget {
  final String? userId;

  const CampaignHistoryPage({super.key, this.userId});

  @override
  CampaignHistoryPageState createState() => CampaignHistoryPageState();
}

class CampaignHistoryPageState extends State<CampaignHistoryPage> {
  List<dynamic> history = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCampaignHistory();
  }

  Future<void> fetchCampaignHistory() async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.29.202:8080/mobilelogin_api/fetch_campaign_history.php?userId=${widget.userId}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        history = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load campaign history');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Campaign History"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : history.isEmpty
              ? const Center(
                  child: Text("No campaign history available."),
                )
              : ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final campaign = history[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              // 'Campaign ${campaign['id']}',
                              'Campaign',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8.0),
                            Text('Category Name: ${campaign['categoryname']}'),
                            Text('Location Name: ${campaign['location_name']}'),
                            Text('Start Date: ${campaign['start_date']}'),
                            Text('End Date: ${campaign['end_date']}'),
                            Text('Price: ${campaign['price']}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
