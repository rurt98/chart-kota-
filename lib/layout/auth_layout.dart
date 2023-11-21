import 'package:final_project_ba_char/helpers/responsive_helpers.dart';
import 'package:final_project_ba_char/styles/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthLayout extends StatefulWidget {
  final Widget? child;
  const AuthLayout({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<AuthLayout> createState() => _AuthLayoutState();
}

class _AuthLayoutState extends State<AuthLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          wallpaper(),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 500,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget wallpaper() {
    return SizedBox(
      height: double.infinity,
      child: Stack(
        children: [
          // TODO:
          Positioned.fill(
            child: Image.asset(
              'assets/wallpapers/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: primaryColor.withOpacity(0.25),
          ),
          if (context.screenSize == ScreenSize.large)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Image.asset(
                  'assets/logos/char[Kota].png',
                  width: 200,
                  fit: BoxFit.fitWidth,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
