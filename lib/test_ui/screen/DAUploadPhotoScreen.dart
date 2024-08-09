import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gfbf/test_ui/screen/DAIdealScreen.dart';
import 'package:gfbf/test_ui/utils/DAColors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:dotted_border/dotted_border.dart';

class DAUploadPhotoScreen extends StatefulWidget {
  const DAUploadPhotoScreen({super.key});

  @override
  DAUploadPhotoScreenState createState() => DAUploadPhotoScreenState();
}

class DAUploadPhotoScreenState extends State<DAUploadPhotoScreen> {
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          appBarWidget('Upload Photo', titleTextStyle: boldTextStyle(size: 25)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.height,
            Text('Upload your \nPhoto', style: boldTextStyle(size: 30)),
            16.height,
            Text('Add your best photos', style: primaryTextStyle()),
            16.height,
            _images.isNotEmpty
                ? Wrap(
                    alignment: WrapAlignment.center,
                    runSpacing: 16,
                    spacing: 16,
                    children: List.generate(
                      _images.length,
                      (index) {
                        XFile file = _images[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(file.path),
                            height: 200,
                            width: 155,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  )
                : uploadImage(),
            16.height,
            AppButton(
              width: context.width(),
              color: primaryColor,
              onTap: () {
                finish(context);
                const DAIdealScreen().launch(context);
              },
              text: 'Continue',
              textStyle: boldTextStyle(color: white),
            ),
          ],
        ).paddingOnly(left: 16, right: 16),
      ),
    );
  }

  uploadImage() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: List.generate(
        4,
        (index) {
          return DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(10),
            color: primaryColor,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: primaryColor.withOpacity(0.2),
              ),
              height: 200,
              width: context.width() * 0.5 - 24,
              child: IconButton(
                onPressed: () {
                  loadAssets();
                },
                icon: const Icon(Icons.add, color: primaryColor),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> loadAssets() async {
    try {
      final List<XFile> selectedImages = await _picker.pickMultiImage(
        maxWidth: 800, // 선택사항: 최대 너비 설정
        maxHeight: 800, // 선택사항: 최대 높이 설정
        imageQuality: 85, // 선택사항: 이미지 품질 설정
      );

      if (selectedImages.isNotEmpty) {
        setState(() {
          _images.addAll(selectedImages);
        });
      }
    } catch (e) {
      print('이미지 선택 오류: $e');
      // 오류 처리 또는 다이얼로그 표시
    }
  }
}
