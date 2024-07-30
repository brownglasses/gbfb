import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gfbf/utils/constants/university_verification_status.dart';

class UserModel {
  final String uid;
  final String phoneNumber;
  final String age;
  final String gender;
  final String? fcmToken;
  final String? university;
  final String universityVerificationStatus =
      UniversityVerificationStatus.notSubmitted.name;
  final bool verified;
  final bool profile;

  UserModel(
      {required this.verified,
      required this.uid,
      required this.phoneNumber,
      required this.age,
      required this.gender,
      required this.fcmToken,
      required this.university,
      required this.profile});

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      profile: data['profile'],
      uid: data['uid'],
      phoneNumber: data['phoneNumber'],
      age: data['age'],
      gender: data['gender'],
      fcmToken: data['fcmToken'],
      university: data['university'],
      verified: data['verified'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'age': age,
      'gender': gender,
      'fcmToken': fcmToken,
      'university': university,
      'verified': verified,
      'profile': profile,
    };
  }

  //fromMap
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
        uid: data['uid'],
        phoneNumber: data['phoneNumber'],
        age: data['age'],
        verified: data['verified'],
        gender: data['gender'],
        fcmToken: data['fcmToken'],
        university: data['university'],
        profile: data['profile']);
  }

  UserModel copyWith(
      {String? uid,
      String? phoneNumber,
      String? age,
      String? gender,
      String? fcmToken,
      String? university,
      bool? verified,
      bool? profile}) {
    return UserModel(
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      fcmToken: fcmToken ?? this.fcmToken,
      university: university ?? this.university,
      verified: verified ?? this.verified,
      profile: profile ?? this.profile,
    );
  }

  UserModel copyWithUniversity(String university) {
    return copyWith(university: university);
  }
}
