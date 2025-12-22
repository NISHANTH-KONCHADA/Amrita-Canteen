import 'dart:math';

class MLService {
  // 1️⃣ THE "TRAINING" DATA (Mocking past 30 days)
  // [Hour, IsRainy(1/0), IsExam(1/0), IsWeekend(1/0), ACTUAL_CROWD_COUNT]
  static final List<List<double>> _historicalData = [
    // Normal Days (12 PM)
    [12, 0, 0, 0, 45], [12, 0, 0, 0, 42], [12, 0, 0, 0, 48],
    // Rainy Days (Crowd increases because people stay inside)
    [12, 1, 0, 0, 65], [12, 1, 0, 0, 70],
    // Exam Days (Rush hour shifts or increases)
    [12, 0, 1, 0, 85], [12, 0, 1, 0, 80],
    // Morning Slots (8 AM)
    [8, 0, 0, 0, 15], [8, 1, 0, 0, 20],
    // Weekends (Less crowd)
    [12, 0, 0, 1, 10], [12, 1, 0, 1, 15],
  ];

  // 2️⃣ LEARNED WEIGHTS (The "Model")
  // We start with 0 and "learn" these values on init
  static double _baseWeight = 0;
  static double _rainWeight = 0;
  static double _examWeight = 0;
  static double _weekendWeight = 0;

  /// 🎓 TRAIN THE MODEL (Simple Linear Regression Logic)
  /// In a real app, this runs complex math. Here, we calculate averages.
  static void trainModel() {
    double sumRainImpact = 0;
    int rainCount = 0;
    
    double sumExamImpact = 0;
    int examCount = 0;

    double sumWeekendImpact = 0;
    int weekendCount = 0;

    double sumBase = 0;
    int baseCount = 0;

    for (var row in _historicalData) {
      double count = row[4]; // The label (Actual Crowd)
      bool isRain = row[1] == 1;
      bool isExam = row[2] == 1;
      bool isWeekend = row[3] == 1;

      // Simple Isolation Logic (Naive)
      if (!isRain && !isExam && !isWeekend) {
        sumBase += count;
        baseCount++;
      }
      if (isRain) {
        sumRainImpact += (count - 45); // Difference from base average
        rainCount++;
      }
      if (isExam) {
        sumExamImpact += (count - 45);
        examCount++;
      }
      if (isWeekend) {
        sumWeekendImpact += (count - 45); // Will likely be negative
        weekendCount++;
      }
    }

    // Set the Model Weights
    _baseWeight = baseCount > 0 ? sumBase / baseCount : 40;
    _rainWeight = rainCount > 0 ? sumRainImpact / rainCount : 15;
    _examWeight = examCount > 0 ? sumExamImpact / examCount : 30;
    _weekendWeight = weekendCount > 0 ? sumWeekendImpact / weekendCount : -30;

    print("🤖 AI MODEL TRAINED:");
    print("   Base Crowd: $_baseWeight");
    print("   Rain Effect: +$_rainWeight");
    print("   Exam Effect: +$_examWeight");
    print("   Weekend Effect: $_weekendWeight");
  }

  /// 🔮 PREDICT CROWD (Inference)
  /// Returns { "crowd": "High", "count": 55, "wait": 15 }
  static Map<String, dynamic> predict(int hour, bool isRain, bool isExam, bool isWeekend) {
    // Linear Regression Formula: Y = Base + (W1 * Rain) + (W2 * Exam) + ...
    
    double predictedCount = _baseWeight;

    // Time Factor (Hardcoded curve for simplicity as we didn't train 'hour' deeply)
    if (hour >= 12 && hour <= 14) predictedCount += 10; // Peak
    if (hour >= 8 && hour <= 10) predictedCount -= 20;  // Morning

    if (isRain) predictedCount += _rainWeight;
    if (isExam) predictedCount += _examWeight;
    if (isWeekend) predictedCount += _weekendWeight;

    // Clamp values to realistic bounds
    predictedCount = max(0, min(100, predictedCount));

    // Convert Count to Class labels
    String label = "Medium";
    int waitTime = 10;

    if (predictedCount > 60) {
      label = "High";
      waitTime = 20 + (predictedCount - 60).toInt(); // Dynamic Wait Time
    } else if (predictedCount < 25) {
      label = "Low";
      waitTime = 5;
    }

    return {
      "count": predictedCount.round(),
      "crowd": label,
      "wait": waitTime,
    };
  }
}