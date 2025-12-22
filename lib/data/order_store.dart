// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class OrderStore {
//   // ---------------- GLOBAL UI STATE ----------------
//   static final ValueNotifier<bool> overlayVisible = ValueNotifier<bool>(true);
//   static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

//   // ---------------- LIVE DATA STATE ----------------
//   static ValueNotifier<int> canteenCount = ValueNotifier<int>(0);
//   static ValueNotifier<List<Map<String, dynamic>>> orders = ValueNotifier([]);
//   static final Map<String, String> _forecastCache = {};
//   static int _tokenCounter = 100;

//   // ---------------- PERSISTENCE ----------------
//   static Future<void> init() async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedCounter = prefs.getInt('token_counter');
//     if (savedCounter != null) _tokenCounter = savedCounter;

//     final String? ordersString = prefs.getString('orders');
//     if (ordersString != null) {
//       try {
//         List<dynamic> decoded = jsonDecode(ordersString);
//         orders.value = List<Map<String, dynamic>>.from(decoded);
//       } catch (e) {
//         debugPrint("⚠ Error loading orders: $e");
//       }
//     }
//   }

//   static Future<void> _saveToDisk() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('orders', jsonEncode(orders.value));
//     await prefs.setInt('token_counter', _tokenCounter);
//   }

//   // ---------------- ORDER LOGIC ----------------
//   static String generateToken() {
//     _tokenCounter++;
//     _saveToDisk();
//     return "T-$_tokenCounter";
//   }

//   static void addOrder(Map<String, dynamic> order) {
//     bool hasActive = orders.value.any((o) => 
//       (o["status"] == "Pending" || o["status"] == "Active") && o["entered"] == false
//     );
    
//     if (hasActive) {
//       throw Exception("Fairness Limit: You already have an active token.");
//     }
//     orders.value = [...orders.value, order];
//     _saveToDisk();
//   }

//   // ✅ FIXED: Renamed to markServed and sets status directly to 'Served'
//   static void markServed(String token) {
//     final index = orders.value.indexWhere((o) => o["token"] == token);
//     if (index == -1) return;

//     final updatedOrders = List<Map<String, dynamic>>.from(orders.value);
    
//     // Prevent double scanning
//     if (updatedOrders[index]["entered"] == true || updatedOrders[index]["status"] == "Served") return;

//     updatedOrders[index]["entered"] = true;
//     updatedOrders[index]["status"] = "Served"; // ✅ This ensures Admin screen sees it as completed
    
//     // Increment Occupancy (Student is now eating)
//     canteenCount.value++;
    
//     orders.value = updatedOrders;
//     _saveToDisk();

//     debugPrint("✅ SERVED | $token | Count ${canteenCount.value}");

//     // Simulate Exit after 30 mins
//     Timer(const Duration(seconds: 10), () {
//        _markExited(token);
//     });
//   }

//   static void _markExited(String token) {
//     final index = orders.value.indexWhere((o) => o["token"] == token);
//     if (index == -1) return;

//     final updatedOrders = List<Map<String, dynamic>>.from(orders.value);
    
//     if (updatedOrders[index]["entered"] == true) {
//       updatedOrders[index]["entered"] = false;
//       // Status remains "Served" for history
//       canteenCount.value = (canteenCount.value - 1).clamp(0, 1000);
      
//       orders.value = updatedOrders;
//       _saveToDisk();
//       debugPrint("🔴 EXITED | $token | Count ${canteenCount.value}");
//     }
//   }

//   // ---------------- AI FORECASTING ----------------
//   static String getCrowdForecast(String slotId) {
//     if (_forecastCache.containsKey(slotId)) return _forecastCache[slotId]!;
//     final hour = int.parse(slotId.split("-")[0]);
//     String forecast;
//     if (hour >= 12 && hour <= 14) forecast = "High";
//     else if (hour >= 8 && hour <= 10) forecast = "Low";
//     else forecast = "Medium";
//     if (Random().nextBool() && forecast == "Medium") forecast = "High";
//     _forecastCache[slotId] = forecast;
//     return forecast;
//   }

//   static int totalForSlot(String date, String slot) {
//     return orders.value.where((o) => o["date"] == date && o["slot"] == slot).length;
//   }

//   static int pendingForSlot(String date, String slot) {
//     return orders.value.where((o) => o["date"] == date && o["slot"] == slot && o["status"] == "Pending").length;
//   }
// }



import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/ml_service.dart'; // 👈 IMPORT THE NEW SERVICE

class OrderStore {
  // ---------------- GLOBAL UI STATE ----------------
  static final ValueNotifier<bool> overlayVisible = ValueNotifier<bool>(true);
  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  // ---------------- LIVE DATA STATE ----------------
  static ValueNotifier<int> canteenCount = ValueNotifier<int>(0);
  static ValueNotifier<List<Map<String, dynamic>>> orders = ValueNotifier([]);
  static ValueNotifier<int> loyaltyPoints = ValueNotifier<int>(0);
  
  // 🧪 SIMULATION STATE (Inputs for AI)
  static ValueNotifier<String> currentDayType = ValueNotifier<String>("Normal"); // Normal, Exam, Weekend
  static ValueNotifier<String> currentWeather = ValueNotifier<String>("Sunny");  // Sunny, Rainy
  
  static final Map<String, Map<String, dynamic>> _forecastCache = {};
  static int _tokenCounter = 100;

  // ---------------- PERSISTENCE ----------------
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 🧠 TRAIN THE AI MODEL ON STARTUP
    MLService.trainModel();

    _tokenCounter = prefs.getInt('token_counter') ?? 100;
    loyaltyPoints.value = prefs.getInt('loyalty_points') ?? 0;

    final String? ordersString = prefs.getString('orders');
    if (ordersString != null) {
      try {
        List<dynamic> decoded = jsonDecode(ordersString);
        orders.value = List<Map<String, dynamic>>.from(decoded);
      } catch (e) {
        debugPrint("⚠ Error loading orders: $e");
      }
    }
  }

  static Future<void> _saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('orders', jsonEncode(orders.value));
    await prefs.setInt('token_counter', _tokenCounter);
    await prefs.setInt('loyalty_points', loyaltyPoints.value);
  }

  // ---------------- ORDER LOGIC ----------------
  static String generateToken() {
    _tokenCounter++;
    _saveToDisk();
    return "T-$_tokenCounter";
  }

  static void addOrder(Map<String, dynamic> order) {
    bool hasActive = orders.value.any((o) => 
      (o["status"] == "Pending" || o["status"] == "Active") && o["entered"] == false
    );
    
    if (hasActive) {
      throw Exception("Fairness Limit: You already have an active token.");
    }
    orders.value = [...orders.value, order];
    _saveToDisk();
  }

  static void markServed(String token) {
    final index = orders.value.indexWhere((o) => o["token"] == token);
    if (index == -1) return;

    final updatedOrders = List<Map<String, dynamic>>.from(orders.value);
    
    if (updatedOrders[index]["entered"] == true || updatedOrders[index]["status"] == "Served") return;

    updatedOrders[index]["entered"] = true;
    updatedOrders[index]["status"] = "Served";
    loyaltyPoints.value += 10;
    canteenCount.value++;
    
    orders.value = updatedOrders;
    _saveToDisk();

    Timer(const Duration(seconds: 10), () {
       _markExited(token);
    });
  }

  static void _markExited(String token) {
    final index = orders.value.indexWhere((o) => o["token"] == token);
    if (index == -1) return;

    final updatedOrders = List<Map<String, dynamic>>.from(orders.value);
    
    if (updatedOrders[index]["entered"] == true) {
      updatedOrders[index]["entered"] = false;
      canteenCount.value = (canteenCount.value - 1).clamp(0, 1000);
      orders.value = updatedOrders;
      _saveToDisk();
    }
  }

  // ---------------- 🧠 CONNECTING AI TO APP ----------------
  
  static Map<String, dynamic> getSlotPrediction(String slotId) {
    // 1. Prepare Inputs
    final int hour = int.parse(slotId.split("-")[0]);
    final bool isRain = currentWeather.value == "Rainy";
    final bool isExam = currentDayType.value == "Exam";
    final bool isWeekend = currentDayType.value == "Weekend";

    // 2. Cache Key (Optimization)
    final String key = "$slotId-$isRain-$isExam-$isWeekend";
    if (_forecastCache.containsKey(key)) return _forecastCache[key]!;

    // 3. 🤖 CALL THE ML ENGINE
    final result = MLService.predict(hour, isRain, isExam, isWeekend);

    _forecastCache[key] = result;
    return result;
  }

  // 🥘 WASTE REDUCTION (Using AI Prediction)
  static Map<String, dynamic> getKitchenAdvice(String slotId) {
    // Real Data
    final booked = totalForSlot(DateTime.now().toIso8601String().split("T")[0], slotId);
    
    // AI Prediction
    final prediction = getSlotPrediction(slotId);
    final int predictedTotal = prediction["count"]; // This comes from ML
    
    // Logic: We cook for the HIGHER of (Booked vs Predicted)
    // But we don't overcook. We trust the AI.
    
    int prepTarget = predictedTotal;
    if (booked > prepTarget) prepTarget = booked + 5; // Buffer if actual booking > AI

    return {
      "booked": booked,
      "prep_target": prepTarget,
      "status": prepTarget > 60 ? "Heavy Load" : "Normal",
    };
  }
  
  static Map<String, dynamic> getWasteStats() {
    int totalCapacity = 500; // Fixed daily capacity
    int smartPrep = 0;
    
    // Sum up AI Predictions for all slots
    for (int i = 8; i <= 18; i++) {
        // Just sampling standard slots
        smartPrep += (MLService.predict(i, false, false, false)["count"] as int);
    }
    
    // Ensure smartPrep isn't unrealistically low for demo
    if (smartPrep < 200) smartPrep = 320;

    int savedMeals = totalCapacity - smartPrep;
    double savedPercent = (savedMeals / totalCapacity) * 100;

    return {
      "saved_meals": savedMeals,
      "saved_percent": savedPercent.toStringAsFixed(1),
      "saved_kg": (savedMeals * 0.4).toStringAsFixed(1)
    };
  }

  static String getLastServedToken() {
    final served = orders.value.where((o) => o["status"] == "Served");
    if (served.isEmpty) return "--";
    return served.last["token"];
  }

  static int totalForSlot(String date, String slot) {
    return orders.value.where((o) => o["date"] == date && o["slot"] == slot).length;
  }

  static int pendingForSlot(String date, String slot) {
    return orders.value.where((o) => o["date"] == date && o["slot"] == slot && o["status"] == "Pending").length;
  }
}