import 'package:final_project_ba_char/styles/styles.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final double? width;
  final double? height;

  final EdgeInsets? margin;
  final EdgeInsets? padding;

  final double? radius;

  final Color? backgroundColor;

  const CustomCard({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.radius,
    this.margin,
    this.backgroundColor,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: context.cardDecoration.copyWith(
          color: backgroundColor,
          borderRadius: radius != null
              ? BorderRadius.all(Radius.circular(radius!))
              : null),
      child: ClipRRect(
        borderRadius: radius != null
            ? BorderRadius.all(Radius.circular(radius!))
            : borderRadiusCard,
        child: Padding(
          padding: padding ?? cardPadding,
          child: child,
        ),
      ),
    );
  }
}

class InputContainer extends StatelessWidget {
  final Widget child;
  final Widget? prefix;
  final Widget? suffix;

  final VoidCallback? onTap;

  const InputContainer(
      {super.key, required this.child, this.prefix, this.suffix, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Material(
        borderRadius: borderRadiusInput,
        color: Theme.of(context).inputDecorationTheme.fillColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadiusInput,
          child: Row(
            children: [
              if (prefix != null)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: prefix!,
                ),
              const SizedBox(width: 16),
              Expanded(child: child),
              const SizedBox(width: 16),
              if (suffix != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: suffix!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
