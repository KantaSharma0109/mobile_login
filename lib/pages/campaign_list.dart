// import 'package:flutter/material.dart';
// import 'package:mobile_login/campaign_lists_pages/bus_shelter_page.dart';
// import 'package:mobile_login/campaign_lists_pages/gantry.dart';
// import 'package:mobile_login/campaign_lists_pages/hording_page.dart';
// import 'package:mobile_login/campaign_lists_pages/pole_kiosks_page.dart';
// import 'package:mobile_login/campaign_lists_pages/unipole.dart';

// // Define a new page for the campaign list
// class CampaignListPage extends StatelessWidget {
//   const CampaignListPage({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Campaign Types"),
//       ),
//       body: ListView(
//         children: [
//           ListTile(
//             title: const Text("Bus Shelters"),
//             onTap: () {
//               // Action when Bus Shelter is selected
//               // Navigate to BusShelterPage when "Bus Shelter" is selected
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const BusShelterPage()),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text("Unipole"),
//             onTap: () {
//               // Action when Unipole is selected
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const UnipolePage()),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text("Hoarding"),
//             onTap: () {
//               // Action when Hoarding is selected
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const HoardingsPage()),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text("Polo Kiosks"),
//             onTap: () {
//               // Action when Polo Kiosks is selected
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const PoleKiosksPage()),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text("Gantry"),
//             onTap: () {
//               // Action when Gantry is selected
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const GantryPage()),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_login/add_campaign_page/location_list_page.dart'; // Import the LocationListPage

class CampaignListPage extends StatefulWidget {
  // const CampaignListPage({super.key});
  final String? userId;

  const CampaignListPage({super.key, this.userId});

  @override
  CampaignListPageState createState() => CampaignListPageState();
}

class CampaignListPageState extends State<CampaignListPage> {
  String? userId;
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    userId = widget.userId;
  }

  Future<void> _fetchCategories() async {
    final response = await http.get(
        Uri.parse("http://192.168.29.202:8080/mobilelogin_api/categories.php"));

    if (response.statusCode == 200) {
      List<dynamic> categories = json.decode(response.body);
      setState(() {
        _categories = categories
            .map((category) => {
                  'id': int.parse(category['id']), // Ensure id is an integer
                  'categoryname': category['categoryname'],
                })
            .toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Campaign Types"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return ListTile(
                  title: Text(category['categoryname']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocationListPage(
                          categoryId: category['id'],
                          categoryName: category['categoryname'],
                          userId: userId, // Pass the userId here
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
