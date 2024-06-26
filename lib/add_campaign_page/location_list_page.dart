import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_login/add_campaign_page/campaign_detail.dart';
import 'dart:convert';
import 'package:mobile_login/add_campaign_page/location_detail_page.dart';
import 'package:mobile_login/model/campaign_data.dart';
import 'package:mobile_login/model/advertising_structure.dart'; // Import the new detail page

class LocationListPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final String? userId;
  final bool? flexSelected; // Yes or No selection
  final String? flexType; // Normal or Black

  const LocationListPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
    this.userId,
    this.flexSelected,
    this.flexType,
  });

  @override
  LocationListPageState createState() => LocationListPageState();
}

class LocationListPageState extends State<LocationListPage> {
  CampaignData campaignData = CampaignData();
  String? userId;
  List<dynamic> _locations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLocations();
    userId = widget.userId;
  }

  Future<void> _fetchLocations() async {
    final response = await http.get(Uri.parse(
        "http://192.168.29.202:8080/mobilelogin_api/locations.php?category_id=${widget.categoryId}"));

    if (response.statusCode == 200) {
      final List<dynamic> locations = json.decode(response.body);
      setState(() {
        _locations = locations;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load locations');
    }
  }

  Widget _buildLocationBox(BuildContext context, String title, String subtitle,
      String imagePath, int locationId) {
    return GestureDetector(
      onTap: () {
        // Handle "More Details" action here
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imagePath, // Use empty string if imagePath is null
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            // Text(
            //   'Category ID: ${widget.categoryId}', // Display Category ID
            //   style: const TextStyle(fontSize: 14, color: Colors.grey),
            // ),
            // const SizedBox(height: 5),
            // Text(
            //   'Location ID: $locationId', // Display Location ID
            //   style: const TextStyle(fontSize: 14, color: Colors.grey),
            // ),

            const SizedBox(height: 5),
            Text(
              title, // Use empty string if title is null
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle, // Use empty string if subtitle is null
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Check if the selected structure already exists in the list
                bool alreadyAdded = CampaignData().selectedStructures.any(
                    (element) =>
                        element.title == title &&
                        element.subtitle == subtitle &&
                        element.imagePath == imagePath);

                if (alreadyAdded) {
                  // Show a message indicating that the information is already added
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('This information is already added.'),
                    ),
                  );
                } else {
                  // Add selected structure to campaign details
                  setState(() {
                    CampaignData().selectedStructures.add(
                          AdvertisingStructure(
                            title: title,
                            subtitle: subtitle,
                            imagePath: imagePath,
                            categoryId: widget.categoryId,
                            locationId: locationId,
                            flexSelected: widget.flexSelected,
                            flexType: widget.flexType,
                          ),
                        );
                  });
                }
              },
              child: const Text("Add to Campaign"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationDetailPage(
                      locationId: locationId,
                      userId: widget.userId,
                    ),
                  ),
                );
              },
              child: const Text("More Details"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.categoryName} Locations"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CampaignDetailPage(
                    userId: userId,
                    categoryId: widget.categoryId,
                    locationId: null, // You can handle this accordingly
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _locations.length,
              itemBuilder: (context, index) {
                final location = _locations[index];
                final locationId = int.tryParse(location['id'].toString()) ?? 0;
                return _buildLocationBox(
                  context,
                  widget.categoryName,
                  location['location_name'] ?? '',
                  location['location_image'] ?? '',
                  locationId,
                );
              },
            ),
    );
  }
}
