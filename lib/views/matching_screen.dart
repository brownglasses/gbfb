import 'package:flutter/material.dart';
import 'package:gfbf/models/match_model.dart';
import 'package:gfbf/models/profile_model.dart';
import 'package:gfbf/state/match_list_state.dart';
import 'package:gfbf/view_models/match_view_model.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class MatchingScreen extends StatefulHookConsumerWidget {
  const MatchingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends ConsumerState<MatchingScreen> {
  @override
  void initState() {
    super.initState();
    // 매칭 데이터를 불러오는 ViewModel의 fetchMatches 메서드를 호출하여 데이터 로딩을 시작합니다.
    Future.microtask(
        () => ref.read(matchListNotifierProvider.notifier).fetchMatches());
  }

  @override
  Widget build(BuildContext context) {
    // 현재 매칭 상태를 가져옵니다.
    final matchListState = ref.watch(matchListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 카드'),
      ),
      body: matchListState.when(
        initial: () => const Center(child: Text('초기화 중...')),
        loading: () => const Center(child: CircularProgressIndicator()),
        success: (receivedMatches, sentMatches) {
          return Column(
            children: [
              const Text('내가 보낸 신청'),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: sentMatches.length,
                  itemBuilder: (context, index) {
                    final match = sentMatches[index];
                    return ProfileCard(match: match);
                  },
                ),
              ),
              const Text('받은 신청'),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: receivedMatches.length,
                  itemBuilder: (context, index) {
                    final match = receivedMatches[index];
                    return ProfileCard(match: match);
                  },
                ),
              ),
            ],
          );
        },
        error: (message) => Center(child: Text('오류 발생: $message')),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final MatchModel match;

  const ProfileCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // 프로필 이미지 및 정보 표시 (예시로 간단한 텍스트 사용)
          Text('From: ${match.fromUserId}'),
          Text('To: ${match.toUserId}'),
          Text('Status: ${match.status}'),
        ],
      ),
    );
  }
}
