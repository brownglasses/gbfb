import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  final String fromUserId;
  final String toUserId;
  final String status;
  final Timestamp timestamp;

  MatchModel({
    required this.fromUserId,
    required this.toUserId,
    required this.status,
    required this.timestamp,
  });

  factory MatchModel.fromMap(Map<dynamic, dynamic> map) {
    return MatchModel(
      fromUserId: map['fromUserId'] as String,
      toUserId: map['toUserId'] as String,
      status: map['status'] as String,
      timestamp: _parseTimestamp(map['timestamp']),
    );
  }

  static Timestamp _parseTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp;
    } else if (timestamp is Map) {
      int seconds = timestamp['_seconds'] ?? 0; // null이면 기본값 0 사용
      int nanoseconds = timestamp['_nanoseconds'] ?? 0; // null이면 기본값 0 사용
      return Timestamp(seconds, nanoseconds);
    } else {
      throw ArgumentError('Invalid timestamp format: $timestamp');
    }
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'status': status,
      'timestamp': timestamp,
    };
  }

  static List<MatchModel> fromList(List<Map<String, dynamic>> list) {
    return list.map((e) => MatchModel.fromMap(e)).toList();
  }
}
