import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'firebase_options.dart';
import 'providers/theme_provider.dart';
import 'providers/subscription_provider.dart';
import 'providers/language_provider.dart';
import 'providers/currency_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'utils/page_transitions.dart';
import 'services/app_version_service.dart';
import 'widgets/update_dialog.dart';

// GlobalKey for navigation
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  // Firebase 초기화
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // 앱 버전 체크 서비스 초기화
    await AppVersionService().initialize();
    print('Firebase 초기화 완료');
  } catch (e) {
    print('Firebase 초기화 실패: $e');
  }

  // AdMob 초기화
  try {
    final initializationStatus = await MobileAds.instance.initialize();
    print('AdMob 초기화 완료: ${initializationStatus.adapterStatuses}');
  } catch (e) {
    print('AdMob 초기화 실패: $e');
  }

  runApp(const MyApp());
}

class NoStretchScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // iOS에서 광고 추적 권한 요청
    _requestTrackingPermission();

    // 앱 버전 체크 (앱 시작 후)
    _checkAppVersion();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// iOS 광고 추적 권한 요청
  Future<void> _requestTrackingPermission() async {
    if (!Platform.isIOS) return;

    // 앱이 완전히 활성화될 때까지 대기
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      print('ATT 현재 상태: $status');

      // 아직 권한을 요청하지 않았다면 요청
      if (status == TrackingStatus.notDetermined) {
        print('ATT 권한 팝업 표시 중...');
        final result =
            await AppTrackingTransparency.requestTrackingAuthorization();
        print('ATT 권한 결과: $result');
      }
    } catch (e) {
      print('ATT 권한 요청 오류: $e');
    }
  }

  /// 앱 버전 체크 및 업데이트 다이얼로그 표시
  Future<void> _checkAppVersion() async {
    // 앱이 완전히 로드될 때까지 대기
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    try {
      final versionService = AppVersionService();
      final updateType = versionService.checkUpdateRequired();

      if (updateType != null && mounted) {
        // 네비게이터가 준비될 때까지 대기
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (mounted && navigatorKey.currentContext != null) {
            await UpdateDialog.show(
              navigatorKey.currentContext!,
              versionService,
              updateType,
            );
          }
        });
      }
    } catch (e) {
      print('버전 체크 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => CurrencyProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Subit',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            themeAnimationDuration: const Duration(milliseconds: 400),
            themeAnimationCurve: Curves.easeInOut,
            scrollBehavior: NoStretchScrollBehavior(),
            initialRoute: '/',
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return FadePageRoute(page: const SplashScreen());
                case '/home':
                  return FadePageRoute(page: const HomeScreen());
                default:
                  return null;
              }
            },
          );
        },
      ),
    );
  }
}
