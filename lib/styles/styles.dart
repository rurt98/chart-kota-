import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

List<BoxShadow> get boxShadowBlack => [
      const BoxShadow(
        color: Colors.black12,
        blurRadius: 5,
        spreadRadius: 1,
        offset: Offset(0, 3),
      )
    ];

BoxDecoration get eventDecoration => BoxDecoration(
      boxShadow: boxShadowCard,
      borderRadius: BorderRadius.circular(10),
    );

DataTableThemeData get dataTableTheme => DataTableThemeData(
      headingTextStyle: GoogleFonts.montserrat(
        fontWeight: FontWeight.w500,
        color: darkGreyApp,
      ),
      decoration: BoxDecoration(
        boxShadow: boxShadowCard,
        borderRadius: borderRadiusCard,
      ),
      dividerThickness: 0,
    );

InputDecorationTheme get inputDecorationSearch => InputDecorationTheme(
      fillColor: inputColor.withOpacity(0.09),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1.5,
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1.5,
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1.5,
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1.5,
          color: Colors.pink,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1.5,
          color: Colors.pink,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      floatingLabelStyle: TextStyle(
        fontSize: 22,
        color: primaryColor,
      ),
    );

const double gapMarginCards = 16.0;
const cardPadding = EdgeInsets.all(27);
final borderRadiusCard = BorderRadius.circular(8);

const switcherDuration = Duration(milliseconds: 300);

final borderRadiusInput = BorderRadius.circular(10);

List<BoxShadow> get boxShadowCard => [
      BoxShadow(
        color: greyApp!.withOpacity(0.5),
        blurRadius: 10,
        offset: const Offset(0, 3),
      )
    ];

const tableButtonPadding = EdgeInsets.symmetric(vertical: 2);

extension ContextExtension on BuildContext {
  BoxDecoration get cardDecoration => BoxDecoration(
        border: Border.all(
          color: greyApp!,
        ),
        borderRadius: borderRadiusCard,
      );
}
