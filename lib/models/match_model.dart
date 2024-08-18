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

  factory MatchModel.fromMap(Map<String, dynamic> map) {
    return MatchModel(
      fromUserId: map['fromUserId'],
      toUserId: map['toUserId'],
      status: map['status'],
      timestamp: map['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'status': status,
      'timestamp': timestamp,
    };
  }

  static List<MatchModel> fromList(List<dynamic> list) {
    return list.map((e) => MatchModel.fromMap(e)).toList();
  }
}
