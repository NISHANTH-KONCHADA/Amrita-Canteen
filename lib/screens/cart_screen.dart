import 'package:flutter/material.dart';
import '../data/menu_data.dart';
import '../data/order_store.dart';
import '../data/slot_data.dart';
import 'token_screen.dart';
import '../widgets/app_bar_with_back.dart';

class CartScreen extends StatelessWidget {
  final Map<String, int> cart;
  final String date;
  final String slot;

  const CartScreen({
    super.key,
    required this.cart,
    required this.date,
    required this.slot,
  });

  int total() {
    int sum = 0;
    for (var item in menuItems) {
      if (cart.containsKey(item["name"])) {
        sum += (item["price"] as int) * cart[item["name"]]!;
      }
    }
    return sum;
  }

  void _confirmOrder(BuildContext context) {
    try {
      // 1. GENERATE TOKEN
      final newToken = OrderStore.generateToken();

      // 2. CREATE ORDER IN STORE
      OrderStore.addOrder({
        "token": newToken,
        "date": date,
        "slot": slot,
        "status": "Pending",
        "entered": false,
        "items": cart,
      });

      // 3. NAVIGATE TO VIEW TOKEN
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TokenScreen(
            token: newToken,
            date: date,
            slot: slot,
            items: cart,
          ),
        ),
      );
    } catch (e) {
      // Fairness Check Failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final booked = OrderStore.totalForSlot(date, slot);
    final isFull = booked >= SlotData.capacity;

    return Scaffold(
      appBar: appBarWithBack(context, title: "My Cart"),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: cart.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final name = cart.keys.elementAt(index);
                final qty = cart[name]!;
                final item = menuItems.firstWhere((e) => e["name"] == name);
                final price = item["price"] as int;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B0037).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${qty}x",
                          style: const TextStyle(
                            color: Color(0xFF8B0037),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("₹$price", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                          ],
                        ),
                      ),
                      Text("₹${price * qty}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Bill Details
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Amount", style: TextStyle(fontSize: 16, color: Colors.grey)),
                      Text("₹${total()}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF8B0037))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isFull ? null : () => _confirmOrder(context),
                      child: const Text("Confirm & Pay"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}