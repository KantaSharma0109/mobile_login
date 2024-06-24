import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class QuotePage extends StatefulWidget {
  final String? userId;

  const QuotePage({super.key, this.userId});

  @override
  QuotePageState createState() => QuotePageState();
}

class QuotePageState extends State<QuotePage> {
  String? userId;
  List<dynamic> quotations = [];
  bool isLoading = true;
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    fetchQuotations();
  }

  Future<void> fetchQuotations() async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.29.202:8080/mobilelogin_api/fetch_quatation_data.php?userId=$userId'),
    );

    if (response.statusCode == 200) {
      setState(() {
        quotations = json.decode(response.body);
        calculateTotalPrice();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load quotations');
    }
  }

  void calculateTotalPrice() {
    double total = 0.0;
    for (var quotation in quotations) {
      total += double.tryParse(quotation['total_amount'].toString()) ?? 0.0;
    }
    setState(() {
      totalPrice = total;
    });
  }

  Future<void> updateQuotationStatus(int quotationId, String status) async {
    final response = await http.post(
      Uri.parse(
          'http://192.168.29.202:8080/mobilelogin_api/update_quotation_status.php'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'quotationId': quotationId.toString(),
        'status': status,
      },
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['success']) {
        setState(() {
          quotations = quotations.map((quotation) {
            if (quotation['id'] == quotationId) {
              quotation['status'] = status;
            }
            return quotation;
          }).toList();
          calculateTotalPrice();
        });
      } else {
        print('Failed to update status: ${result['error']}');
      }
    } else {
      throw Exception('Failed to update status');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: quotations.length,
                    itemBuilder: (context, index) {
                      final quotation = quotations[index];
                      return Card(
                        child: ListTile(
                          title: const Text('Quotation'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Category Name: ${quotation['categoryname']}'),
                              Text(
                                  'Location Name: ${quotation['location_name']}'),
                              Text('Start Date: ${quotation['start_date']}'),
                              Text('End Date: ${quotation['end_date']}'),
                              Text('Price: ${quotation['total_amount']}'),
                              if (quotation['status'] != 'approved' &&
                                  quotation['status'] != 'rejected')
                                ButtonBar(
                                  children: [
                                    MaterialButton(
                                      onPressed: () {
                                        updateQuotationStatus(
                                            quotation['id'], 'approved');
                                      },
                                      textColor: Colors.green,
                                      child: const Text('Approve'),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        updateQuotationStatus(
                                            quotation['id'], 'rejected');
                                      },
                                      textColor: Colors.red,
                                      child: const Text('Reject'),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(thickness: 2),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₹${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
