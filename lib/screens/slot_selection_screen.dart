import 'package:flutter/material.dart';
import '../data/slot_data.dart';
import '../data/order_store.dart';
import '../widgets/app_bar_with_back.dart';

class SlotSelectionScreen extends StatefulWidget {
  const SlotSelectionScreen({super.key});

  @override
  State<SlotSelectionScreen> createState() => _SlotSelectionScreenState();
}

class _SlotSelectionScreenState extends State<SlotSelectionScreen> {
  DateTime selectedDate = DateTime.now();
  String? selectedSlotId;

  @override
  Widget build(BuildContext context) {
    final dateStr = selectedDate.toIso8601String().split("T")[0];

    return Scaffold(
      appBar: appBarWithBack(context, title: "Select Meal Slot"),
      body: Column(
        children: [
          // Date & Context Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Date Picker
                InkWell(
                  onTap: () async { /* Date Picker Logic */ },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Planning for", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text(dateStr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Icon(Icons.calendar_month, color: Color(0xFF8B0037)),
                    ],
                  ),
                ),
                const Divider(height: 20),
                // AI Context Indicators
                Row(
                  children: [
                    _contextBadge(
                      OrderStore.currentDayType.value == "Exam" ? Icons.school : Icons.calendar_today,
                      OrderStore.currentDayType.value,
                      OrderStore.currentDayType.value == "Exam" ? Colors.red : Colors.green,
                    ),
                    const SizedBox(width: 8),
                    _contextBadge(
                      OrderStore.currentWeather.value == "Rainy" ? Icons.umbrella : Icons.wb_sunny,
                      OrderStore.currentWeather.value,
                      OrderStore.currentWeather.value == "Rainy" ? Colors.blue : Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2, // Taller for info
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: SlotData.slots.length,
              itemBuilder: (context, index) {
                final slot = SlotData.slots[index];
                final count = OrderStore.totalForSlot(dateStr, slot["id"]!);
                final isFull = count >= SlotData.capacity;
                final isSelected = selectedSlotId == slot["id"];
                
                // 🤖 GET AI PREDICTION
                final prediction = OrderStore.getSlotPrediction(slot["id"]!);
                final crowd = prediction["crowd"];
                final wait = prediction["wait"];
                
                Color statusColor = Colors.green;
                if (crowd == "Medium") statusColor = Colors.orange;
                if (crowd == "High") statusColor = Colors.red;

                return GestureDetector(
                  onTap: isFull ? null : () => setState(() => selectedSlotId = slot["id"]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF8B0037) : (isFull ? Colors.grey.shade100 : Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF8B0037) : Colors.transparent, width: 2
                      ),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          slot["label"]!.replaceAll(" - ", "\n"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected ? Colors.white : (isFull ? Colors.grey : Colors.black87),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        if (!isFull) ...[
                          // Crowd Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                            child: Text(
                              "$crowd Crowd",
                              style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Wait Time
                          Text(
                            "Est. Wait: ${wait}m",
                            style: TextStyle(fontSize: 11, color: isSelected ? Colors.white70 : Colors.grey[600]),
                          ),
                        ] else
                          const Text("FULL", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
               width: double.infinity,
               child: ElevatedButton(
                 onPressed: selectedSlotId == null ? null : () {
                   Navigator.pop(context, {"slot": selectedSlotId, "date": dateStr});
                 },
                 child: const Text("Confirm Slot"),
               ),
            ),
          )
        ],
      ),
    );
  }

  Widget _contextBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}