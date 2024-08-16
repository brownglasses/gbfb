import 'package:flutter/material.dart';
import 'package:gfbf/models/profile_model.dart';
import 'package:gfbf/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class ProfileCard extends StatelessWidget {
  final ProfileModel profile;

  const ProfileCard({required this.profile, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
              child: profile.photoUrl != null
                  ? Image.network(
                      profile.photoUrl!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.person,
                      size: 100,
                    ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        profile.university!,
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        profile.age.toString(),
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                  16.height,
                  Row(
                    children: [
                      Text(
                        profile.height.toString(),
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        profile.body!,
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      label: Text(label),
      labelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 10.0, // 폰트 크기 작게 설정
      ),
      backgroundColor: Colors.white,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(
          horizontal: 0, vertical: 0), // 패딩 조정하여 크기 축소
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
