// import 'package:flutter/material.dart';
// import 'package:mobile_login/add_campaign_page/location_list_page.dart';

// class FlexSelectionPage extends StatefulWidget {
//   final int categoryId;
//   final String categoryName;
//   final String? userId;
//   final int? locationId;

//   const FlexSelectionPage({
//     super.key,
//     required this.categoryId,
//     required this.categoryName,
//     required this.userId,
//     this.locationId,
//   });

//   @override
//   // ignore: no_logic_in_create_state
//   FlexSelectionPageState createState() => FlexSelectionPageState(
//         userId: userId,
//         categoryId: categoryId,
//         locationId: locationId,
//       );
// }

// class FlexSelectionPageState extends State<FlexSelectionPage> {
//   final String? userId;
//   final int? categoryId;
//   final int? locationId;
//   String? _flexType;
//   bool _showFlexOptions = false;
//   FlexSelectionPageState({this.userId, this.categoryId, this.locationId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Choose Flex'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Text(
//             //   'User ID: ${userId ?? "No user ID"}',
//             //   style: const TextStyle(fontSize: 18),
//             // ),
//             const Text('Do you want to choose a flex?'),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   _showFlexOptions = true;
//                 });
//               },
//               child: const Text('Yes'),
//             ),
//             if (!_showFlexOptions) ...[
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   navigateToLocationPage(context, null);
//                 },
//                 child: const Text('No'),
//               ),
//             ],
//             if (_showFlexOptions) ...[
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   navigateToLocationPage(context, "normal");
//                 },
//                 child: const Text('Normal Flex'),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   navigateToLocationPage(context, "black");
//                 },
//                 child: const Text('Black Flex'),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   void navigateToLocationPage(BuildContext context, String? flexType) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => LocationListPage(
//           categoryId: widget.categoryId,
//           categoryName: widget.categoryName,
//           userId: widget.userId,
//           flexType: flexType, // Pass the flex type here
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mobile_login/add_campaign_page/location_list_page.dart';

class FlexSelectionPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final String? userId;
  final int? locationId;

  FlexSelectionPage({
    required this.categoryId,
    required this.categoryName,
    required this.userId,
    this.locationId,
  });

  @override
  FlexSelectionPageState createState() => FlexSelectionPageState(
        userId: userId,
        categoryId: categoryId,
        locationId: locationId,
      );
}

class FlexSelectionPageState extends State<FlexSelectionPage> {
  bool? _flexSelected;
  String? _flexType;
  final String? userId;
  final int? categoryId;
  final int? locationId;

  FlexSelectionPageState({this.userId, this.categoryId, this.locationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Flex'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Do you want to choose a flex?'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _flexSelected = true;
                });
              },
              child: const Text('Yes'),
            ),
            if (_flexSelected == null) ...[
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _navigateToLocationPage(context, false, null);
                },
                child: const Text('No'),
              ),
            ],
            if (_flexSelected == true) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _navigateToLocationPage(context, true, "normal");
                },
                child: const Text('Normal Flex'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _navigateToLocationPage(context, true, "black");
                },
                child: const Text('Black Flex'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _navigateToLocationPage(
      BuildContext context, bool flexSelected, String? flexType) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LocationListPage(
          categoryId: widget.categoryId,
          categoryName: widget.categoryName,
          userId: widget.userId,
          flexSelected: flexSelected,
          flexType: flexType,
        ),
      ),
    );
  }
}
