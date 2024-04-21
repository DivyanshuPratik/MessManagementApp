import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tiny_alert/tiny_alert.dart';

class ScanQrPage extends StatefulWidget {
  const ScanQrPage({super.key}); 
  @override
  State<ScanQrPage> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  String? scannedData;
  bool dataSent = false;

  Future<void> sendQRData(String data) async {
    final url = Uri.parse('http://192.168.11.166:3000/api/test');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'scannedMess': data});
    print('trying to send data');
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (!mounted) return;
      if (response.statusCode == 200) {
        TinyAlert.success(
          context,
          title: "Success!",
          message: "Your mess has been verified successfully!",
        );
        print('data sent successfully');
      } else {
        TinyAlert.error(
          context,
          title: "Failure!",
          message: "Your mess verification has failed!",
        );
        print('Failed to send data: ${response.body}');
      }
    } catch (e) {
      print('Network error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
        ),
        onDetect: (capture) {
          if (!dataSent) {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              setState(() {
                scannedData = barcode.rawValue;
              });
              print('QR Code scanned: $scannedData');
              if (scannedData != null) {
                sendQRData(scannedData!);
                setState(() {
                  dataSent = true;
                });
                print('data sent successfully');
                break;
              }
            }
          }
        },
      ),
    );
  }
}
