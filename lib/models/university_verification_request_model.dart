class UniversityVerificationRequestModel {
  final String uid;
  final String university;
  final String studentCardImageUrl;
  final bool verified;
  final String universityVerificationStatus;
  final String? rejectionReason;

  UniversityVerificationRequestModel({
    required this.uid,
    required this.university,
    required this.studentCardImageUrl,
    required this.verified,
    required this.universityVerificationStatus,
    this.rejectionReason,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'university': university,
      'studentCardImageUrl': studentCardImageUrl,
      'verified': verified,
      'universityVerificationStatus': universityVerificationStatus,
      'rejectionReason': rejectionReason,
    };
  }

  factory UniversityVerificationRequestModel.fromMap(
      Map<String, dynamic> data) {
    return UniversityVerificationRequestModel(
      uid: data['uid'],
      university: data['university'],
      studentCardImageUrl: data['studentCardImageUrl'],
      verified: data['verified'],
      universityVerificationStatus: data['universityVerificationStatus'],
      rejectionReason: data['rejectionReason'],
    );
  }
}
