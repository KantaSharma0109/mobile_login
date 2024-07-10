// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// // import 'package:mobile_login/add_campaign_page/flex_selection_page.dart';
// import 'package:mobile_login/add_campaign_page/location_list_page.dart';

// class CampaignListPage extends StatefulWidget {
//   final String? userId;
//   final int? cityId;

//   const CampaignListPage({
//     super.key,
//     this.userId,
//     required this.cityId,
//   });

//   @override
//   CampaignListPageState createState() => CampaignListPageState(
//         cityId: cityId,
//       );
// }

// class CampaignListPageState extends State<CampaignListPage> {
//   String? userId;
//   List<Map<String, dynamic>> _categories = [];
//   bool _isLoading = true;
//   final int? cityId;
//   CampaignListPageState({this.cityId});

//   @override
//   void initState() {
//     super.initState();
//     _fetchCategories();
//     userId = widget.userId;
//   }

//   Future<void> _fetchCategories() async {
//     final response = await http.get(Uri.parse(
//         "http://192.168.29.202:8080/mobilelogin_api/categories.php?city_id=${widget.cityId}"));

//     if (response.statusCode == 200) {
//       List<dynamic> categories = json.decode(response.body);
//       setState(() {
//         _categories = categories
//             .map((category) => {
//                   'id': int.parse(category['id']), // Ensure id is an integer
//                   'categoryname': category['categoryname'],
//                 })
//             .toList();
//         _isLoading = false;
//       });
//     } else {
//       throw Exception('Failed to load categories');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Campaign Types"),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: _categories.length,
//               itemBuilder: (context, index) {
//                 final category = _categories[index];
//                 return ListTile(
//                   // title: Text(category['categoryname']),
//                   title: Text("${category['categoryname']}"),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => LocationListPage(
//                           // builder: (context) => FlexSelectionPage(
//                           categoryId: category['id'],
//                           categoryName: category['categoryname'],
//                           userId: userId, // Pass the userId here
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_login/add_campaign_page/location_list_page.dart';

class CampaignListPage extends StatefulWidget {
  final String? userId;
  final int? cityId;

  const CampaignListPage({
    super.key,
    this.userId,
    required this.cityId,
  });

  @override
  // ignore: no_logic_in_create_state
  CampaignListPageState createState() => CampaignListPageState(
        cityId: cityId,
      );
}

class CampaignListPageState extends State<CampaignListPage> {
  String? userId;
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;
  final int? cityId;
  CampaignListPageState({this.cityId});

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    userId = widget.userId;
  }

  Future<void> _fetchCategories() async {
    final response = await http.get(Uri.parse(
        "http://192.168.29.202:8080/mobilelogin_api/categories.php?city_id=${widget.cityId}"));

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

  Widget _buildCategoryBox(
    BuildContext context,
    String categoryName,
    int categoryId,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LocationListPage(
              categoryId: categoryId,
              categoryName: categoryName,
              userId: userId,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              categoryName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
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
                return _buildCategoryBox(
                  context,
                  category['categoryname'],
                  category['id'],
                );
              },
            ),
    );
  }
}
