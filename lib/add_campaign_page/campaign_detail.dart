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

  const CampaignDetailPage({
    super.key,
    this.userId,
    this.categoryId,
    this.locationId,
  });

  @override
  CampaignDetailPageState createState() => CampaignDetailPageState(
        userId: userId,
        categoryId: categoryId,
        locationId: locationId,
      );
}

class CampaignDetailPageState extends State<CampaignDetailPage> {
  final String? userId;
  final int? categoryId;
  final int? locationId;
  CampaignDetailPageState({this.userId, this.categoryId, this.locationId});
  static List<AdvertisingStructure> campaignDetails =
      CampaignData().selectedStructures;
  List<DateTime> startDates = [];
  List<DateTime> endDates = [];

  @override
  void initState() {
    super.initState();
    startDates = List<DateTime>.filled(campaignDetails.length, DateTime.now());
    endDates = List<DateTime>.filled(campaignDetails.length, DateTime.now());
    _loadDatesFromPreferences();
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
          'startDate': startDates[i].toIso8601String(),
          'endDate': endDates[i].toIso8601String(),
          'campaignId': campaignId, // Include the campaign ID
        }),
      );

      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit quote for item $i')),
        );
        return;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quotes submitted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Campaign Detail"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User ID: ${userId ?? "No user ID"}',
            style: const TextStyle(fontSize: 18),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Selected Campaigns",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: campaignDetails.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Image.network(campaignDetails[index].imagePath),
                    ),
                    ListTile(
                      title: Text(campaignDetails[index].title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //     'Category ID: ${campaignDetails[index].categoryId}'),
                          // Text(
                          //     'Location ID: ${campaignDetails[index].locationId}'),
                          Text(campaignDetails[index].subtitle),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _removeCampaignDetail(index);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text("Start Date: "),
                              const SizedBox(width: 10),
                              TextButton(
                                onPressed: () {
                                  _selectStartDate(context, index);
                                },
                                child: Text(
                                  startDates[index].toString().split(' ')[0],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text("End Date: "),
                              const SizedBox(width: 10),
                              TextButton(
                                onPressed: () {
                                  _selectEndDate(context, index);
                                },
                                child: Text(
                                  endDates[index].toString().split(' ')[0],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _getQuote,
              child: const Text("Get Quote"),
            ),
          ),
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
}
