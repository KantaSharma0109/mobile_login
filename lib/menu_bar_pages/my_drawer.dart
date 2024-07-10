import 'package:flutter/material.dart';
import 'package:mobile_login/controllers/auth_service.dart';
import 'package:mobile_login/menu_bar_pages/profile_page.dart';
import 'package:mobile_login/pages/campaign_history_page.dart';
import 'package:mobile_login/pages/login_page.dart';

class MyDrawer extends StatelessWidget {
  final String? userId;
  final String? userName;

  const MyDrawer({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              margin: EdgeInsets.zero,
              decoration: const BoxDecoration(
                  // color: Colors.white,
                  ),
              accountName: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    userName ?? 'User Name',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              currentAccountPicture: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://img.freepik.com/free-photo/blue-user-icon-symbol-website-admin-social-login-element-concept-white-background-3d-rendering_56104-1217.jpg?w=1060&t=st=1719395095~exp=1719395695~hmac=7b5255aeb80442eaf7d164fd46e1ccef2d6e691e0f44610c804771368c1e2a09',
                    ),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
              accountEmail: null,
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
              onTap: () {
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
              leading: const Icon(Icons.history),
              title: const Text('Purchase History'),
              onTap: () {
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
              leading: const Icon(Icons.live_help_outlined),
              title: const Text('Help and Feedback'),
              onTap: () {
                // Navigator.pop(context); // Close the drawer
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => CampaignHistoryPage(userId: userId),
                //   ),
                // );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.star,
                color: Color.fromARGB(255, 201, 181, 1),
              ),
              title: const Text(
                'Rate Us',
                style: TextStyle(color: Color.fromARGB(255, 201, 181, 1)),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
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
    );
  }
}
