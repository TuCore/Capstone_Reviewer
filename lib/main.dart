import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/upload/presentation/upload_screen.dart';

void main() {
  runApp(const ProviderScope(child: CapstoneReviewerApp()));
}

class CapstoneReviewerApp extends StatelessWidget {
  const CapstoneReviewerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capstone Reviewer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const UploadScreen(),
    );
  }
}
