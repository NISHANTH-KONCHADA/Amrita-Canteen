import 'package:flutter/material.dart';
import '../data/order_store.dart';
import 'qr_scanner_screen.dart';
import 'login_screen.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff Portal"),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QRScannerScreen()),
              );
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 🛡️ SECURITY TICKER (Prevents Screenshots)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.black87,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.2),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  onEnd: () => setState(() {}), // Loop animation
                  child: const Icon(Icons.verified_user, color: Colors.greenAccent, size: 16),
                ),
                const SizedBox(width: 8),
                const Text("LIVE SYSTEM ACTIVE  •  ", style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    final now = DateTime.now();
                    return Text(
                      "${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}:${now.second.toString().padLeft(2,'0')}",
                      style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ],
            ),
          ),
          
          Expanded(
            child: OrderStore.orders.value.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text("No active orders", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: OrderStore.orders.value.length,
                    itemBuilder: (context, index) {
                      final o = OrderStore.orders.value[index];
                      final isPending = o["status"] == "Pending";
                      final isServed = o["status"] == "Served";

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isPending ? Colors.orange.shade50 : (isServed ? Colors.green.shade50 : Colors.blue.shade50),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              o["token"].split('-').last,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isPending ? Colors.orange : (isServed ? Colors.green : Colors.blue),
                              ),
                            ),
                          ),
                          title: Text(
                            "Token ${o["token"]}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text("${o["date"]} • ${o["slot"]}"),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isPending ? Colors.orange : (isServed ? Colors.green : Colors.blue),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              o["status"],
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}