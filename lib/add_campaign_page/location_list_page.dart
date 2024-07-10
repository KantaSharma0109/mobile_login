import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_login/add_campaign_page/location_detail_page.dart';
import 'package:mobile_login/model/campaign_data.dart';
import 'package:mobile_login/model/advertising_structure.dart'; // Import the new detail page

class LocationListPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final String? userId;

  const LocationListPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
    this.userId,
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

  Widget _buildLocationBox(
    BuildContext context,
    String title,
    String subtitle,
    String imagePath,
    int locationId,
    String cityName,
    int cityId,
  ) {
    String imageUrl =
        'http://192.168.29.202:8080/mobilelogin_api/img/locations/$imagePath';

    return GestureDetector(
      onTap: () {
        // Handle "More Details" action here
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Expanded(
                //   flex: 1,
                //   child: Container(
                //     padding: const EdgeInsets.all(8),
                //     color: Colors.grey[200],
                //     child: Text(
                //       subtitle,
                //       style: const TextStyle(
                //           fontSize: 14, fontWeight: FontWeight.bold),
                //     ),
                //   ),
                // ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey[200],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  // child: GestureDetector(
                  //   onTap: () {
                  //     showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return Dialog(
                  //           child: Column(
                  //             mainAxisSize: MainAxisSize.min,
                  //             children: [
                  //               Image.network(
                  //                 // imagePath,
                  //                 imageUrl,
                  //                 fit: BoxFit.cover,
                  //               ),
                  //               TextButton(
                  //                 onPressed: () {
                  //                   Navigator.of(context).pop();
                  //                 },
                  //                 child: const Text('Close'),
                  //               ),
                  //             ],
                  //           ),
                  //         );
                  //       },
                  //     );
                  //   },
                  //   child: Image.network(
                  //     // imagePath,
                  //     imageUrl,
                  //     height: 50,
                  //     width: 50,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          imageUrl,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
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
                                  cityName: cityName,
                                  cityId: cityId,
                                  imageUrl:
                                      'http://192.168.29.202:8080/mobilelogin_api/img/locations/$imagePath',
                                ),
                              );
                        });
                        // Show a confirmation message that the campaign is added
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Campaign added to cart.'),
                          ),
                        );
                      }
                    },
                    child: const Text("Add Campaign"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationDetailPage(
                            locationId: locationId,
                            userId: widget.userId,
                            imageUrl: imageUrl,
                          ),
                        ),
                      );
                    },
                    child: const Text("More Details"),
                  ),
                ),
              ],
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
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.shopping_cart),
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => CampaignDetailPage(
        //             userId: userId,
        //             categoryId: widget.categoryId,
        //             locationId: null, // You can handle this accordingly
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _locations.length,
              itemBuilder: (context, index) {
                final location = _locations[index];
                final locationId = int.tryParse(location['id'].toString()) ?? 0;
                final cityId =
                    int.tryParse(location['city_id'].toString()) ?? 0;
                final cityName = location['city_name'] ?? '';
                return _buildLocationBox(
                  context,
                  widget.categoryName,
                  location['location_name'] ?? '',
                  location['location_image'] ?? '',
                  locationId,
                  cityName,
                  cityId,
                );
              },
            ),
    );
  }
}
