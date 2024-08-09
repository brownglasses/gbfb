import 'package:flutter/material.dart';
import 'package:gfbf/models/profile_model.dart';
import 'package:gfbf/provider.dart';
import 'package:gfbf/notifier/user_notifier.dart';
import 'package:gfbf/test_ui/screen/DASplashScreen.dart';

import 'package:gfbf/views/home_screen.dart';
import 'package:gfbf/views/profile_create_screen.dart';
import 'package:gfbf/views/profile_edit_screen.dart';
import 'package:gfbf/views/profile_view_screen.dart';

import 'package:gfbf/views/sign_up_screen.dart';
import 'package:gfbf/views/splash_screen.dart';
import 'package:gfbf/views/university_verification_screen.dart';

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  UserNotifier userInfomer = ref.watch(userInfomerProvider);

  return GoRouter(
    refreshListenable: userInfomer,
    redirect: (context, state) {
      if (!userInfomer.isInitialized) {
        return '/splashscreen';
      }
      if (userInfomer.userModel == null) {
        return '/sign_up';
      } else if (userInfomer.userModel!.verified == false) {
        return '/university_verification';
      }

      return null;
    },
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/splashscreen',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: '/da_splash',
        builder: (BuildContext context, GoRouterState state) {
          return const DASplashScreen();
        },
      ),
      GoRoute(
        path: '/university_verification',
        builder: (context, state) => const UniversityVerificationScreen(),
      ),
      GoRoute(
        path: '/sign_up',
        builder: (BuildContext context, GoRouterState state) {
          return const SignUpScreen();
        },
      ),
      GoRoute(
          path: '/profile_create',
          builder: (BuildContext context, GoRouterState state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final university = extra['university'] as String? ?? 'Unknown';
            final age = extra['age'] as String? ?? 'Unknown';
            return ProfileCreateScreen(
              university: university,
              age: age,
            );
          }),
      GoRoute(
          path: '/profile_view',
          builder: (BuildContext context, GoRouterState state) {
            return const ProfileViewScreen();
          }),
      GoRoute(
          path: '/profile_edit',
          builder: (BuildContext context, GoRouterState state) {
            final extra = state.extra as ProfileModel;
            return ProfileEditScreen(
              profileModel: extra,
            );
          }),
    ],
  );
});
