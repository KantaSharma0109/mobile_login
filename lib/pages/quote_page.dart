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
        isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load quotations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UserId: ${widget.userId ?? "No user ID"}'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: quotations.length,
              itemBuilder: (context, index) {
                final quotation = quotations[index];
                return Card(
                  child: ListTile(
                    title: const Text('Quotation'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text('Customer ID: ${quotation['customer_id']}'),
                        // Text('Category ID: ${quotation['category_id']}'),
                        // Text('Location ID: ${quotation['location_id']}'),
                        Text('Category Name: ${quotation['categoryname']}'),
                        Text('Location Name: ${quotation['location_name']}'),
                        Text('Start Date: ${quotation['start_date']}'),
                        Text('End Date: ${quotation['end_date']}'),
                        Text('Price: ${quotation['price']}'),
                        ButtonBar(
                          children: [
                            MaterialButton(
                              onPressed: () {
                                // Handle approve action
                                print('Quotation ${quotation['id']} Aprrovel');
                              },
                              textColor: Colors.green,
                              child: const Text('Approve'),
                            ),
                            MaterialButton(
                              onPressed: () {
                                // Handle reject action
                                print('Quotation ${quotation['id']} Reject');
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
    );
  }
}
