import 'package:flutter/material.dart';
import '../data/menu_data.dart';
import 'cart_screen.dart';
import '../widgets/app_bar_with_back.dart';

class MenuScreen extends StatefulWidget {
  final String slot;
  final String date;

  const MenuScreen({super.key, required this.slot, required this.date});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Map<String, int> cart = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithBack(
        context,
        title: "Food Menu",
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B0037).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.slot,
                  style: const TextStyle(
                    color: Color(0xFF8B0037),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          final qty = cart[item["name"]] ?? 0;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Food Placeholder Image/Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.fastfood_rounded,
                      size: 32,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["name"],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item["category"],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "₹${item["price"]}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B0037),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Buttons
                  if (qty == 0)
                    ElevatedButton(
                      onPressed: () => setState(() => cart[item["name"]] = 1),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        minimumSize: const Size(0, 40),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text("ADD"),
                    )
                  else
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B0037),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          _iconBtn(Icons.remove, () {
                            setState(() {
                              if (qty == 1) cart.remove(item["name"]);
                              else cart[item["name"]] = qty - 1;
                            });
                          }),
                          Text(
                            "$qty",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _iconBtn(Icons.add, () {
                            setState(() => cart[item["name"]] = qty + 1);
                          }),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: cart.isNotEmpty ? FloatingActionButton.extended(
        backgroundColor: const Color(0xFF8B0037),
        icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
        label: Text("View Cart (${cart.length})", style: const TextStyle(color: Colors.white)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CartScreen(
                cart: cart,
                slot: widget.slot,
                date: widget.date,
              ),
            ),
          );
        },
      ) : null,
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: 18),
      onPressed: onTap,
      constraints: const BoxConstraints(minWidth: 32),
      padding: EdgeInsets.zero,
    );
  }
}