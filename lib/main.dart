import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:gfbf/utils/build_theme.dart';
import 'package:gfbf/utils/routes.dart';

// Logger 초기화
final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // App 시작 시 로그 출력
  logger.i("앱 시작");

  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  // Background 메시지 수신 시 로그 출력
  logger.i("백그라운드 메시지 수신 서비스 시작, \n 메시지 아이디 : ${message.messageId}");
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    // MyApp 빌드 시 로그 출력
    logger.i("앱 빌드 시작");

    return MaterialApp.router(
      title: 'Phone Auth',
      theme: buildTheme(),
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      builder: scrollBehaviour(),
    );
  }
}
