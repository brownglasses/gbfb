import 'package:flutter/material.dart';
import 'package:gfbf/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends StatefulHookConsumerWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userInfomerProvider).userModel;
    final profile = ref.watch(profileNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
            onPressed: () {
              context.go('/profile_create', extra: {
                'university': user!.university,
                'age': user.age.toString()
              });
            },
            child: const Text('Create & Edit Profile  '),
          ),
          ElevatedButton(
              onPressed: () {
                context.go('/profile_view');
              },
              child: const Text('view Profile')),
          ElevatedButton(
              onPressed: () {
                context.go('/profile_edit', extra: profile);
              },
              child: const Text('Edit Profile')),
          ElevatedButton(
              onPressed: () {
                context.go('/da_splash');
              },
              child: const Text('DA Splash Screen')),
          ElevatedButton(
              onPressed: () {
                context.go('/profile_card_list');
              },
              child: const Text('Profile Card List')),
          ElevatedButton(
              onPressed: () {
                context.go('/profile_set_information');
              },
              child: const Text('profile_set_information'))
        ]),
      ),
    );
  }
}
