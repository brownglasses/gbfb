class ProfileModel {
  String? uid;
  String? university;
  int? age;
  int? height;
  String? photoUrl;
  String? bio;
  String? interests;
  bool smoking = false;
  String? religion;
  String? dislikes;
  String? likes;

  ProfileModel({
    this.uid = '',
    this.university = '',
    this.age = 20,
    this.height = 160,
    this.photoUrl = '',
    this.bio = '',
    this.interests = '',
    this.smoking = false,
    this.religion = '무교',
    this.dislikes = '',
    this.likes = '',
  });

  ProfileModel copyWith({
    String? uid,
    String? university,
    int? age,
    int? height,
    String? photoUrl,
    String? bio,
    String? interests,
    bool? smoking,
    String? religion,
    String? dislikes,
    String? likes,
  }) {
    return ProfileModel(
      uid: uid ?? this.uid,
      university: university ?? this.university,
      age: age ?? this.age,
      height: height ?? this.height,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      smoking: smoking ?? this.smoking,
      religion: religion ?? this.religion,
      dislikes: dislikes ?? this.dislikes,
      likes: likes ?? this.likes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileModel &&
        other.uid == uid &&
        other.university == university &&
        other.age == age &&
        other.height == height &&
        other.photoUrl == photoUrl &&
        other.bio == bio &&
        other.interests == interests &&
        other.smoking == smoking &&
        other.religion == religion &&
        other.dislikes == dislikes &&
        other.likes == likes;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        university.hashCode ^
        age.hashCode ^
        height.hashCode ^
        photoUrl.hashCode ^
        bio.hashCode ^
        interests.hashCode ^
        smoking.hashCode ^
        religion.hashCode ^
        dislikes.hashCode ^
        likes.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'university': university,
      'age': age,
      'height': height,
      'photoUrl': photoUrl,
      'bio': bio,
      'interests': interests,
      'smoking': smoking,
      'religion': religion,
      'dislikes': dislikes,
      'likes': likes,
    };
  }

  factory ProfileModel.fromFirestore(Map<String, dynamic> firestoreData) {
    return ProfileModel(
      uid: firestoreData['uid'] ?? '',
      university: firestoreData['university'] ?? '',
      age: firestoreData['age'] ?? 20,
      height: firestoreData['height'] ?? 160,
      photoUrl: firestoreData['photoUrl'] ?? '',
      bio: firestoreData['bio'] ?? '',
      interests: firestoreData['interests'] ?? '',
      smoking: firestoreData['smoking'] ?? false,
      religion: firestoreData['religion'] ?? '무교',
      dislikes: firestoreData['dislikes'] ?? '',
      likes: firestoreData['likes'] ?? '',
    );
  }
}
