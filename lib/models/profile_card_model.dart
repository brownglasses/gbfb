enum Region {
  Seoul,
  Incheon,
  Gyeonggi,
  Busan,
  Daegu,
  Daejeon,
  Gwangju,
  Ulsan,
  Sejong,
  Gangwon,
  Chungbuk,
  Chungnam,
  Jeonbuk,
  Jeonnam,
  Gyeongbuk,
  Gyeongnam,
  Jeju,
}

enum University {
  SeoulNationalUniversity,
  KoreaUniversity,
  YonseiUniversity,
  SogangUniversity,
  EwhaWomansUniversity,
  HanyangUniversity,
  KyungHeeUniversity,
  KAIST,
  POSTECH,
  SungkyunkwanUniversity,
  UNIST,
  HandongGlobalUniversity,
  KyungpookNationalUniversity,
  PusanNationalUniversity,
  ChonnamNationalUniversity,
  ChungnamNationalUniversity,
}

extension RegionExtension on Region {
  String get nameInKorean {
    switch (this) {
      case Region.Seoul:
        return "서울";
      case Region.Incheon:
        return "인천";
      case Region.Gyeonggi:
        return "경기";
      case Region.Busan:
        return "부산";
      case Region.Daegu:
        return "대구";
      case Region.Daejeon:
        return "대전";
      case Region.Gwangju:
        return "광주";
      case Region.Ulsan:
        return "울산";
      case Region.Sejong:
        return "세종";
      case Region.Gangwon:
        return "강원도";
      case Region.Chungbuk:
        return "충청북도";
      case Region.Chungnam:
        return "충청남도";
      case Region.Jeonbuk:
        return "전라북도";
      case Region.Jeonnam:
        return "전라남도";
      case Region.Gyeongbuk:
        return "경상북도";
      case Region.Gyeongnam:
        return "경상남도";
      case Region.Jeju:
        return "제주도";
      default:
        return "";
    }
  }
}

extension UniversityExtension on University {
  String get nameInKorean {
    switch (this) {
      case University.SeoulNationalUniversity:
        return "서울대학교";
      case University.KoreaUniversity:
        return "고려대학교";
      case University.YonseiUniversity:
        return "연세대학교";
      case University.SogangUniversity:
        return "서강대학교";
      case University.EwhaWomansUniversity:
        return "이화여자대학교";
      case University.HanyangUniversity:
        return "한양대학교";
      case University.KyungHeeUniversity:
        return "경희대학교";
      case University.KAIST:
        return "한국과학기술원";
      case University.POSTECH:
        return "포항공과대학교";
      case University.SungkyunkwanUniversity:
        return "성균관대학교";
      case University.UNIST:
        return "울산과학기술원";
      case University.HandongGlobalUniversity:
        return "한동대학교";
      case University.KyungpookNationalUniversity:
        return "경북대학교";
      case University.PusanNationalUniversity:
        return "부산대학교";
      case University.ChonnamNationalUniversity:
        return "전남대학교";
      case University.ChungnamNationalUniversity:
        return "충남대학교";
      default:
        return "";
    }
  }
}

enum BodyType {
  Chubby, // 통통
  Fit, // 탄탄
  Slim, // 마름
  Average, // 보통
}

extension BodyTypeExtension on BodyType {
  String get name {
    switch (this) {
      case BodyType.Chubby:
        return "통통";
      case BodyType.Fit:
        return "탄탄";
      case BodyType.Slim:
        return "마름";
      case BodyType.Average:
        return "보통";
    }
  }
}

class ProfileCardModel {
  final String uid; // 유저 아이디
  final int height; // 키
  final University university; // 대학교
  final Region region; // 사는 지역
  final int age; // 나이
  final BodyType bodyType; // 체형
  final String? imageUrl; // 프로필 이미지
  ProfileCardModel({
    required this.uid,
    required this.height,
    required this.university,
    required this.region,
    required this.age,
    required this.bodyType,
    this.imageUrl,
  });

  @override
  String toString() {
    return 'UserProfile(height: $height, university: ${university.nameInKorean}, region: ${region.nameInKorean}, age: $age, bodyType: ${bodyType.name})';
  }
}
