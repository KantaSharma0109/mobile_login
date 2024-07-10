// import 'package:flutter/material.dart';
// import 'package:mobile_login/controllers/auth_service.dart';
// import 'package:mobile_login/pages/login_page.dart';
// import 'package:mobile_login/pages/customer_page.dart';

// class HomePage extends StatelessWidget {
//   // const HomePage({super.key});

//   final String? userId;

//   const HomePage({super.key, this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("HomePage"),
//         automaticallyImplyLeading: false,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'User ID: ${userId ?? "No user ID"}', // Display the user ID
//               style: TextStyle(fontSize: 18),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             const Text("Welcome user to this app"),
//             const SizedBox(
//               height: 20,
//             ),
//             OutlinedButton(
//                 onPressed: () {
//                   AuthService.logout();
//                   Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const LoginPage()));
//                 },
//                 child: const Text("Logout")),
//             const SizedBox(
//               height: 20,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => CustomerPage(userId: userId)),
//                 );
//               },
//               child: const Text('Customer Page'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:mobile_login/pages/customer_page.dart';
// import 'package:mobile_login/home_page_ui/home_slider.dart';

// class HomePage extends StatelessWidget {
//   final String? userId;
//   final String? userName;

//   const HomePage({
//     super.key,
//     this.userId,
//     this.userName,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Welcome, ${userName ?? "No user Name"}',
//           style: const TextStyle(fontSize: 18),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const HomeSlider(),
//           const SizedBox(height: 20),
//           // Text(
//           //   'User ID: ${userId ?? "No user ID"}',
//           //   style: const TextStyle(fontSize: 18),
//           // ),
//           // const SizedBox(height: 20),
//           // const Text(
//           //   "Welcome user to this app",
//           //   textAlign: TextAlign.center,
//           // ),
//           const SizedBox(height: 20),
//           Center(
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CustomerPage(userId: userId),
//                   ),
//                 );
//               },
//               child: const Text('Customer Page'),
//             ),
//           ),

//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mobile_login/pages/customer_page.dart';
import 'package:mobile_login/home_page_ui/home_slider.dart';

class HomePage extends StatelessWidget {
  final String? userId;
  final String? userName;

  const HomePage({
    super.key,
    this.userId,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // Remove the gray line
        // backgroundColor: Colors.black,
        title: Text(
          'Welcome, ${userName ?? "No user Name"}',
          style: const TextStyle(fontSize: 18),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeSlider(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CustomerPage(userId: userId, initialTabIndex: 0),
                        ),
                      );
                    },
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Check Your\nOrders',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CustomerPage(userId: userId, initialTabIndex: 1),
                        ),
                      );
                    },
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Check Your Quotations',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
