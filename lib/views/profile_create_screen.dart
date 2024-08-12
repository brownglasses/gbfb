// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:gfbf/utils/colors.dart';
// import 'package:gfbf/utils/widget.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:gfbf/models/profile_model.dart';
// import 'package:gfbf/provider.dart';
// import 'package:go_router/go_router.dart';

// class ProfileCreateScreen extends HookConsumerWidget {
//   const ProfileCreateScreen({
//     super.key,
//     required this.university,
//     required this.age,
//   });

//   final String university;
//   final String age;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final viewModel = ref.watch(profileCreateViewModelProvider.notifier);
//     final heightController = useTextEditingController();
//     final religionController = useTextEditingController();
//     final aboutMeController = useTextEditingController();
//     final likesController = useTextEditingController();
//     final dislikesController = useTextEditingController();
//     final oneWordDescriptionController = useTextEditingController();
//     final smokingController = useState<bool>(false);
//     final ImagePicker picker = ImagePicker();
//     final image = useState<File?>(null);
//     final pageController = usePageController();
//     final currentPage = useState(0);

//     void pickImage() async {
//       final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         image.value = File(pickedFile.path);
//       }
//     }

//     void nextPage() {
//       if (currentPage.value < 3) {
//         currentPage.value++;
//         pageController.nextPage(
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//         );
//       }
//     }

//     void previousPage() {
//       if (currentPage.value > 0) {
//         currentPage.value--;
//         pageController.previousPage(
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//         );
//       }
//     }

//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('프로필 생성'),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () {
//               GoRouter.of(context).go('/home');
//             },
//           ),
//         ),
//         body: PageView(
//           controller: pageController,
//           onPageChanged: (int index) {
//             currentPage.value = index;
//           },
//           children: [
//             // 첫 번째 페이지: 키, 흡연, 종교
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text('프로필을 \n생성하세요', style: boldTextStyle(size: 30)),
//                   16.height,
//                   AppTextField(
//                     controller: heightController,
//                     textStyle: primaryTextStyle(color: black),
//                     textFieldType: TextFieldType.NUMBER,
//                     cursorColor: white,
//                     decoration: buildInputDecoration('키',
//                         prefixIcon: const Icon(Icons.height_rounded,
//                             color: AppColors.primary)),
//                   ),
//                   16.height,
//                   AppTextField(
//                     controller: religionController,
//                     textStyle: primaryTextStyle(color: black),
//                     textFieldType: TextFieldType.NAME,
//                     decoration: buildInputDecoration(
//                         hintText: '종교',
//                         prefixIcon: const Icon(Icons.add_circle_outline,
//                             color: AppColors.primary)),
//                   ),
//                   16.height,
//                   Row(
//                     children: [
//                       const Text('Smoking'),
//                       8.width,
//                       Switch(
//                         value: smokingController.value,
//                         onChanged: (bool value) {
//                           smokingController.value = value;
//                         },
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//                   AppButton(
//                     text: 'Next',
//                     onTap: nextPage,
//                   ),
//                 ],
//               ),
//             ),
//             // 두 번째 페이지: 저는 이런 사람이에요
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   AppTextField(
//                     controller: aboutMeController,
//                     textFieldType: TextFieldType.MULTILINE,
//                     decoration: const InputDecoration(labelText: 'About Me'),
//                   ),
//                   const Spacer(),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       AppButton(
//                         text: 'Previous',
//                         onTap: previousPage,
//                       ),
//                       AppButton(
//                         text: 'Next',
//                         onTap: nextPage,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             // 세 번째 페이지: 이런 분을 만나고 싶어요, 이런 분은 싫어요
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   AppTextField(
//                     controller: likesController,
//                     textFieldType: TextFieldType.MULTILINE,
//                     decoration: const InputDecoration(
//                         labelText: 'I Like People Who...'),
//                   ),
//                   16.height,
//                   AppTextField(
//                     controller: dislikesController,
//                     textFieldType: TextFieldType.MULTILINE,
//                     decoration: const InputDecoration(
//                         labelText: 'I Dislike People Who...'),
//                   ),
//                   const Spacer(),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       AppButton(
//                         text: 'Previous',
//                         onTap: previousPage,
//                       ),
//                       AppButton(
//                         text: 'Next',
//                         onTap: nextPage,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             // 네 번째 페이지: 사진 한 장으로 표현하면?
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     '사진 한 장으로 표현하면?',
//                     style: boldTextStyle(size: 16),
//                   ),
//                   8.height,
//                   Text(
//                     '얼굴 사진이 아닌 자신을 표현하는 아무 사진이나 괜찮아요',
//                     style: secondaryTextStyle(size: 12),
//                   ),
//                   16.height,
//                   AppButton(
//                     text: 'Pick Profile Image',
//                     onTap: pickImage,
//                   ),
//                   16.height,
//                   image.value == null
//                       ? const Text('No image selected.')
//                       : Image.file(image.value!),
//                   const Spacer(),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       AppButton(
//                         text: 'Previous',
//                         onTap: previousPage,
//                       ),
//                       AppButton(
//                         text: 'Create Profile',
//                         onTap: () async {
//                           final profileModel = ProfileModel(
//                             uid: '',
//                             university: university,
//                             age: int.parse(age),
//                             height: int.parse(heightController.text),
//                             bio: aboutMeController.text,
//                             interests: likesController.text,
//                             smoking: smokingController.value,
//                             religion: religionController.text,
//                             dislikes: dislikesController.text,
//                             likes: likesController.text,
//                           );
//                           await viewModel.createProfile(
//                               profileModel, image.value);
//                           if (context.mounted) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                   content:
//                                       Text('Profile created successfully')),
//                             );
//                             GoRouter.of(context).go('/home');
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
