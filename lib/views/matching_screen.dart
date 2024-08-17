//stfulhookconsumerWidget
import 'package:flutter/material.dart';
import 'package:gfbf/models/profile_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MatchingScreen extends StatefulHookConsumerWidget {
  const MatchingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends ConsumerState<MatchingScreen> {
  //내가 보낸 신청
  final List<ProfileModel> myRequest = [];
  //받은 신청
  final List<ProfileModel> receivedRequest = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  fetchData() {
    //myRequest 에 데이터 추가

    //receivedRequest 에 데이터 추가
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 카드'),
      ),
      body: const Column(children: [
        Text('내가 보낸 신청'),
        //grid view 로 프로필 카드를 보여줌

        Text('받은 신청'),
        //grid view 로 프로필 카드를 보여줌
      ]),
    );
  }
}
