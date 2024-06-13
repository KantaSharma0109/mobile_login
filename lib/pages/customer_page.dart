// import 'package:flutter/material.dart';
// import 'package:mobile_login/pages/campaign_list.dart';

// class CustomerPage extends StatelessWidget {
//   const CustomerPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Customer Page"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Campaign Details",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             const Text("Campaign Name: Your Campaign Name"),
//             const Text("Starting Date: January 1, 2025"),
//             const Text("Ending Date: January 31, 2025"),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Action for "See More" button
//                 },
//                 child: const Text("See More"),
//               ),
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Action for "Book New Campaign" button
//                   // Navigate to the CampaignListPage when "Book New Campaign" button is pressed
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const CampaignListPage()),
//                   );
//                 },
//                 child: const Text("Book New Campaign"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:mobile_login/pages/campaign_history_page.dart';
// import 'package:mobile_login/pages/campaign_list.dart';

// class CustomerPage extends StatelessWidget {
//   const CustomerPage({super.key});

//   // Function to check if campaign details are available
//   bool hasCampaignDetails() {
//     // Assuming campaign details are stored in variables
//     String? campaignName;
//     String? startingDate;
//     String? endingDate;
//     // Check if all campaign details are not null
//     if (campaignName != null && startingDate != null && endingDate != null) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Customer Page"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Campaign Details",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             // Check if campaign details are available
//             hasCampaignDetails()
//                 ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text("Campaign Name: Your Campaign Name"),
//                       const Text("Starting Date: January 1, 2025"),
//                       const Text("Ending Date: January 31, 2025"),
//                       const SizedBox(height: 24),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             // Action for "See More" button
//                           },
//                           child: const Text("See More"),
//                         ),
//                       ),
//                     ],
//                   )
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text("You don't have any campaign right now"),
//                       TextButton(
//                         onPressed: () {
//                           // Navigate to the previous page (history page)
//                           // Here, you can replace CampaignListPage with the actual previous page
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     const CampaignHistoryPage()),
//                           );
//                         },
//                         child:
//                             const Text("Go to your previous campaign history"),
//                       ),
//                     ],
//                   ),

//             const SizedBox(height: 8),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Action for "Book New Campaign" button
//                   // Navigate to the CampaignListPage when "Book New Campaign" button is pressed
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const CampaignListPage()),
//                   );
//                 },
//                 child: const Text("Book New Campaign"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mobile_login/pages/order_page.dart';
import 'package:mobile_login/pages/quote_page.dart';

class CustomerPage extends StatefulWidget {
  final String? userId; // Add userId parameter
  const CustomerPage({super.key, this.userId});

  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? userId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    userId = widget.userId;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Page"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Order"),
            Tab(text: "Quote"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OrderPage(userId: userId),
          QuotePage(userId: userId),
        ],
      ),
    );
  }
}
