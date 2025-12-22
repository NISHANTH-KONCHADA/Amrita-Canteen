import 'package:flutter/material.dart';
import '../data/slot_data.dart';
import '../data/order_store.dart';

class CanteenHeatmap extends StatelessWidget {
  const CanteenHeatmap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Peak Hour Analysis", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Icon(Icons.bar_chart_rounded, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: SlotData.slots.map((slot) {
                // Get data for "today" (simple approximation for MVP)
                final today = DateTime.now().toIso8601String().split("T")[0];
                final count = OrderStore.totalForSlot(today, slot["id"]!);
                
                // Calculate height percentage (max capacity = 50 for demo)
                final double percentage = (count / SlotData.capacity).clamp(0.0, 1.0);
                
                // Color coding
                Color barColor = Colors.greenAccent;
                if (percentage > 0.5) barColor = Colors.orangeAccent;
                if (percentage > 0.8) barColor = Colors.redAccent;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("$count", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 12,
                      height: 10 + (100 * percentage), // Min height 10
                      decoration: BoxDecoration(
                        color: barColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Show only start hour (e.g., "12")
                    Text(
                      slot["id"]!.split("-")[0],
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}