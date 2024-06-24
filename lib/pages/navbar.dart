import 'package:flutter/material.dart';
import 'package:mobile_login/add_campaign_page/campaign_detail.dart';
import 'package:mobile_login/add_campaign_page/campaign_list.dart';
import 'package:mobile_login/pages/home_page.dart';
import 'package:mobile_login/pages/campaign_history_page.dart';
import 'package:mobile_login/pages/shared_prefs_helper.dart';
import 'package:mobile_login/payment/payment_page.dart';

class NavbarPage extends StatefulWidget {
  const NavbarPage({super.key});

  @override
  NavbarPageState createState() => NavbarPageState();
}

class NavbarPageState extends State<NavbarPage> {
  int _selectedIndex = 0;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    String? userId = await SharedPrefsHelper.getUserId();
    setState(() {
      _userId = userId;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _userId == null
            ? const CircularProgressIndicator()
            : _getSelectedPage(), // Pass user ID to pages if needed
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 50, 69, 118),
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return HomePage(userId: _userId);
      case 1:
        return CampaignListPage(userId: _userId);
      case 2:
        return CampaignDetailPage(userId: _userId);
      case 3:
        return PaymentPage(
          userId: _userId,
          campaignId: null,
          totalAmount: 0.0,
          imageUrl: '',
        );
      case 4:
        return CampaignHistoryPage(userId: _userId);

      default:
        return HomePage(userId: _userId);
    }
  }
}
