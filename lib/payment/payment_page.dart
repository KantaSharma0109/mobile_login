// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:mobile_login/payment/payments_summary.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:image_picker/image_picker.dart';

// class PaymentPage extends StatefulWidget {
//   final String? userId;
//   final String? campaignId;
//   final double totalAmount;

//   const PaymentPage({
//     super.key,
//     this.userId,
//     this.campaignId,
//     required this.totalAmount,
//     required String imageUrl,
//   });

//   @override
//   PaymentPageState createState() => PaymentPageState();
// }

// class PaymentPageState extends State<PaymentPage> {
//   File? _image;
//   final TextEditingController _amountController = TextEditingController();
//   final TextEditingController _referenceController = TextEditingController();
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _downloadImage(BuildContext context) async {
//     try {
//       const imageUrl =
//           'https://upload.wikimedia.org/wikipedia/commons/5/5b/Qrcode_wikipedia.jpg';
//       final response = await http.get(Uri.parse(imageUrl));
//       if (response.statusCode == 200) {
//         final directory = await getExternalStorageDirectory();
//         final filePath = '${directory!.path}/image.jpg';
//         File file = File(filePath);
//         await file.writeAsBytes(response.bodyBytes);

//         // Save image to gallery and trigger media scan
//         final result = await ImageGallerySaver.saveFile(filePath);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(result['isSuccess']
//                 ? 'Image downloaded and saved to gallery successfully'
//                 : 'Failed to save image to gallery'),
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       } else {
//         throw Exception('Failed to download image');
//       }
//     } catch (e) {
//       print('Error downloading image: $e');
//     }
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       }
//     });
//   }

//   Future<void> _uploadReceipt() async {
//     if (_image == null ||
//         _amountController.text.isEmpty ||
//         _referenceController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all fields')),
//       );
//       return;
//     }

//     final request = http.MultipartRequest(
//       'POST',
//       Uri.parse(
//           'http://192.168.29.202:8080/mobilelogin_api/upload_receipt.php'),
//     );

//     request.fields['userId'] = widget.userId!;
//     request.fields['campaignId'] = widget.campaignId!;
//     request.fields['amount'] = _amountController.text;
//     request.fields['referenceId'] = _referenceController.text;
//     request.files.add(
//       await http.MultipartFile.fromPath('receiptImage', _image!.path),
//     );

//     final response = await request.send();

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Receipt uploaded successfully')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to upload receipt')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // title: const Text('Payment Page'),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       PaymentsSummaryPage(userId: widget.userId!),
//                 ),
//               );
//             },
//             child: const Text('My Payments'),
//           ),
//         ],
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Text('User ID: ${widget.userId}'),
//                 // Text('Campaign ID: ${widget.campaignId}'),
//                 // Text('Total Amount: ₹${widget.totalAmount.toStringAsFixed(2)}'),
//                 // const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     _downloadImage(context);
//                   },
//                   child: const Text('Get QR Code for Payment'),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       onPressed: _pickImage,
//                       child: const Text('Upload Receipt Image'),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: TextField(
//                         controller: _amountController,
//                         decoration:
//                             const InputDecoration(labelText: 'Receipt Amount'),
//                         keyboardType: TextInputType.number,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _referenceController,
//                         decoration: const InputDecoration(
//                             labelText: 'Reference Number'),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 if (_image != null)
//                   Container(
//                     width: 100,
//                     height: 100,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                     ),
//                     child: Image.file(
//                       _image!,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _uploadReceipt,
//                   child: const Text('Submit Receipt'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:mobile_login/payment/payments_summary.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class PaymentPage extends StatefulWidget {
  final String? userId;
  final String? campaignId;
  final double totalAmount;

  const PaymentPage({
    super.key,
    this.userId,
    this.campaignId,
    required this.totalAmount,
    required String imageUrl,
  });

  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage> {
  File? _image;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<void> _downloadImage(BuildContext context) async {
    try {
      const imageUrl =
          'https://upload.wikimedia.org/wikipedia/commons/5/5b/Qrcode_wikipedia.jpg';
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final directory = await getExternalStorageDirectory();
        final filePath = '${directory!.path}/image.jpg';
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Save image to gallery and trigger media scan
        final result = await ImageGallerySaver.saveFile(filePath);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['isSuccess']
                ? 'Image downloaded and saved to gallery successfully'
                : 'Failed to save image to gallery'),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        throw Exception('Failed to download image');
      }
    } catch (e) {
      print('Error downloading image: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadReceipt() async {
    if (_image == null ||
        _amountController.text.isEmpty ||
        _referenceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'http://192.168.29.202:8080/mobilelogin_api/upload_receipt.php'),
    );

    request.fields['userId'] = widget.userId!;
    request.fields['campaignId'] = widget.campaignId!;
    request.fields['amount'] = _amountController.text;
    request.fields['referenceId'] = _referenceController.text;
    request.files.add(
      await http.MultipartFile.fromPath('receiptImage', _image!.path),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receipt uploaded successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload receipt')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Payment Page'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PaymentsSummaryPage(userId: widget.userId!),
                ),
              );
            },
            child: const Text('Payments History'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text('User ID: ${widget.userId}'),
              // Text('Campaign ID: ${widget.campaignId}'),
              // Text('Total Amount: ₹${widget.totalAmount.toStringAsFixed(2)}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _downloadImage(context);
                },
                child: const Text('Get QR Code for Payment'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Amount'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: _referenceController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Reference Number'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Upload Receipt Image'),
              ),
              if (_image != null)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadReceipt,
                child: const Text('Submit Receipt'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
