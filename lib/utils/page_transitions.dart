import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 일반 화면 전환용 커스텀 PageRoute (Fade + Slide + 스와이프 뒤로가기)
class FadeSlidePageRoute<T> extends CupertinoPageRoute<T> {
  FadeSlidePageRoute({required Widget page})
      : super(builder: (context) => page);

  // 안드로이드에서도 스와이프 뒤로가기 활성화
  @override
  bool get popGestureEnabled => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 500);
}

/// Splash에서 Home으로의 전환용 (Fade만)
class FadePageRoute<T> extends PageRouteBuilder<T> {
  FadePageRoute({required Widget page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
