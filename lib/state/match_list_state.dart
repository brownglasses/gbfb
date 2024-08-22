import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gfbf/models/match_model.dart';

part 'match_list_state.freezed.dart';

@freezed
class MatchListState with _$MatchListState {
  const factory MatchListState.initial() = _Initial;
  const factory MatchListState.loading() = _Loading;
  const factory MatchListState.success(
          List<MatchModel> receivedMatches, List<MatchModel> sentMatcheds) =
      _Success;
  const factory MatchListState.error(String message) = _Error;
}
