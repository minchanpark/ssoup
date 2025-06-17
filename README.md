# ssoup: 울릉도 스마트 여행 가이드 (Ulleungdo Smart Travel Guide)

`ssoup`는 울릉도를 방문하는 여행객들을 위한 올인원 모바일 애플리케이션입니다. 울릉도의 아름다운 관광 명소를 탐험하고, 환경 보호를 위한 플로깅(Plogging) 활동에 참여하며, 편리한 이동 수단 정보를 제공하여 사용자에게 최적의 여행 경험을 선사합니다.

## 프로젝트 시작 동기

울릉도는 아름다운 자연 경관을 자랑하지만, 관광객들이 접근하기에는 정보 부족과 이동의 불편함이 있었습니다. `ssoup`는 이러한 문제점을 해결하고, 더욱 많은 사람들이 울릉도를 쉽고 편리하게 여행할 수 있도록 돕기 위해 시작되었습니다. 특히, 최근 인기를 얻고 있는 플로깅 활동을 울릉도 여행에 접목하여 환경 보호에 기여하면서 특별한 추억을 만들 수 있도록 기획했습니다.

## 주요 기능

`ssoup`는 다음과 같은 핵심 기능을 제공합니다.

* **관광 명소 안내**: 울릉도 내 100곳 이상의 관광 명소에 대한 상세 정보(주소, 운영 시간, 연락처, 입장료, 설명, 이미지)를 제공합니다.
* **길 안내 서비스**: 현재 위치를 기반으로 관광 명소 및 쓰레기통 위치까지의 최적 경로를 지도에 표시하고 안내합니다.
* **플로깅 코스**: 울릉도 플로깅 코스를 추천하고, 플로깅 활동 인증을 통해 스탬프를 획득하고 선물을 받을 수 있는 기능을 제공합니다.
* **스탬프 획득 시스템**: 관광 명소 방문 또는 플로깅 코스 완주 시 스탬프를 획득하여 사용자의 참여를 독려합니다.
* **리뷰 기능**: 방문한 관광지나 플로깅 코스에 대한 리뷰와 사진을 공유할 수 있습니다.
* **교통 정보**: 울릉도 내 콜택시 및 독도 배편 예약 정보 링크를 제공합니다.
* **사용자 인증**: 이메일/비밀번호, 카카오, 구글 로그인을 지원하며, 닉네임 설정 및 회원 탈퇴 기능을 포함합니다.
* **개인정보 처리방침 및 서비스 이용약관**: 사용자의 개인정보 보호 및 서비스 이용에 대한 명확한 약관을 제공합니다.

## 프로젝트 구조

`ssoup` 프로젝트는 Flutter를 기반으로 개발되었으며, 다음과 같은 주요 디렉토리와 파일로 구성됩니다.

ssoup/
├── .gitignore
├── .vscode/
├── android/
├── ios/
├── lib/
│   ├── about_home/
│   ├── about_login/
│   ├── about_map/
│   ├── location/
│   ├── plogging/
│   ├── transport/
│   ├── theme/
│   ├── main.dart
│   ├── nick_name.dart
│   ├── splash.dart
│   └── stamp.dart
├── linux/
├── macos/
├── public/
├── web/
├── windows/
├── pubspec.yaml
├── analysis_options.yaml
└── README.md

## 기술 스택

* **Flutter**: 크로스 플랫폼 모바일 애플리케이션 개발 프레임워크
* **Firebase**:
    * **Firestore**: NoSQL 클라우드 데이터베이스 (관광지 정보, 플로깅 코스, 사용자 데이터, 리뷰 저장)
    * **Authentication**: 사용자 인증 (이메일/비밀번호, 구글, 카카오 로그인)
    * **Storage**: 사용자 리뷰 이미지 등 미디어 파일 저장
* **Google Maps SDK**: 지도 표시 및 위치 기반 서비스 제공
* **Naver Maps API (길 안내)**: 경로 탐색 및 길 안내 기능 구현에 활용
* **Kakao SDK**: 카카오 소셜 로그인 구현
* **Geolocator**: 사용자 위치 정보 획득
* **flutter_secure_storage**: 로그인 정보 등 민감한 데이터를 안전하게 저장

## 시작하기 (Getting Started)

이 프로젝트는 Flutter 애플리케이션의 시작점입니다. Flutter 개발에 대한 자세한 정보는 다음 자료를 참조하세요.

* [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
* [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

Flutter 개발을 시작하는 데 도움이 필요하면 [온라인 문서](https://docs.flutter.dev/)를 참조하세요. 튜토리얼, 샘플, 모바일 개발 지침 및 전체 API 참조를 제공합니다.

### 개발 환경 설정

1.  **Flutter SDK 설치**: [Flutter 공식 문서](https://flutter.dev/docs/get-started/install)를 참조하여 Flutter SDK를 설치합니다.
2.  **종속성 설치**: 프로젝트 루트 디렉토리에서 다음 명령어를 실행하여 필요한 Dart 패키지를 설치합니다.

    ```bash
    flutter pub get
    ```
3.  **Firebase 설정**:
    * Firebase 프로젝트를 생성하고, Android, iOS, Web 앱을 추가합니다.
    * `android/app/google-services.json` 파일을 다운로드하여 `android/app/` 디렉토리에 배치합니다.
    * `ios/Runner/GoogleService-Info.plist` 파일을 다운로드하여 `ios/Runner/` 디렉토리에 배치합니다.
    * `firebase.json` 파일에 Firebase 프로젝트 ID 및 앱 ID가 올바르게 구성되어 있는지 확인합니다.
4.  **Kakao SDK 설정**:
    * Kakao Developers에서 애플리케이션을 생성하고, 네이티브 앱 키와 JavaScript 앱 키를 발급받습니다.
    * `lib/constants.dart` 파일에 해당 키를 설정합니다. (constants.dart 파일이 제공되지 않았으므로 이 부분은 추정입니다.)
    * `android/app/src/main/res/values/string.xml` 파일에 `kakao_app_key`를 설정합니다.
    * `main.dart` 파일에서 `KakaoSdk.init`에 발급받은 키를 사용하도록 설정합니다.
5.  **Naver Maps API 설정**:
    * Naver Developers에서 지도 API 사용을 위한 Client ID와 Client Secret을 발급받습니다.
    * `lib/constants.dart` 파일에 해당 키를 설정합니다. (constants.dart 파일이 제공되지 않았으므로 이 부분은 추정입니다.)

### 애플리케이션 실행

다음 명령어를 사용하여 애플리케이션을 실행합니다.

```bash
flutter run
또는 특정 기기에서 실행:

Bash
flutter run -d <device_id>
라이선스
이 프로젝트는 별도의 라이선스 정보가 명시되어 있지 않습니다.
