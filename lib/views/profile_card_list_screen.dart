import 'package:flutter/material.dart';
import 'package:gfbf/models/profile_card_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileCardListScreen extends StatefulHookConsumerWidget {
  const ProfileCardListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileCardListScreenState();
}

class _ProfileCardListScreenState extends ConsumerState<ProfileCardListScreen> {
  List<ProfileCardModel> list = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    list.add(ProfileCardModel(
      uid: "1",
      age: 25,
      region: Region.Seoul,
      university: University.SeoulNationalUniversity,
      bodyType: BodyType.Fit,
      height: 180,
      imageUrl: null,
    ));
    list.add(ProfileCardModel(
      uid: "2",
      age: 22,
      region: Region.Busan,
      university: University.PusanNationalUniversity,
      bodyType: BodyType.Slim,
      height: 170,
      imageUrl: 'https://via.placeholder.com/150',
    ));
    list.add(ProfileCardModel(
      uid: "3",
      age: 23,
      region: Region.Daegu,
      university: University.KyungpookNationalUniversity,
      bodyType: BodyType.Average,
      height: 175,
      imageUrl: 'https://via.placeholder.com/150',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 카드 목록'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2개의 열로 배열
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.7, // 카드의 비율을 조정하여 카드가 더 세로로 길게 보이도록 설정
        ),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ProfileCard(profile: list[index]);
        },
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final ProfileCardModel profile;

  const ProfileCard({required this.profile, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
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
              child: profile.imageUrl != null
                  ? Image.network(
                      profile.imageUrl!,
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
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 0.0, // 태그 사이의 간격
              runSpacing: 0.0, // 줄 사이의 간격
              children: [
                _buildChip(profile.university.nameInKorean),
                _buildChip('${profile.height}cm'),
                _buildChip(profile.region.nameInKorean),
                _buildChip('${profile.age}세'),
                _buildChip(profile.bodyType.name),
              ],
            ),
          ),
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
