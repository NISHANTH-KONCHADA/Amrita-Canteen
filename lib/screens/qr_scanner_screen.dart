import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vibration/vibration.dart';
import '../data/order_store.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Token")),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (barcode) {
              if (scanned) return;

              final token = barcode.barcodes.first.rawValue;
              if (token == null) return;

              // Check if order exists
              final orderExists = OrderStore.orders.value.any((o) => o["token"] == token);
              if (!orderExists) return;

              setState(() {
                scanned = true;
              });

              // ✅ CALL THE CORRECT METHOD
              OrderStore.markServed(token);

              // Haptic Feedback
              if (Vibration.hasVibrator() != null) {
                Vibration.vibrate(duration: 150);
              }
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Order $token Marked as SERVED ✅"),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );

              Navigator.pop(context);
            },
          ),
          
          // Scanner Guide Overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 100,
                    spreadRadius: 100,
                  ),
                ],
              ),
            ),
          ),
          
          const Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Text(
              "Align QR code within the frame",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}