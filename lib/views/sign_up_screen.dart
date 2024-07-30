import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gfbf/provider.dart';

class SignUpScreen extends HookConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final genderController = useTextEditingController();
    final ageController = useTextEditingController();
    final phoneController = useTextEditingController();
    final codeController = useTextEditingController();
    final currentPage = useState(0);
    final verificationId = useState('');
    final codeSent = useState(false);
    final isLoading = useState(false);

    String formatPhoneNumber(String phoneNumber) {
      if (phoneNumber.startsWith('0')) {
        return '+82${phoneNumber.substring(1)}';
      }
      return phoneNumber;
    }

    Future<void> verifyPhoneNumber() async {
      isLoading.value = true;
      String formattedPhoneNumber = formatPhoneNumber(phoneController.text);

      await ref.read(signUpViewModelProvider.notifier).verifyPhoneNumber(
            phoneNumber: formattedPhoneNumber,
            codeSent: (id) {
              verificationId.value = id;
              codeSent.value = true;
              isLoading.value = false;
            },
            verificationFailed: (error) {
              isLoading.value = false;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Verification failed: $error')),
              );
            },
          );
    }

    Future<void> signInWithPhoneNumber() async {
      isLoading.value = true;
      try {
        await ref.read(signUpViewModelProvider.notifier).signInWithPhoneNumber(
              verificationId: verificationId.value,
              smsCode: codeController.text,
              age: ageController.text,
              gender: genderController.text,
            );

        if (context.mounted) {
          context.go('/university_verification');
        }
      } catch (e) {
        isLoading.value = false;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign-in failed: $e')),
          );
        }
      }
    }

    Future<void> nextPage() {
      currentPage.value++;
      return pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        leading: IconButton(
          onPressed: () {
            pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
            currentPage.value--;
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(), // 스와이프 비활성화
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '20대 대학생들의 친구 만들기 여사친남사친에 오신 것을 환영해요!',
                      ),
                      const Text('회원가입을 하고 친구를 만나보세요!'),
                      // Todo: Imoge
                      ElevatedButton(
                        onPressed: () {
                          nextPage();
                        },
                        child: const Text('회원가입'),
                      ),
                    ],
                  ),
                ),
              ),
              // Page 2: 남성 여성 선택
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: '성별'),
                      items: const [
                        DropdownMenuItem(value: 'male', child: Text('남성')),
                        DropdownMenuItem(value: 'female', child: Text('여성')),
                      ],
                      onChanged: (value) {
                        genderController.text = value!;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        nextPage();
                      },
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: ageController,
                      decoration: const InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        nextPage();
                      },
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!codeSent.value) ...[
                      TextField(
                        controller: phoneController,
                        decoration:
                            const InputDecoration(labelText: 'Phone number'),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: verifyPhoneNumber,
                        child: const Text('Verify Phone Number'),
                      ),
                    ] else ...[
                      TextField(
                        controller: codeController,
                        decoration: const InputDecoration(
                            labelText: 'Verification code'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: signInWithPhoneNumber,
                        child: const Text('Sign In'),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (isLoading.value)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
