import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/employee_model.dart';
import 'services/auth_service.dart';
import 'screens/main_layout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. ส่งค่า DefaultFirebaseOptions เข้าไป
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ระบบสต็อกสินค้า',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      home: StreamBuilder<EmployeeModel?>(
        stream: AuthService().currentEmployee,
        builder: (context, snapshot) {
          // กำลังโหลดข้อมูลจาก Firebase
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('กำลังเชื่อมต่อฐานข้อมูล...'),
                  ],
                ),
              ),
            );
          }

          // ถ้าล็อกอินสำเร็จ และมีข้อมูลพนักงานใน Firestore
          if (snapshot.hasData && snapshot.data != null) {
            return MainLayoutScreen(employee: snapshot.data!);
          }

          // ถ้ายังไม่ได้ล็อกอิน หรือไม่มีข้อมูล ให้แสดงหน้า UI ให้เห็นชัดเจน
          return Scaffold(
            body: Center(
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock_outline, size: 64, color: Colors.blue),
                    const SizedBox(height: 16),
                    const Text(
                      'กรุณาล็อกอินเข้าสู่ระบบ',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text('โปรดใช้หน้า Login เพื่อเข้าใช้งานระบบจัดการสต็อก'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}