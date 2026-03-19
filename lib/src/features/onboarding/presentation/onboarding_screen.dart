import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delivery_dining, size: 90),
            const SizedBox(height: 20),
            const Text('أشهى وجبات المندي بسرعة', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            const Text('تجربة طلب سريعة، واجهة فاخرة، ودفع آمن.', textAlign: TextAlign.center),
            const SizedBox(height: 30),
            FilledButton(onPressed: () => context.go('/login'), child: const Text('ابدأ الآن')),
          ],
        ),
      ),
    );
  }
}
