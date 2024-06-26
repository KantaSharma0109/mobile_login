import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:mobile_login/add_campaign_page/location_list_page.dart'; // Import the LocationListPage
import 'package:mobile_login/add_campaign_page/flex_selection_page.dart';

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
                        // builder: (context) => LocationListPage(

                        builder: (context) => FlexSelectionPage(
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
