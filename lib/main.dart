import 'package:flutter/material.dart';
import 'package:project_management_app/screens/Auth/first_screen.dart';
import 'package:project_management_app/services/setup.dart';
import 'package:sizer/sizer.dart';

void main() async {
  await setup();
  runApp(const MainApp()
  
      // DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) => const MainApp(), // Wrap your app
      // ),
      );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: FirstScreen(),
        );
      },
    );
  }
}
