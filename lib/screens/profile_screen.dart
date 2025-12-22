// import 'package:flutter/material.dart';
// import '../data/order_store.dart';
// import 'slot_selection_screen.dart';
// import 'menu_screen.dart';
// import 'history_screen.dart';
// import 'login_screen.dart';
// import 'token_screen.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   String? selectedSlot;
//   String? selectedDate;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Amrita Canteen"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout_rounded),
//             onPressed: () {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (_) => const LoginScreen()),
//                 (_) => false,
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _profileHeader(),
//             const SizedBox(height: 24),
            
//             // 🔔 ACTIVE TICKET ALERT 🔔
//             ValueListenableBuilder<List<Map<String, dynamic>>>(
//               valueListenable: OrderStore.orders,
//               builder: (context, orders, _) {
//                 // Find any Pending order
//                 final activeOrders = orders.where((o) => o["status"] == "Pending");
                
//                 if (activeOrders.isEmpty) return const SizedBox.shrink();

//                 final activeOrder = activeOrders.last; // Get the most recent one

//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 24),
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(colors: [Color(0xFF8B0037), Color(0xFFC2185B)]),
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(color: const Color(0xFF8B0037).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5)),
//                     ],
//                   ),
//                   child: Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       onTap: () {
//                         // Open Token Viewer
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => TokenScreen(
//                               token: activeOrder["token"],
//                               date: activeOrder["date"],
//                               slot: activeOrder["slot"],
//                               items: activeOrder["items"],
//                             ),
//                           ),
//                         );
//                       },
//                       borderRadius: BorderRadius.circular(20),
//                       child: Padding(
//                         padding: const EdgeInsets.all(20),
//                         child: Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
//                               child: const Icon(Icons.qr_code_2, color: Colors.white, size: 30),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Text("View Active Ticket", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
//                                   const SizedBox(height: 4),
//                                   Text("Token ${activeOrder["token"]}", style: const TextStyle(color: Colors.white70)),
//                                 ],
//                               ),
//                             ),
//                             const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),

//             const Text(
//               "Actions",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 16),
//             _actionCard(
//               icon: Icons.calendar_month_rounded,
//               title: "Book a Slot",
//               subtitle: selectedSlot == null
//                   ? "Tap to select time"
//                   : "$selectedSlot • $selectedDate",
//               isActive: true,
//               isHighlight: selectedSlot == null,
//               onTap: () async {
//                 final result = await Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const SlotSelectionScreen()),
//                 );
//                 if (result != null) {
//                   setState(() {
//                     selectedSlot = result["slot"];
//                     selectedDate = result["date"];
//                   });
//                 }
//               },
//             ),
//             const SizedBox(height: 12),
//             _actionCard(
//               icon: Icons.restaurant_menu_rounded,
//               title: "View Menu",
//               subtitle: "Select food & order",
//               isActive: selectedSlot != null,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => MenuScreen(
//                       slot: selectedSlot!,
//                       date: selectedDate!,
//                     ),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 12),
//             _actionCard(
//               icon: Icons.history_rounded,
//               title: "Order History",
//               subtitle: "Track previous meals",
//               isActive: true,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const HistoryScreen()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _profileHeader() {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF8B0037).withOpacity(0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(4),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: const Color(0xFF8B0037), width: 2),
//             ),
//             child: const CircleAvatar(
//               radius: 32,
//               backgroundColor: Color(0xFF8B0037),
//               child: Icon(Icons.person, color: Colors.white, size: 32),
//             ),
//           ),
//           const SizedBox(width: 20),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "K Nishanth",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   "CB.SC.U4CSE23523",
//                   style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                 ),
//                 const SizedBox(height: 8),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF8B0037).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Text(
//                     "CSE • Hosteller",
//                     style: TextStyle(
//                       color: Color(0xFF8B0037),
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _actionCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required bool isActive,
//     VoidCallback? onTap,
//     bool isHighlight = false,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: isActive ? onTap : null,
//         borderRadius: BorderRadius.circular(20),
//         child: Opacity(
//           opacity: isActive ? 1.0 : 0.5,
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               border: isHighlight && isActive
//                   ? Border.all(color: const Color(0xFF8B0037), width: 1.5)
//                   : Border.all(color: Colors.transparent),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.03),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF5F7FA),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Icon(icon, color: const Color(0xFF8B0037), size: 24),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         subtitle,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../data/order_store.dart';
import 'slot_selection_screen.dart';
import 'menu_screen.dart';
import 'history_screen.dart';
import 'login_screen.dart';
import 'token_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? selectedSlot;
  String? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("myAmrita"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profileHeader(),
            const SizedBox(height: 20),

            // 📣 LIVE QUEUE TICKER 📣
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: OrderStore.orders,
              builder: (context, _, __) {
                final serving = OrderStore.getLastServedToken();
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle)),
                          const SizedBox(width: 10),
                          const Text("NOW SERVING", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Text("Token $serving", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            
            // 🎫 ACTIVE TICKET CARD
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: OrderStore.orders,
              builder: (context, orders, _) {
                final activeOrders = orders.where((o) => o["status"] == "Pending");
                if (activeOrders.isEmpty) return const SizedBox.shrink();
                final activeOrder = activeOrders.last;

                return Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF8B0037), Color(0xFFC2185B)]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: const Color(0xFF8B0037).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TokenScreen(
                        token: activeOrder["token"], date: activeOrder["date"], slot: activeOrder["slot"], items: activeOrder["items"],
                      ))),
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.qr_code_2, color: Colors.white, size: 30),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("View Active Ticket", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 4),
                                  Text("Token ${activeOrder["token"]}", style: const TextStyle(color: Colors.white70)),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const Text("Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _actionCard(Icons.calendar_month_rounded, "Book a Slot", "Predict crowd & book", true, () async {
                final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const SlotSelectionScreen()));
                if (result != null) setState(() { selectedSlot = result["slot"]; selectedDate = result["date"]; });
            }),
            const SizedBox(height: 12),
            _actionCard(Icons.restaurant_menu_rounded, "View Menu", "Select food & order", selectedSlot != null, 
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => MenuScreen(slot: selectedSlot!, date: selectedDate!)))),
            const SizedBox(height: 12),
            _actionCard(Icons.history_rounded, "Order History", "Track previous meals", true, 
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()))),
          ],
        ),
      ),
    );
  }

  Widget _profileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: const Color(0xFF8B0037).withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF8B0037), width: 2)),
            child: const CircleAvatar(radius: 32, backgroundColor: Color(0xFF8B0037), child: Icon(Icons.person, color: Colors.white, size: 32)),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Nishanth Naidu", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("CB.EN.U4CSE21XXX", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionCard(IconData icon, String title, String subtitle, bool isActive, VoidCallback? onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isActive ? onTap : null, borderRadius: BorderRadius.circular(20),
        child: Opacity(
          opacity: isActive ? 1.0 : 0.5,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(16)),
                  child: Icon(icon, color: const Color(0xFF8B0037), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                ])),
                Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}