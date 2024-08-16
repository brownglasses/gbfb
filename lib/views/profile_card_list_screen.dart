import 'package:flutter/material.dart';
import 'package:gfbf/components/profile_card_component.dart';
import 'package:gfbf/models/profile_card_model.dart';
import 'package:gfbf/models/profile_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileCardListScreen extends StatefulHookConsumerWidget {
  const ProfileCardListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileCardListScreenState();
}

class _ProfileCardListScreenState extends ConsumerState<ProfileCardListScreen> {
  List<ProfileModel> list = dummyProfiles;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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

List<ProfileModel> dummyProfiles = [
  ProfileModel(
    mbti: 'INTJ',
    body: '보통',
    uid: 'user001',
    university: '서울대',
    age: 24,
    height: 175,
    photoUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMQQrXxvhV8M3YZmUMfNATySfpbBWEvdlnFQ&s',
    bio: 'I love coding and hiking.',
    interests: 'Technology, Hiking, Books',
    smoking: false,
    religion: '무교',
    dislikes: 'Crowded places',
    likes: 'Nature, Silence',
  ),
  ProfileModel(
    mbti: 'ENFP',
    body: '마름',
    uid: 'user002',
    university: '연세대',
    age: 22,
    height: 165,
    photoUrl:
        'https://cdnweb01.wikitree.co.kr/webdata/editor/202307/12/img_20230712165316_124ebfe1.webp',
    bio: 'Adventurer and foodie.',
    interests: 'Traveling, Cooking, Music',
    smoking: false,
    religion: '기독교',
    dislikes: 'Boredom',
    likes: 'Food, Friends',
  ),
  ProfileModel(
    mbti: 'ISTP',
    body: '보통',
    uid: 'user003',
    university: '고려대',
    age: 26,
    height: 180,
    photoUrl:
        'https://cdn2.ppomppu.co.kr/zboard/data3/2023/0628/m_20230628214939_Kmzz4Qmd81.jpeg',
    bio: 'Gamer and tech enthusiast.',
    interests: 'Gaming, Technology, DIY',
    smoking: true,
    religion: '불교',
    dislikes: 'Rules',
    likes: 'Freedom, Creativity',
  ),
  ProfileModel(
    mbti: 'INFJ',
    body: '근육질',
    uid: 'user004',
    university: '카이스트',
    age: 21,
    height: 170,
    photoUrl:
        'https://img2.daumcdn.net/thumb/R658x0.q70/?fname=https://t1.daumcdn.net/news/202307/05/SpoChosun/20230705104720016iosn.jpg',
    bio: 'Passionate about psychology and art.',
    interests: 'Art, Psychology, Meditation',
    smoking: false,
    religion: '무교',
    dislikes: 'Noise',
    likes: 'Peace, Reflection',
  ),
  ProfileModel(
    mbti: 'ESTJ',
    body: 'Muscular',
    uid: 'user005',
    university: '한양대',
    age: 23,
    height: 178,
    photoUrl:
        'https://mblogthumb-phinf.pstatic.net/MjAyMzA2MjZfMjY4/MDAxNjg3Nzc2NTg0MzAy._bJuP4gI5NWKVDcEzIbtcm-wEHUu3oMpibBIHTx_Ws8g.0hQMfVpx5J36L6LB8WtBr0VImvsfQ4i2cNzugAH0ebkg.JPEG.chois909/IMG_2374.JPG?type=w800',
    bio: 'Leader and organizer.',
    interests: 'Management, Fitness, Strategy games',
    smoking: false,
    religion: '천주교',
    dislikes: 'Chaos',
    likes: 'Order, Efficiency',
  ),
];
