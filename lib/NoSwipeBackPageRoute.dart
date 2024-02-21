import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NoSwipeBackPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  NoSwipeBackPageRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(4, 0, 59, 1),
                    Color.fromRGBO(90, 0, 90, 1),
                  ],
                ),
              ),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
        );
}
