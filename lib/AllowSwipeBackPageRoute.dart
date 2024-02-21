import 'package:flutter/material.dart';

class AllowSwipeBackPageRoute extends PageRouteBuilder {
  final Widget page;

  AllowSwipeBackPageRoute({required this.page})
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
          ) =>
              DecoratedBox(
                decoration: const BoxDecoration(
                  // Define the gradient here
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(4, 0, 59, 1),
                      Color.fromRGBO(90, 0, 90, 1),
                    ],
                  ),
                ),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              ),
        );
}
