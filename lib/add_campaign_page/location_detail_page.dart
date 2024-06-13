import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationDetailPage extends StatefulWidget {
  final int locationId;
  final String? userId;

  const LocationDetailPage({super.key, required this.locationId, this.userId});

  @override
  LocationDetailPageState createState() =>
      LocationDetailPageState(userId: userId);
}

class LocationDetailPageState extends State<LocationDetailPage> {
  final String? userId;
  LocationDetailPageState({this.userId});
  Map<String, dynamic>? _detail;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    final response = await http.get(Uri.parse(
        "http://192.168.29.202:8080/mobilelogin_api/details.php?location_id=${widget.locationId}"));

    if (response.statusCode == 200) {
      final List<dynamic> details = json.decode(response.body);
      if (details.isNotEmpty) {
        setState(() {
          _detail = details[0];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      throw Exception('Failed to load details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Center(child: Text("No more details"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_detail?['location_image'] != null)
                        Image.network(
                          _detail!['location_image'],
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      const SizedBox(height: 10),
                      _buildDetailRow("Country", _detail?['country']),
                      _buildDetailRow("State", _detail?['state']),
                      _buildDetailRow("City", _detail?['city']),
                      _buildDetailRow("Media", _detail?['media']),
                      _buildDetailRow("Height", _detail?['height']),
                      _buildDetailRow("Width", _detail?['width']),
                      _buildDetailRow("Area", _detail?['area']),
                      _buildDetailRow("Traffic From", _detail?['traffic_from']),
                      _buildDetailRow("Traffic To", _detail?['traffic_to']),
                      _buildDetailRow("Material", _detail?['material']),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Close"),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildDetailRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 100,
            child: Text(
              "$title:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value ?? 'N/A'),
          ),
        ],
      ),
    );
  }
}
