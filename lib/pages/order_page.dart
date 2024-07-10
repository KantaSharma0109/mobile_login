// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:mobile_login/payment/payment_page.dart';
// import 'package:mobile_login/pages/campaign_history_page.dart';
// import 'package:mobile_login/add_campaign_page/campaign_list.dart';

// class OrderPage extends StatefulWidget {
//   final String? userId;

//   const OrderPage({super.key, required this.userId});

//   @override
//   OrderPageState createState() => OrderPageState();
// }

// class OrderPageState extends State<OrderPage> {
//   List<dynamic> quotations = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchQuotations();
//   }

//   Future<void> fetchQuotations() async {
//     final response = await http.get(
//       Uri.parse(
//           'http://192.168.29.202:8080/mobilelogin_api/fetch_order_data.php?userId=${widget.userId}'),
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         quotations = json.decode(response.body);
//         isLoading = false;
//         updateCustomerAccounts(); // Update customer accounts when data is fetched
//       });
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       throw Exception('Failed to load quotations');
//     }
//   }

//   Map<String, double> calculateTotalAmounts() {
//     Map<String, double> totalAmounts = {};

//     for (var quotation in quotations) {
//       String campaignId = quotation['campaign_id'].toString();
//       double total_amount =
//           double.tryParse(quotation['total_amount'].toString()) ?? 0.0;
//       totalAmounts[campaignId] =
//           (totalAmounts[campaignId] ?? 0.0) + total_amount;
//     }

//     return totalAmounts;
//   }

//   Future<void> updateCustomerAccounts() async {
//     Map<String, double> totalAmounts = calculateTotalAmounts();
//     for (var entry in totalAmounts.entries) {
//       await http.post(
//         Uri.parse(
//             'http://192.168.29.202:8080/mobilelogin_api/update_customer_account.php'),
//         body: {
//           'userId': widget.userId,
//           'campaignId': entry.key,
//           'totalAmount': entry.value.toString(),
//         },
//       );
//     }
//   }

//   void handlePayAction(String campaignId) {
//     double totalAmount = calculateTotalAmounts()[campaignId] ?? 0.0;
//     // Navigate to payment page with the campaign ID
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PaymentPage(
//           userId: widget.userId,
//           campaignId: campaignId,
//           totalAmount: totalAmount,
//           imageUrl: '',
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //     // title: Text('Order Page for User ${widget.userId}'),
//       //     ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : quotations.isEmpty
//               ? _buildEmptyState()
//               : Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: quotations.length,
//                         itemBuilder: (context, index) {
//                           final quotation = quotations[index];
//                           return Card(
//                             child: ListTile(
//                               // title: Text('Quotation ${quotation['id']}'),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                       'Category Name: ${quotation['categoryname']}'),
//                                   Text(
//                                       'Location Name: ${quotation['location_name']}'),
//                                   Text(
//                                       'Start Date: ${quotation['start_date']}'),
//                                   Text('End Date: ${quotation['end_date']}'),
//                                   Text('Price: ${quotation['total_amount']}'),
//                                   // ElevatedButton(
//                                   //   onPressed: () {
//                                   //     handlePayAction(
//                                   //         quotation['campaign_id'].toString());
//                                   //   },
//                                   //   child: const Text('Pay'),
//                                   // ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     const Divider(thickness: 2),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Total Amounts:',
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                           // SizedBox(height: 4),
//                           ...calculateTotalAmounts().entries.map((entry) {
//                             return Padding(
//                               padding: const EdgeInsets.only(bottom: 2.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text('Campaign ID: ${entry.key}'),
//                                   Text('₹${entry.value.toStringAsFixed(2)}'),
//                                   ElevatedButton(
//                                     onPressed: () {
//                                       handlePayAction(entry.key);
//                                     },
//                                     child: const Text('Pay'),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const CampaignListPage(
//                                       cityId: null,
//                                     )),
//                           );
//                         },
//                         child: const Text('Book New Campaign'),
//                       ),
//                     ),
//                   ],
//                 ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text("You don't have any active campaigns."),
//           TextButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         CampaignHistoryPage(userId: widget.userId)),
//               );
//             },
//             child: const Text("Go to your previous campaign history"),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const CampaignListPage(
//                           cityId: null,
//                         )),
//               );
//             },
//             child: const Text("Book New Campaign"),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mobile_login/payment/payment_page.dart';
import 'package:mobile_login/pages/campaign_history_page.dart';
import 'package:mobile_login/add_campaign_page/campaign_list.dart';

class OrderPage extends StatefulWidget {
  final String? userId;

  const OrderPage({super.key, required this.userId});

  @override
  OrderPageState createState() => OrderPageState();
}

class OrderPageState extends State<OrderPage> {
  List<dynamic> quotations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuotations();
  }

  Future<void> fetchQuotations() async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.29.202:8080/mobilelogin_api/fetch_order_data.php?userId=${widget.userId}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        quotations = json.decode(response.body);
        isLoading = false;
        updateCustomerAccounts(); // Update customer accounts when data is fetched
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load quotations');
    }
  }

  Map<String, double> calculateTotalAmounts() {
    Map<String, double> totalAmounts = {};

    for (var quotation in quotations) {
      String campaignId = quotation['campaign_id'].toString();
      double total_amount =
          double.tryParse(quotation['total_amount'].toString()) ?? 0.0;
      totalAmounts[campaignId] =
          (totalAmounts[campaignId] ?? 0.0) + total_amount;
    }

    return totalAmounts;
  }

  Future<void> updateCustomerAccounts() async {
    Map<String, double> totalAmounts = calculateTotalAmounts();
    for (var entry in totalAmounts.entries) {
      await http.post(
        Uri.parse(
            'http://192.168.29.202:8080/mobilelogin_api/update_customer_account.php'),
        body: {
          'userId': widget.userId!,
          'campaignId': entry.key,
          'totalAmount': entry.value.toString(),
        },
      );
    }
  }

  void handlePayAction(String campaignId) {
    double totalAmount = calculateTotalAmounts()[campaignId] ?? 0.0;
    // Navigate to payment page with the campaign ID
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          userId: widget.userId!,
          campaignId: campaignId,
          totalAmount: totalAmount,
          imageUrl: '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Your Orders'),
      // ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : quotations.isEmpty
              ? _buildEmptyState()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: quotations.length,
                        itemBuilder: (context, index) {
                          final quotation = quotations[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 5),
                            color: Colors.white,
                            child: ListTile(
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildItemRow(
                                      'Category', quotation['categoryname']),
                                  _buildItemRow(
                                      'Location', quotation['location_name']),
                                  _buildItemRow(
                                      'Start Date', quotation['start_date']),
                                  _buildItemRow(
                                      'End Date', quotation['end_date']),
                                  _buildItemRow(
                                      'Price', quotation['total_amount']),
                                  // ElevatedButton(
                                  //   onPressed: () {
                                  //     handlePayAction(
                                  //         quotation['campaign_id'].toString());
                                  //   },
                                  //   child: const Text('Pay'),
                                  // ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(thickness: 2),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       const Text(
                    //         'Total Amount:',
                    //         style: TextStyle(
                    //             fontSize: 18, fontWeight: FontWeight.bold),
                    //       ),
                    //       ...calculateTotalAmounts().entries.map((entry) {
                    //         return Padding(
                    //           padding: const EdgeInsets.only(bottom: 8.0),
                    //           child: Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               Text(
                    //                 'Campaign ID: ${entry.key}',
                    //                 style: const TextStyle(
                    //                     fontWeight: FontWeight.bold),
                    //               ),
                    //               Text('₹${entry.value.toStringAsFixed(2)}'),
                    //               ElevatedButton(
                    //                 onPressed: () {
                    //                   handlePayAction(entry.key);
                    //                 },
                    //                 child: const Text('Pay'),
                    //               ),
                    //             ],
                    //           ),
                    //         );
                    //       }).toList(),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Amount:',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                          const SizedBox(height: 8),
                          ...calculateTotalAmounts().entries.map((entry) {
                            return Card(
                              color: Colors.white,
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Campaign ID:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          entry.key,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Amount:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '₹${entry.value.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        handlePayAction(entry.key);
                                      },
                                      icon: const Icon(Icons.payment),
                                      label: const Text('Pay'),
                                      style: ElevatedButton.styleFrom(
                                        // foregroundColor: Colors.white,
                                        // backgroundColor: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CampaignListPage(
                                cityId: null,
                              ),
                            ),
                          );
                        },
                        child: const Text('Book New Campaign'),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildItemRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("You don't have any active campaigns."),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CampaignHistoryPage(userId: widget.userId),
                ),
              );
            },
            child: const Text("Go to your previous campaign history"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CampaignListPage(cityId: null),
                ),
              );
            },
            child: const Text("Book New Campaign"),
          ),
        ],
      ),
    );
  }
}
