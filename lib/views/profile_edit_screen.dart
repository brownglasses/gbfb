import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gfbf/models/profile_model.dart';
import 'package:gfbf/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditScreen extends HookConsumerWidget {
  const ProfileEditScreen({super.key, required this.profileModel});
  final ProfileModel profileModel;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(profileEditViewModelProvider.notifier);
    final universityController =
        useTextEditingController(text: profileModel.university);
    final ageController =
        useTextEditingController(text: profileModel.age.toString());
    final heightController =
        useTextEditingController(text: profileModel.height.toString());
    final aboutMeController =
        useTextEditingController(text: profileModel.aboutMe);
    final interestsController =
        useTextEditingController(text: profileModel.interests);
    final religionController =
        useTextEditingController(text: profileModel.religion);
    final dislikesController =
        useTextEditingController(text: profileModel.dislikes);
    final likesController = useTextEditingController(text: profileModel.likes);
    final oneWordDescriptionController =
        useTextEditingController(text: profileModel.oneWordDescription);
    final smokingController = useState<bool>(false);
    final ImagePicker picker = ImagePicker();
    final filePath = useState(profileModel.photoUrl);
    final init = useState(true);
    void pickImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        filePath.value = pickedFile.path;
        init.value = false;
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              GoRouter.of(context).go('/');
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
                  if (filePath.value != null && init.value == true)
                    Image.network(filePath.value!)
                  else if (filePath.value != null && init.value == false)
                    Image.file(File(filePath.value!))
                  else
                    const Text('No image available',
                        style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
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
                      await viewModel.editProfile(profileModel, filePath.value);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Profile created successfully')),
                        );
                        context.go('/');
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
