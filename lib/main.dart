import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/order_store.dart';
import 'screens/login_screen.dart';
import 'widgets/live_canteen_counter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await OrderStore.init(); // Initialize Persistence
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8B0037);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amrita Canteen',
      navigatorObservers: [OrderStore.routeObserver], // Register Global Observer
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: const Color(0xFFC2185B),
          surface: Colors.white,
          background: const Color(0xFFF5F7FA),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          iconTheme: IconThemeData(color: Colors.black87),
        ),
      ),
      // 🔥 GLOBAL OVERLAY BUILDER
      builder: (context, child) {
        return Stack(
          children: [
            if (child != null) child,
            
            // The Floating Counter Widget
            ValueListenableBuilder<bool>(
              valueListenable: OrderStore.overlayVisible,
              builder: (context, visible, _) {
                if (!visible) return const SizedBox.shrink();
                return const LiveCanteenCounter();
              },
            ),
          ],
        );
      },
      home: const LoginScreen(),
    );
  }
}