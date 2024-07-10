// import 'package:flutter/material.dart';
// import 'package:mobile_login/pages/order_page.dart';
// import 'package:mobile_login/pages/quote_page.dart';

// class CustomerPage extends StatefulWidget {
//   final String? userId; // Add userId parameter
//   const CustomerPage({super.key, this.userId});

//   @override
//   _CustomerPageState createState() => _CustomerPageState();
// }

// class _CustomerPageState extends State<CustomerPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String? userId;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     userId = widget.userId;
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // title: const Text("Customer Page"),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: "Order"),
//             Tab(text: "Quote"),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           OrderPage(userId: userId),
//           QuotePage(userId: userId),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:mobile_login/pages/order_page.dart';
// import 'package:mobile_login/pages/quote_page.dart';

// class CustomerPage extends StatefulWidget {
//   final String? userId; // Add userId parameter
//   const CustomerPage({super.key, this.userId});

//   @override
//   _CustomerPageState createState() => _CustomerPageState();
// }

// class _CustomerPageState extends State<CustomerPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String? userId;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     userId = widget.userId;
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           Expanded(
//             child: Container(
//               // Wrap TabBar with Container for padding
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 50.0), // Adjust padding as needed
//               child: TabBar(
//                 controller: _tabController,
//                 tabs: const [
//                   Tab(text: "Order"),
//                   Tab(text: "Quote"),
//                 ],
//                 labelColor: const Color.fromARGB(
//                     255, 25, 61, 223), // Text color of selected tab
//                 unselectedLabelColor:
//                     Colors.black, // Text color of unselected tab
//                 indicatorColor: const Color.fromARGB(
//                     255, 25, 61, 223), // Color of the indicator
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           OrderPage(userId: userId),
//           QuotePage(userId: userId),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mobile_login/pages/order_page.dart';
import 'package:mobile_login/pages/quote_page.dart';

class CustomerPage extends StatefulWidget {
  final String? userId;
  final int initialTabIndex;

  const CustomerPage({super.key, this.userId, required this.initialTabIndex});

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
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.initialTabIndex);
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
        actions: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "Order"),
                  Tab(text: "Quote"),
                ],
                labelColor: const Color.fromARGB(255, 25, 61, 223),
                unselectedLabelColor: Colors.black,
                indicatorColor: const Color.fromARGB(255, 25, 61, 223),
              ),
            ),
          ),
        ],
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
