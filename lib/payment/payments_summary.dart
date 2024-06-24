import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_login/payment/receipts_popup.dart';

class PaymentsSummaryPage extends StatefulWidget {
  final String userId;

  const PaymentsSummaryPage({super.key, required this.userId});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentsSummaryPageState createState() => _PaymentsSummaryPageState();
}

class _PaymentsSummaryPageState extends State<PaymentsSummaryPage> {
  List<dynamic> _accounts = [];

  @override
  void initState() {
    super.initState();
    _fetchPaymentsSummary();
  }

  Future<void> _fetchPaymentsSummary() async {
    final response = await http.get(Uri.parse(
        'http://192.168.29.202:8080/mobilelogin_api/get_payments_summary.php?userId=${widget.userId}'));

    if (response.statusCode == 200) {
      setState(() {
        _accounts = json.decode(response.body);
      });
    } else {
      // Handle the error
    }
  }

  void _showReceiptsPopup(String campaignId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReceiptsPopup(campaignId: campaignId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Payments'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Row(
              children: [
                Expanded(child: Text('Campaign ID')),
                Expanded(child: Text('Total Amount')),
                Expanded(child: Text('Received Amount')),
              ],
            ),
            const Divider(),
            ..._accounts.map((account) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(account['campaign_id'].toString())),
                      Expanded(child: Text(account['total_amount'].toString())),
                      Expanded(
                          child: Text(account['received_amount'].toString())),
                    ],
                  ),
                  const SizedBox(height: 5), // Add some space between the rows
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.end, // Align the button to the right
                    children: [
                      ElevatedButton(
                        onPressed: () => _showReceiptsPopup(
                            account['campaign_id'].toString()),
                        child: const Text('See All Receipts'),
                      ),
                    ],
                  ),
                  const Divider(), // Add a divider between each campaign entry
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
