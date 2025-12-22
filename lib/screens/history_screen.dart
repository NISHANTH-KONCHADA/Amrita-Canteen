import 'package:flutter/material.dart';
import '../data/order_store.dart';
import 'token_screen.dart';
import '../widgets/app_bar_with_back.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithBack(context, title: "Order History"),
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: OrderStore.orders,
        builder: (context, orders, child) {
          
          if (orders.isEmpty) {
            return const Center(child: Text("No orders yet"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[orders.length - 1 - index];
              final isPending = order["status"] == "Pending";
              final isServed = order["status"] == "Served";

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: isPending ? () {
                    // RE-OPEN TOKEN
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TokenScreen(
                          token: order["token"],
                          date: order["date"],
                          slot: order["slot"],
                          items: order["items"],
                        ),
                      ),
                    );
                  } : null,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: isServed ? Colors.green : Colors.orange,
                              child: Icon(
                                isServed ? Icons.check : Icons.qr_code, 
                                color: Colors.white
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Token ${order["token"]}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text("${order["date"]} • Slot ${order["slot"]}"),
                                ],
                              ),
                            ),
                            if (isPending)
                              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                          ],
                        ),
                        
                        // Rating Button for Served Orders
                        if (isServed)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Thanks for rating!")));
                              },
                              icon: const Icon(Icons.star_outline, size: 18),
                              label: const Text("Rate Meal"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black87,
                                side: const BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}