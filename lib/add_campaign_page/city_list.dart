// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:mobile_login/add_campaign_page/campaign_list.dart';

// class CityListPage extends StatefulWidget {
//   final String? userId;

//   const CityListPage({super.key, this.userId});

//   @override
//   CityListPageState createState() => CityListPageState();
// }

// class CityListPageState extends State<CityListPage> {
//   String? userId;
//   List<Map<String, dynamic>> _cities = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchCities();
//     userId = widget.userId;
//   }

//   Future<void> _fetchCities() async {
//     final response = await http.get(
//         Uri.parse("http://192.168.29.202:8080/mobilelogin_api/cities.php"));

//     if (response.statusCode == 200) {
//       List<dynamic> cities = json.decode(response.body);
//       setState(() {
//         _cities = cities
//             .map((city) => {
//                   'id': int.parse(city['id']), // Ensure id is an integer
//                   'city_name': city['city_name'],
//                 })
//             .toList();
//         _isLoading = false;
//       });
//     } else {
//       throw Exception('Failed to load cities');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text("Select City"),
//       // ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: _cities.length,
//               itemBuilder: (context, index) {
//                 final city = _cities[index];
//                 return ListTile(
//                   title: Text('${city['city_name']} '),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => CampaignListPage(
//                           userId: userId,
//                           cityId: city['id'],
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
import 'package:mobile_login/add_campaign_page/campaign_list.dart';

class CityListPage extends StatefulWidget {
  final String? userId;

  const CityListPage({super.key, this.userId});

  @override
  CityListPageState createState() => CityListPageState();
}

class CityListPageState extends State<CityListPage> {
  String? userId;
  List<Map<String, dynamic>> _cities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCities();
    userId = widget.userId;
  }

  Future<void> _fetchCities() async {
    final response = await http.get(
        Uri.parse("http://192.168.29.202:8080/mobilelogin_api/cities.php"));

    if (response.statusCode == 200) {
      List<dynamic> cities = json.decode(response.body);
      setState(() {
        _cities = cities
            .map((city) => {
                  'id': int.parse(city['id']), // Ensure id is an integer
                  'city_name': city['city_name'],
                })
            .toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load cities');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Select City"),
      // ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: ListView.builder(
                itemCount: _cities.length,
                itemBuilder: (context, index) {
                  final city = _cities[index];
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 0),
                      title: Text(
                        city['city_name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CampaignListPage(
                              userId: userId,
                              cityId: city['id'],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
