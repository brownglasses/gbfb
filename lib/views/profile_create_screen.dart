import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gfbf/models/profile_model.dart';
import 'package:gfbf/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileCreateScreen extends HookConsumerWidget {
  const ProfileCreateScreen(
      {super.key, required this.university, required this.age});
  final String university;
  final String age;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(profileCreateViewModelProvider.notifier);
    final universityController = useTextEditingController(
      text: university,
    );
    final ageController = useTextEditingController(
      text: age,
    );
    final heightController = useTextEditingController();
    final aboutMeController = useTextEditingController();
    final interestsController = useTextEditingController();
    final religionController = useTextEditingController();
    final dislikesController = useTextEditingController();
    final likesController = useTextEditingController();
    final oneWordDescriptionController = useTextEditingController();
    final smokingController = useState<bool>(false);
    final ImagePicker picker = ImagePicker();

    final image = useState<File?>(null);

    void pickImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        image.value = File(pickedFile.path);
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Profile'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              GoRouter.of(context).go('/home');
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: universityController,
                    decoration: const InputDecoration(labelText: 'University'),
                    enabled: false,
                  ),
                  TextField(
                    controller: ageController,
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    enabled: false,
                  ),
                  TextField(
                    controller: heightController,
                    decoration: const InputDecoration(labelText: 'Height'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: aboutMeController,
                    decoration: const InputDecoration(labelText: 'About Me'),
                  ),
                  TextField(
                    controller: interestsController,
                    decoration: const InputDecoration(labelText: 'Interests'),
                  ),
                  TextField(
                    controller: religionController,
                    decoration: const InputDecoration(labelText: 'Religion'),
                  ),
                  TextField(
                    controller: dislikesController,
                    decoration: const InputDecoration(labelText: 'Dislikes'),
                  ),
                  TextField(
                    controller: likesController,
                    decoration: const InputDecoration(labelText: 'Likes'),
                  ),
                  TextField(
                    controller: oneWordDescriptionController,
                    decoration: const InputDecoration(
                        labelText: 'One Word Description'),
                  ),
                  SwitchListTile(
                    title: const Text('Smoking'),
                    value: smokingController.value,
                    onChanged: (bool value) {
                      smokingController.value = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: pickImage,
                    child: const Text('Pick Profile Image'),
                  ),
                  const SizedBox(height: 16),
                  image.value == null
                      ? const Text('No image selected.')
                      : Image.file(image.value!),
                  ElevatedButton(
                    onPressed: () async {
                      final profileModel = ProfileModel(
                        uid: '',
                        university: universityController.text,
                        age: int.parse(ageController.text),
                        height: int.parse(heightController.text),
                        photoUrl: '',
                        aboutMe: aboutMeController.text,
                        interests: interestsController.text,
                        smoking: smokingController.value,
                        religion: religionController.text,
                        dislikes: dislikesController.text,
                        likes: likesController.text,
                        oneWordDescription: oneWordDescriptionController.text,
                      );
                      await viewModel.createProfile(profileModel, image.value);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Profile created successfully')),
                        );
                      }
                    },
                    child: const Text('Create Profile'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
