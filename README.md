# Amrita Canteen
# 🍽️ Smart Cafeteria Management System

## 📌 Project Title
Smart Cafeteria Management System using Flutter & Firebase

---

## 📖 Abstract
The Smart Cafeteria Management System is a digital platform designed to improve cafeteria operations by introducing token-based food distribution, meal slot booking, and demand analytics. The system aims to reduce waiting time, minimize food waste, ensure fairness, and improve the overall student experience through automation and data-driven insights.

---

## 🎯 Objectives
- Reduce food wastage
- Optimize cafeteria crowd management
- Enable fair token-based food serving
- Improve user experience for students
- Provide analytics for cafeteria administrators

---

## 🧠 Problem Statement
Traditional cafeteria systems suffer from long queues, food wastage, uneven food distribution, and lack of transparency. There is no efficient way to predict demand or manage crowd flow. This project solves these issues using a smart, digital approach.

---

## 🚀 Features

### Student/User Module
- User registration & login
- Meal slot booking
- Digital token generation
- View token status
- Queue waiting time display

### Admin/Cafeteria Module
- Token verification
- Live queue monitoring
- Demand analytics
- Historical data insights
- Waste reduction planning

---

## 🔄 Token Workflow
1. User logs in
2. User books a meal slot
3. System generates a unique token
4. Token is verified at the counter
5. Food is served
6. Token expires after use

---

## 🛠️ Tech Stack

### Frontend
- Flutter (Android / iOS / Web)

### Backend
- Firebase Authentication
- Cloud Firestore
- Firebase Cloud Functions (optional)

### Media Storage
- Cloudinary

### Optional Technologies
- NFC-based student ID
- AI/ML demand forecasting

---

## 🧩 System Architecture

```text
[ Flutter App ]
       |
       v
[ Firebase Authentication ]
       |
       v
[ Firestore Database ]
       |
       v
[ Admin Dashboard / Token Verification ]
```
⚙️ How to Run the Project
```
git clone https://github.com/your-username/smart-cafeteria.git
cd smart-cafeteria
flutter pub get
flutter run
```
