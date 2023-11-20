import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_project_ba_char/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PhotoLetterWidget extends StatelessWidget {
  final String? letter;
  final double radius;
  final Color? color;
  final Color? foregroundColor;
  final String? url;

  const PhotoLetterWidget({
    super.key,
    this.letter,
    this.url,
    required this.radius,
    this.color,
    this.foregroundColor,
  });

  static const List<Color> colors = [
    Colors.white,
  ];

  @override
  Widget build(BuildContext context) {
    String text = (letter?.split(' ') ?? [])
        .map((e) => e.isEmpty ? '' : e.substring(0, 1))
        .toList()
        .join('');

    if (text.length >= 2) text = text.substring(0, 2);

    int index = Random().nextInt(colors.length);

    return CircleAvatar(
      radius: radius,
      backgroundColor: color ?? colors[index],
      foregroundColor: foregroundColor ?? (color != null ? null : Colors.black),
      child: url?.isNotEmpty == true
          ? CachedNetworkImage(
              imageUrl: url!,
              errorWidget: (context, url, error) => _buildError(text),
              height: radius * 2,
              width: radius * 2,
              memCacheHeight: (radius * 5).round(),
              fit: BoxFit.cover,
            )
          : _buildError(text),
    );
  }

  Widget _buildError(String text) {
    if (text.isEmpty) {
      return const FaIcon(
        FontAwesomeIcons.user,
        color: Colors.black45,
      );
    }
    return FittedBox(
      fit: BoxFit.cover,
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class PhotoLetterWithDotWidget extends StatelessWidget {
  final String? name;
  final String? url;
  final double? radius;
  final String? dotMessage;
  final Color? dotColor;
  final double? padding;
  final double? dotSizes;
  final Color? borderColor;

  const PhotoLetterWithDotWidget({
    super.key,
    this.name,
    this.url,
    this.radius,
    this.dotMessage,
    this.dotColor,
    this.padding,
    this.dotSizes,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(padding ?? 10.0),
          child: PhotoLetterWidget(
            radius: radius ?? 40.0,
            letter: name,
            url: url,
          ),
        ),
        if (dotMessage != null)
          Positioned(
            bottom: 12,
            right: 12,
            child: Tooltip(
              message: dotMessage,
              child: Container(
                height: dotSizes ?? 20,
                width: dotSizes ?? 20,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  color: dotColor ?? darkGreyApp,
                  border: Border.all(
                      color: borderColor ?? scaffoldColor, width: 2.0),
                ),
              ),
            ),
          )
      ],
    );
  }
}
