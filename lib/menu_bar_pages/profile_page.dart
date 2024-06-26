// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:mobile_login/model/user_profile.dart';

// class ProfilePage extends StatefulWidget {
//   final String? userId;

//   const ProfilePage({Key? key, this.userId}) : super(key: key);

//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   late Future<UserProfile> _profileFuture;

//   @override
//   void initState() {
//     super.initState();
//     _profileFuture = _fetchUserProfile();
//   }

//   Future<UserProfile> _fetchUserProfile() async {
//     final response = await http.get(
//       Uri.parse(
//         'http://192.168.29.202:8080/mobilelogin_api/fetch_user_profile.php?userId=${widget.userId}',
//       ),
//     );

//     if (response.statusCode == 200) {
//       return UserProfile.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Failed to load user profile');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       body: FutureBuilder<UserProfile>(
//         future: _profileFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             final userProfile = snapshot.data!;
//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Name: ${userProfile.name}'),
//                   SizedBox(height: 8),
//                   Text('Phone Number: ${userProfile.number}'),
//                   SizedBox(height: 8),
//                   Text('Email: ${userProfile.email}'),
//                   SizedBox(height: 8),
//                   Text('City: ${userProfile.city}'),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_login/model/user_profile.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;

  const ProfilePage({super.key, this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserProfile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _fetchUserProfile();
  }

  Future<UserProfile> _fetchUserProfile() async {
    final response = await http.get(
      Uri.parse(
        'http://192.168.29.202:8080/mobilelogin_api/fetch_user_profile.php?userId=${widget.userId}',
      ),
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        // backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<UserProfile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userProfile = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    // color: Colors.blueAccent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Welcome, ${userProfile.name}',
                        //   style: const TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 24.0,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // const SizedBox(height: 10),
                        // Text(
                        //   userProfile.email,
                        //   style: const TextStyle(
                        //     color: Colors.white70,
                        //     fontSize: 16.0,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        _buildProfileCard(
                            Icons.person, 'Name', userProfile.name),
                        const SizedBox(height: 16),
                        _buildProfileCard(
                            Icons.phone, 'Phone Number', userProfile.number),
                        const SizedBox(height: 16),
                        _buildProfileCard(
                            Icons.email, 'Email', userProfile.email),
                        const SizedBox(height: 16),
                        _buildProfileCard(
                            Icons.location_city, 'City', userProfile.city),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileCard(IconData icon, String label, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
