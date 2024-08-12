import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gfbf/utils/colors.dart';
import 'package:gfbf/utils/widget.dart';
import 'package:gfbf/view_models/profile_create_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

class ProfileSetInformation extends StatefulHookConsumerWidget {
  const ProfileSetInformation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileSetInformationState();
}

class _ProfileSetInformationState extends ConsumerState<ProfileSetInformation> {
  @override
  Widget build(BuildContext context) {
    final heightController = useTextEditingController();
    final religionController =
        useState<String?>(null); // UseState to manage selected religion
    final smokingController = useState<bool>(false);
    final profileNotifer = ref.watch(createUserProfileProvider.notifier);

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('프로필 생성'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Column(children: [
            Expanded(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('프로필을 \n생성하세요', style: boldTextStyle(size: 30)),
                      16.height,
                      AppTextField(
                        controller: heightController,
                        textStyle: primaryTextStyle(color: black),
                        textFieldType: TextFieldType.NUMBER,
                        cursorColor: black,
                        decoration: buildInputDecoration(
                            hintColor: AppColors.textPrimary,
                            hintText: '키',
                            prefixIcon: const Icon(Icons.height_rounded,
                                color: AppColors.primary)),
                      ),
                      16.height,
                      DropdownButtonFormField<String>(
                        decoration: buildInputDecoration(
                            hintText: '종교',
                            hintColor: AppColors.textPrimary,
                            prefixIcon: const Icon(Icons.add,
                                color: AppColors.primary)),
                        value: religionController.value,
                        items: [
                          '무교',
                          '기독교',
                          '천주교',
                          '불교',
                          '기타',
                        ].map((religion) {
                          return DropdownMenuItem<String>(
                            value: religion,
                            child: Text(religion, style: primaryTextStyle()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          religionController.value = value;
                        },
                      ),
                      16.height,
                      const Text('흡연'),
                      16.height,
                      Row(
                        children: [
                          AppButton(
                            elevation: 0,
                            text: '흡연',
                            textStyle: boldTextStyle(color: Colors.white),
                            width: context.width() * 0.4,
                            color: smokingController.value
                                ? AppColors.primary
                                : AppColors.disabled,
                            onTap: () {
                              smokingController.value = true;
                            },
                          ).expand(),
                          8.width,
                          AppButton(
                            elevation: 0,
                            text: '비흡연',
                            textStyle: boldTextStyle(color: Colors.white),
                            width: context.width() * 0.4,
                            color: smokingController.value
                                ? AppColors.disabled
                                : AppColors.primary,
                            onTap: () {
                              smokingController.value = false;
                            },
                          ).expand(),
                        ],
                      ),
                      16.height,
                    ],
                  )),
            ),
            Expanded(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AppButton(
                    elevation: 0,
                    text: '다음',
                    textStyle: boldTextStyle(color: white),
                    width: context.width(),
                    color: AppColors.primary,
                    onTap: () {
                      profileNotifer.update(
                        (state) => state.copyWith(
                          height: heightController.text.toInt(),
                          religion: religionController.value,
                          smoking: smokingController.value,
                        ),
                      );
                      context
                          .go('/profile_set_information/profile_set_introduce');
                    },
                  ),
                ))
          ]),
        ),
      ),
    );
  }
}
