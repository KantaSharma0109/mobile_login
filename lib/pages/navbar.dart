// import 'package:flutter/material.dart';
// import 'package:mobile_login/add_campaign_page/campaign_detail.dart';
// import 'package:mobile_login/add_campaign_page/campaign_list.dart';
// import 'package:mobile_login/pages/home_page.dart';
// import 'package:mobile_login/pages/campaign_history_page.dart';
// import 'package:mobile_login/pages/shared_prefs_helper.dart';
// import 'package:mobile_login/payment/payment_page.dart';

// class NavbarPage extends StatefulWidget {
//   const NavbarPage({super.key});

//   @override
//   NavbarPageState createState() => NavbarPageState();
// }

// class NavbarPageState extends State<NavbarPage> {
//   int _selectedIndex = 0;
//   String? _userId;
//   String? _userName;

//   @override
//   void initState() {
//     super.initState();
//     // _loadUserId();
//     // _loadUserName();
//     _loadUserData();
//   }

//   // Future<void> _loadUserId() async {
//   //   String? userId = await SharedPrefsHelper.getUserId();
//   //   setState(() {
//   //     _userId = userId;
//   //   });
//   // }

//   // Future<void> _loadUserName() async {
//   //   String? userName = await SharedPrefsHelper.getUserName();
//   //   setState(() {
//   //     _userName = userName;
//   //   });
//   // }

//   Future<void> _loadUserData() async {
//     String? userId = await SharedPrefsHelper.getUserId();
//     String? userName = await SharedPrefsHelper.getUserName(); // Fetch user name
//     setState(() {
//       _userId = userId;
//       _userName = userName; // Set user name
//     });
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: _userId == null
//             ? const CircularProgressIndicator()
//             : _getSelectedPage(), // Pass user ID to pages if needed
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.category),
//             label: 'Categories',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.payment),
//             label: 'Payment',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: 'Cart',
//           ),
//           // BottomNavigationBarItem(
//           //   icon: Icon(Icons.history),
//           //   label: 'History',
//           // ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: const Color.fromARGB(255, 50, 69, 118),
//         onTap: _onItemTapped,
//       ),
//     );
//   }

//   Widget _getSelectedPage() {
//     switch (_selectedIndex) {
//       case 0:
//         return HomePage(userId: _userId, userName: _userName);
//       case 1:
//         return CampaignListPage(userId: _userId);

//       case 2:
//         return PaymentPage(
//           userId: _userId,
//           campaignId: null,
//           totalAmount: 0.0,
//           imageUrl: '',
//         );
//       case 3:
//         return CampaignDetailPage(userId: _userId);
//       case 4:
//         return CampaignHistoryPage(userId: _userId);

//       default:
//         return HomePage(userId: _userId);
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:mobile_login/add_campaign_page/campaign_detail.dart';
import 'package:mobile_login/add_campaign_page/city_list.dart';
import 'package:mobile_login/pages/home_page.dart';
import 'package:mobile_login/pages/campaign_history_page.dart';
import 'package:mobile_login/pages/shared_prefs_helper.dart';
import 'package:mobile_login/payment/payment_page.dart';
import 'package:mobile_login/menu_bar_pages/my_drawer.dart';
import 'package:mobile_login/menu_bar_pages/custom_drawer_scaffold.dart'; // Import CustomDrawerScaffold

class NavbarPage extends StatefulWidget {
  const NavbarPage({super.key});

  @override
  NavbarPageState createState() => NavbarPageState();
}

class NavbarPageState extends State<NavbarPage> {
  int _selectedIndex = 0;
  String? _userId;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String? userId = await SharedPrefsHelper.getUserId();
    String? userName = await SharedPrefsHelper.getUserName();
    setState(() {
      _userId = userId;
      _userName = userName;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return HomePage(userId: _userId, userName: _userName);
      case 1:
        return CityListPage(userId: _userId);
      case 2:
        return PaymentPage(
          userId: _userId,
          campaignId: null,
          totalAmount: 0.0,
          imageUrl: '',
        );
      case 3:
        return CampaignDetailPage(
          userId: _userId,
        );
      case 4:
        return CampaignHistoryPage(userId: _userId);
      default:
        return HomePage(userId: _userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomDrawerScaffold(
      drawer: MyDrawer(userId: _userId, userName: _userName),
      body: Center(
        child: _userId == null
            ? const CircularProgressIndicator()
            : _getSelectedPage(),
      ),
      selectedIndex: _selectedIndex,
      onItemTapped: _onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_city),
          label: 'City',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.payment),
          label: 'Payment',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
      ],
    );
  }
}
