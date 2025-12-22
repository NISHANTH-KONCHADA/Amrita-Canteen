import 'package:flutter/material.dart';
import '../data/order_store.dart';
import 'login_screen.dart';
import '../widgets/canteen_heatmap.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    final wasteStats = OrderStore.getWasteStats();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () => 
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false)),
        ],
      ),
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: OrderStore.orders,
        builder: (context, orders, child) {
          final total = orders.length;
          final served = orders.where((o) => o["status"] == "Served").length;
          final pending = total - served;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🧪 SIMULATION CONTROLS (For Demo)
                const Text("🧪 Demo Simulation Controls", style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _simToggle("Exam Mode", OrderStore.currentDayType, "Normal", "Exam"),
                    const SizedBox(width: 12),
                    _simToggle("Rainy Day", OrderStore.currentWeather, "Sunny", "Rainy"),
                  ],
                ),
                const SizedBox(height: 24),

                // 📊 WASTE REDUCTION (Core Value)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.green.shade700, Colors.green.shade500]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.eco, color: Colors.white, size: 40),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Waste Prevented", style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text("${wasteStats['saved_percent']}%", style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              Text("(${wasteStats['saved_kg']} kg)", style: const TextStyle(color: Colors.white, fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Live Occupancy
                ValueListenableBuilder<int>(
                  valueListenable: OrderStore.canteenCount,
                  builder: (context, count, _) => _statCard("Live Occupancy", "$count", Icons.groups, const Color(0xFF8B0037), Colors.white),
                ),
                const SizedBox(height: 20),

                const CanteenHeatmap(),
                const SizedBox(height: 24),

                const Text("Stats", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _statCard("Total", "$total", Icons.receipt_long, Colors.white, Colors.black)),
                    const SizedBox(width: 12),
                    Expanded(child: _statCard("Pending", "$pending", Icons.timer, Colors.orange.shade50, Colors.orange)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _simToggle(String label, ValueNotifier<String> notifier, String offVal, String onVal) {
    return Expanded(
      child: ValueListenableBuilder<String>(
        valueListenable: notifier,
        builder: (context, val, _) {
          final isOn = val == onVal;
          return GestureDetector(
            onTap: () => notifier.value = isOn ? offVal : onVal,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isOn ? Colors.blueAccent : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isOn ? Colors.blueAccent : Colors.grey.shade300),
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(color: isOn ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color bg, Color contentColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [if (bg == Colors.white) const BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: contentColor, size: 28),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: contentColor)),
          Text(label, style: TextStyle(fontSize: 14, color: contentColor.withOpacity(0.8))),
        ],
      ),
    );
  }
}