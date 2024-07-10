import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_login/model/campaign_data.dart';
import 'package:mobile_login/model/advertising_structure.dart';
import 'dart:convert';
import 'dart:math';

class CampaignDetailPage extends StatefulWidget {
  final String? userId;
  final int? categoryId;
  final int? locationId;
  final int? cityId;

  const CampaignDetailPage({
    super.key,
    this.userId,
    this.categoryId,
    this.locationId,
    this.cityId,
  });

  @override
  // ignore: no_logic_in_create_state
  CampaignDetailPageState createState() => CampaignDetailPageState(
        userId: userId,
        categoryId: categoryId,
        locationId: locationId,
        cityId: cityId,
      );
}

class CampaignDetailPageState extends State<CampaignDetailPage> {
  final String? userId;
  final int? categoryId;
  final int? locationId;
  final int? cityId;
  CampaignDetailPageState({
    this.userId,
    this.categoryId,
    this.locationId,
    this.cityId,
  });

  static List<AdvertisingStructure> campaignDetails =
      CampaignData().selectedStructures;
  List<DateTime> startDates = [];
  List<DateTime> endDates = [];
  bool flexNeeded = false; // Track if flex is needed for all rows
  String flexOption = 'Normal'; // Default flex option

  @override
  void initState() {
    super.initState();
    startDates = List<DateTime>.filled(campaignDetails.length, DateTime.now());
    endDates = List<DateTime>.filled(campaignDetails.length, DateTime.now());
    _loadDatesFromPreferences();
    _loadFlexOptionFromPreferences(); // Load saved flex option
  }

  _loadDatesFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < campaignDetails.length; i++) {
      setState(() {
        startDates[i] = DateTime.parse(prefs.getString('startDate_$i') ?? '');
        endDates[i] = DateTime.parse(prefs.getString('endDate_$i') ?? '');
      });
    }
  }

  _loadFlexOptionFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      flexNeeded = prefs.getBool('flexNeeded') ?? false;
      flexOption = prefs.getString('flexOption') ?? 'Normal';
    });
  }

  _saveDatesToPreferences(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('startDate_$index', startDates[index].toString());
    await prefs.setString('endDate_$index', endDates[index].toString());
  }

  void _removeCampaignDetail(int index) {
    setState(() {
      campaignDetails.removeAt(index);
      startDates.removeAt(index);
      endDates.removeAt(index);
    });
  }

  // Method to generate a unique 4-digit campaign ID
  String generateCampaignId() {
    final random = Random();
    return random.nextInt(10000).toString().padLeft(4, '0');
  }

  Future<void> _getQuote() async {
    final url = Uri.parse(
        "http://192.168.29.202:8080/mobilelogin_api/quote_insert.php");
    final campaignId = generateCampaignId();

    for (int i = 0; i < campaignDetails.length; i++) {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userId': widget.userId,
          'categoryId': campaignDetails[i].categoryId,
          'locationId': campaignDetails[i].locationId,
          'cityId': campaignDetails[i].cityId,
          'startDate': startDates[i].toIso8601String(),
          'endDate': endDates[i].toIso8601String(),
          'campaignId': campaignId, // Include the campaign ID
          'materialNeeded': flexNeeded ? 'yes' : 'no', // Use flexNeeded for all
          'materialId': flexNeeded ? flexOption : campaignDetails[i].flexType,
        }),
      );

      if (response.statusCode != 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit quote for item $i')),
        );
        return;
      }
    }

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quotes submitted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     title: const Text("Campaign Detail"),
      //     ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          //   child: Center(
          //       // child: Text(
          //       //   "Selected Campaigns",
          //       //   style: TextStyle(
          //       //     fontSize: 20,
          //       //     fontWeight: FontWeight.bold,
          //       //   ),
          //       // ),
          //       ),
          // ),
          Expanded(
            child: ListView.builder(
              itemCount: campaignDetails.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      campaignDetails[index].imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          campaignDetails[index].title,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () =>
                                            _removeCampaignDetail(index),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    campaignDetails[index].cityName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    campaignDetails[index].subtitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Center(
                          child: Text(
                            "Choose Date",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("Start Date:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                TextButton(
                                  onPressed: () =>
                                      _selectStartDate(context, index),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today),
                                      const SizedBox(width: 5),
                                      Text(startDates[index]
                                          .toString()
                                          .split(' ')[0]),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("End Date:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                TextButton(
                                  onPressed: () =>
                                      _selectEndDate(context, index),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today),
                                      const SizedBox(width: 5),
                                      Text(endDates[index]
                                          .toString()
                                          .split(' ')[0]),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // const Divider(),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     IconButton(
                        //       icon: const Icon(Icons.delete),
                        //       onPressed: () => _removeCampaignDetail(index),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Stack(
          //   children: [
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         const Padding(
          //           padding: EdgeInsets.only(
          //               left: 30, top: 5), // Adjust left padding as needed
          //           child: Text(
          //             "Flex Needed: ",
          //             style:
          //                 TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          //           ),
          //         ),
          //         // const SizedBox(height: 3),
          //         Row(
          //           children: [
          //             const SizedBox(width: 20), // Adjust spacing as needed
          //             DropdownButton<String>(
          //               value: flexNeeded ? 'Yes' : 'No',
          //               onChanged: (value) {
          //                 setState(() {
          //                   flexNeeded = value == 'Yes';
          //                   _saveFlexOptionToPreferences(); // Save flexNeeded state
          //                 });
          //               },
          //               items: ['No', 'Yes'].map((String value) {
          //                 return DropdownMenuItem<String>(
          //                   value: value,
          //                   child: Text(
          //                     value,
          //                     style: const TextStyle(
          //                       fontWeight: FontWeight.w400,
          //                     ),
          //                   ),
          //                 );
          //               }).toList(),
          //             ),
          //             if (flexNeeded)
          //               DropdownButton<String>(
          //                 value: flexOption,
          //                 onChanged: (value) {
          //                   setState(() {
          //                     flexOption = value!;
          //                     _saveFlexOptionToPreferences(); // Save flexOption state
          //                   });
          //                 },
          //                 items: ['Normal', 'Black'].map((String value) {
          //                   return DropdownMenuItem<String>(
          //                     value: value,
          //                     child: Text(
          //                       value,
          //                       style: const TextStyle(
          //                         fontWeight: FontWeight.w400,
          //                       ),
          //                     ),
          //                   );
          //                 }).toList(),
          //               ),
          //           ],
          //         ),
          //       ],
          //     ),
          //     Positioned(
          //       top: 0,
          //       right: 0,
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: ElevatedButton(
          //           onPressed: _getQuote,
          //           child: const Text("Get Quote"),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          Stack(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0, bottom: 10),
                      child: Text(
                        "Flex Needed:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 8), // Adjust spacing as needed
                        DropdownButton<String>(
                          value: flexNeeded ? 'Yes' : 'No',
                          onChanged: (value) {
                            setState(() {
                              flexNeeded = value == 'Yes';
                              _saveFlexOptionToPreferences(); // Save flexNeeded state
                            });
                          },
                          items: ['No', 'Yes'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        if (flexNeeded)
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: DropdownButton<String>(
                              value: flexOption,
                              onChanged: (value) {
                                setState(() {
                                  flexOption = value!;
                                  _saveFlexOptionToPreferences(); // Save flexOption state
                                });
                              },
                              items: ['Normal', 'Black'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 30,
                right: 25,
                child: ElevatedButton(
                  onPressed: _getQuote,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Get Quote"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context, int index) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != startDates[index]) {
      setState(() {
        startDates[index] = picked;
        if (endDates[index].isBefore(picked)) {
          endDates[index] = picked.add(const Duration(days: 1));
        }
        _saveDatesToPreferences(index);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context, int index) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDates[index].isAfter(now) ? endDates[index] : now,
      firstDate: startDates[index],
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != endDates[index]) {
      setState(() {
        endDates[index] = picked;
        _saveDatesToPreferences(index);
      });
    }
  }

  _saveFlexOptionToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('flexNeeded', flexNeeded);
    await prefs.setString('flexOption', flexOption);
  }
}
