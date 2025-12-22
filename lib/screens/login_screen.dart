// import 'package:flutter/material.dart';
// import '../data/order_store.dart';
// import '../widgets/app_scaffold.dart';
// import 'profile_screen.dart';
// import 'staff_screen.dart';
// import 'admin_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {

//   @override
//   void initState() {
//     super.initState();
//     // Hide Overlay on Login Screen
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       OrderStore.overlayVisible.value = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       showLiveCount: false, // Internal flag, but handled globally now
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Color(0xFF8B0037), Color(0xFF5A0023)],
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(32),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.restaurant_menu_rounded,
//                     size: 80,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 const Text(
//                   "Smart Canteen",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   "Order smart, eat fresh.",
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.8),
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 60),

//                 _loginButton(context, "Student Login", Icons.school_outlined,
//                     () => _go(context, const ProfileScreen())),
//                 const SizedBox(height: 16),
//                 _loginButton(context, "Staff Login", Icons.badge_outlined,
//                     () => _go(context, const StaffScreen())),
//                 const SizedBox(height: 16),
//                 _textLink(context, "Admin Access", 
//                     () => _go(context, const AdminScreen())),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _loginButton(BuildContext context, String text, IconData icon, VoidCallback onTap) {
//     return ElevatedButton(
//       onPressed: onTap,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF8B0037),
//         minimumSize: const Size(double.infinity, 56),
//         elevation: 0,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 22),
//           const SizedBox(width: 12),
//           Text(text),
//         ],
//       ),
//     );
//   }

//   Widget _textLink(BuildContext context, String text, VoidCallback onTap) {
//     return TextButton(
//       onPressed: onTap,
//       style: TextButton.styleFrom(foregroundColor: Colors.white70),
//       child: Text(text),
//     );
//   }

//   void _go(BuildContext context, Widget w) {
//     // Re-enable Overlay when leaving Login
//     OrderStore.overlayVisible.value = true;
    
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => w),
//     );
//   }
// }






import 'package:flutter/material.dart';
import '../data/order_store.dart';
import '../widgets/app_scaffold.dart';
import 'profile_screen.dart';
import 'staff_screen.dart';
import 'admin_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    super.initState();
    // Hide Overlay on Login Screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      OrderStore.overlayVisible.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showLiveCount: false, 
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF8B0037), Color(0xFF5A0023)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🖼️ UPDATED: Custom App Logo
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  // If you haven't added the image yet, this will error. 
                  // Ensure assets/app_logo.png exists!
                  child: Image.asset(
                    'assets/app_logo.png', 
                    height: 80, 
                    width: 80,
                    //color: Colors.white, // Remove this line if your logo has its own colors!
                  ),
                ),
                
                const SizedBox(height: 24),
                const Text(
                  "Amrita Canteen",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Order smart, eat fresh.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 60),

                _loginButton(context, "Student Login", Icons.school_outlined,
                    () => _go(context, const ProfileScreen())),
                const SizedBox(height: 16),
                _loginButton(context, "Staff Login", Icons.badge_outlined,
                    () => _go(context, const StaffScreen())),
                const SizedBox(height: 16),
                _textLink(context, "Admin Access", 
                    () => _go(context, const AdminScreen())),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context, String text, IconData icon, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF8B0037),
        minimumSize: const Size(double.infinity, 56),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  Widget _textLink(BuildContext context, String text, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(foregroundColor: Colors.white70),
      child: Text(text),
    );
  }

  void _go(BuildContext context, Widget w) {
    OrderStore.overlayVisible.value = true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => w),
    );
  }
}