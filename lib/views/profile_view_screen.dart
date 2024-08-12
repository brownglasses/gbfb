import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gfbf/models/profile_model.dart';
import 'package:gfbf/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileViewScreen extends HookConsumerWidget {
  const ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewViewModelProvider);

    useEffect(() {
      Future.microtask(
          () => ref.read(profileViewViewModelProvider.notifier).getMyProfile());
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
        title: const Text('My Profile'),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        loaded: (profile) => ProfileDetails(profile: profile),
        error: (message) => Center(child: Text('Error: $message')),
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  final ProfileModel profile;

  const ProfileDetails({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: <Widget>[
          Text('University: ${profile.university}',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Age: ${profile.age}', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Height: ${profile.height}',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('About Me: ${profile.bio}',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Interests: ${profile.interests}',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Smoking: ${profile.smoking ? 'Yes' : 'No'}',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Religion: ${profile.religion}',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Dislikes: ${profile.dislikes}',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Likes: ${profile.likes}', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          profile.photoUrl != null && profile.photoUrl!.isNotEmpty
              ? Image.network(profile.photoUrl!)
              : const Text('No image available',
                  style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
