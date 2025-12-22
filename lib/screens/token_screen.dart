import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../data/order_store.dart';

class TokenScreen extends StatefulWidget {
  final String token;
  final String date;
  final String slot;
  final Map<String, dynamic> items;

  const TokenScreen({
    super.key,
    required this.token,
    required this.date,
    required this.slot,
    required this.items, // Accept dynamic map to be safe
  });

  @override
  State<TokenScreen> createState() => _TokenScreenState();
}

class _TokenScreenState extends State<TokenScreen> {
  @override
  void initState() {
    super.initState();
    // Hide Global Overlay so QR is scannable
    WidgetsBinding.instance.addPostFrameCallback((_) {
      OrderStore.overlayVisible.value = false;
    });
  }

  @override
  void dispose() {
    // Show Overlay again when leaving
    OrderStore.overlayVisible.value = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wait = OrderStore.pendingForSlot(widget.date, widget.slot) * 2;

    return Scaffold(
      backgroundColor: const Color(0xFF8B0037),
      appBar: AppBar(
        title: const Text("Digital Token"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ticket Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.qr_code_2, color: Color(0xFF8B0037)),
                      SizedBox(width: 8),
                      Text("Scan at Counter", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                const Text("TOKEN NUMBER", style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1.5)),
                Text(
                  widget.token,
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF8B0037),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                QrImageView(
                  data: widget.token,
                  size: 200,
                  foregroundColor: const Color(0xFF8B0037),
                ),
                
                const SizedBox(height: 24),
                
                _detailRow("Date", widget.date),
                _detailRow("Time Slot", widget.slot),
                _detailRow("Est. Wait", "$wait mins"),
                
                const SizedBox(height: 10),
                const Divider(),
                
                // Item List Summary
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: widget.items.entries.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.key, style: const TextStyle(fontSize: 12)),
                          Text("x${e.value}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    )).toList(),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}