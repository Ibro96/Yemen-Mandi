import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/app.dart';
import '../../../core/network/api_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('الحساب')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ref.read(apiServiceProvider).getProfile(),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final p = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CircleAvatar(radius: 32, child: Text((p['name'] as String).substring(0, 1))),
              const SizedBox(height: 8),
              Center(child: Text(p['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(height: 16),
              Card(child: ListTile(title: const Text('Email'), subtitle: Text(p['email'] as String))),
              Card(child: ListTile(title: const Text('Phone'), subtitle: Text(p['phone'] as String))),
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: ref.watch(themeModeProvider) == ThemeMode.dark,
                onChanged: (v) async {
                  ref.read(themeModeProvider.notifier).state = v ? ThemeMode.dark : ThemeMode.light;
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('dark_mode', v);
                },
              ),
              ListTile(
                title: const Text('اللغة العربية / English'),
                trailing: const Icon(Icons.language),
                onTap: () async {
                  final next = ref.read(localeProvider).languageCode == 'ar' ? const Locale('en') : const Locale('ar');
                  ref.read(localeProvider.notifier).state = next;
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('lang', next.languageCode);
                },
              )
            ],
          );
        },
      ),
    );
  }
}
