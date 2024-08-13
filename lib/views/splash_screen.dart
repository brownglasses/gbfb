import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gfbf/provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNotifier = ref.watch(userNotifierProvider);
    final profileNotifier = ref.watch(profileNotifierProvider.notifier);
    useEffect(() {
      Future.microtask(() async {
        await userNotifier.toInitAppFetchUser();
        await profileNotifier.fetchProfileData();
      });
      return null;
    }, []);

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Splash Screen'),
          ],
        ),
      ),
    );
  }
}
