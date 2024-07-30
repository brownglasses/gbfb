import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gfbf/models/university_verification_request_model.dart';
import 'package:gfbf/provider.dart';
import 'package:gfbf/utils/constants/university_verification_status.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

class UniversityVerificationScreen extends StatefulHookConsumerWidget {
  const UniversityVerificationScreen({super.key});

  @override
  UniversityVerificationScreenState createState() =>
      UniversityVerificationScreenState();
}

class UniversityVerificationScreenState
    extends ConsumerState<UniversityVerificationScreen> {
  @override
  void initState() {
    super.initState();
    final uid = ref.read(firebaseAuthProvider).currentUser?.uid;
    if (uid != null) {
      ref
          .read(universityVerificationViewModelProvider.notifier)
          .getUniversityVerificationRequestResult(uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(universityVerificationViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('University Verification'),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        pending: (universityVerificationRequest) => const Center(
          child: Text('Your request is pending approval.'),
        ),
        approved: () {
          Future.microtask(() => context.go('/home'));
          return const Center(child: Text('Your request has been approved!'));
        },
        rejected: (universityVerificationRequest) => const Center(
          child: Text('Your request has been rejected.'),
        ),
        notSubmitted: () => const UniversityVerificationForm(),
        error: (message) => Center(child: Text('Error: $message')),
      ),
    );
  }
}

class UniversityVerificationForm extends HookConsumerWidget {
  const UniversityVerificationForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final universityController = useTextEditingController();
    final studentCardImage = useState<File?>(null);
    final isLoading = useState(false);
    final viewModel =
        ref.read(universityVerificationViewModelProvider.notifier);

    Future<void> pickImage() async {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        studentCardImage.value = File(pickedFile.path);
      }
    }

    Future<void> submitVerificationRequest() async {
      if ((formKey.currentState?.validate() ?? false) &&
          studentCardImage.value != null) {
        formKey.currentState?.save();
        final user = ref.watch(firebaseAuthProvider).currentUser;
        if (user != null) {
          isLoading.value = true;
          try {
            final imageUrl =
                await viewModel.uploadImage(user.uid, studentCardImage.value!);
            final verificationRequest = UniversityVerificationRequestModel(
              uid: user.uid,
              university: universityController.text,
              studentCardImageUrl: imageUrl,
              verified: false,
              universityVerificationStatus:
                  UniversityVerificationStatus.notSubmitted.name,
            );
            await viewModel.requestUniversityVerification(verificationRequest);
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Failed to submit verification request: $e')),
              );
            }
          } finally {
            isLoading.value = false;
          }
        }
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: universityController,
                decoration: const InputDecoration(labelText: 'University'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your university';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              studentCardImage.value == null
                  ? TextButton.icon(
                      icon: const Icon(Icons.image),
                      label: const Text('Upload Student Card Image'),
                      onPressed: pickImage,
                    )
                  : Image.file(
                      studentCardImage.value!,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading.value ? null : submitVerificationRequest,
                child: isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text('Submit Verification Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
