import 'package:flutter/material.dart';

class PageLoadingAbsorbPointer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? title;
  const PageLoadingAbsorbPointer(
      {super.key, required this.child, this.isLoading = false, this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(
          absorbing: isLoading,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: isLoading ? 0.75 : 1,
            child: child,
          ),
        ),
        if (isLoading)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                if (title != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    title!,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
