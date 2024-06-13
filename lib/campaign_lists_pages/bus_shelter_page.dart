// import 'package:flutter/material.dart';

// import 'package:mobile_login/add_campaign_page/campaign_detail.dart';
// import 'package:mobile_login/model/advertising_structure.dart'; // Import your model class

// import 'package:mobile_login/model/campaign_data.dart';

// class BusShelterPage extends StatelessWidget {
//   const BusShelterPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Bus Shelter"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add_shopping_cart),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const CampaignDetailPage(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: ListView(
//         children: [
//           _buildBusShelterBox(
//             context,
//             "Bus Shelter 1",
//             "Subtitle for Bus Shelter 1",
//             "assets/ahinsa.jpg",
//           ),
//           _buildBusShelterBox(
//             context,
//             "Bus Shelter 2",
//             "Subtitle for Bus Shelter 2",
//             "assets/ahinsa.jpg",
//           ),
//           // Add more bus shelter boxes as needed
//         ],
//       ),
//     );
//   }

//   Widget _buildBusShelterBox(
//       BuildContext context, String title, String subtitle, String imagePath) {
//     return GestureDetector(
//       onTap: () {},
//       child: Container(
//         margin: const EdgeInsets.all(10),
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: Colors.grey),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.asset(
//               imagePath,
//               width: double.infinity,
//               height: 200,
//               fit: BoxFit.cover,
//             ),
//             const SizedBox(height: 10),
//             Text(
//               title,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               subtitle,
//               style: const TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 CampaignData().selectedStructures.add(
//                       AdvertisingStructure(
//                         title: title,
//                         subtitle: subtitle,
//                         imagePath: imagePath,
//                       ),
//                     );
//               },
//               child: const Text("Add to Campaign"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
