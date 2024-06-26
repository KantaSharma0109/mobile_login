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

import 'package:flutter/material.dart';
import 'package:mobile_login/controllers/auth_service.dart';
import 'package:mobile_login/menu_bar_pages/profile_page.dart';
import 'package:mobile_login/pages/campaign_history_page.dart';
import 'package:mobile_login/pages/login_page.dart';
import 'package:mobile_login/pages/customer_page.dart';

class HomePage extends StatelessWidget {
  final String? userId;

  const HomePage({
    super.key,
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("HomePage"),
        automaticallyImplyLeading: false,
        elevation: 15.0, // Add shadow
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey,
            height: 1.0,
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                size: 50.0, // Increase the size of the hamburger icon
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('User Name'), // Replace with actual user name
              accountEmail: Text(userId ?? 'No user ID'), // Display user ID
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.network(
                    'https://img.freepik.com/free-photo/blue-user-icon-symbol-website-admin-social-login-element-concept-white-background-3d-rendering_56104-1217.jpg?w=1060&t=st=1719395095~exp=1719395695~hmac=7b5255aeb80442eaf7d164fd46e1ccef2d6e691e0f44610c804771368c1e2a09', // Replace with actual profile picture URL
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                // Navigate to profile page
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(userId: userId),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('History'),
              onTap: () {
                // Navigate to history page
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CampaignHistoryPage(userId: userId),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                AuthService.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'User ID: ${userId ?? "No user ID"}', // Display the user ID
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Welcome user to this app"),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerPage(userId: userId),
                  ),
                );
              },
              child: const Text('Customer Page'),
            ),
          ],
        ),
      ),
    );
  }
}
