import 'package:final_project_ba_char/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

abstract class Themes {
  static ThemeData lightTheme(BuildContext context) {
    final baseTheme = ThemeData.light(
      useMaterial3: true,
    ).copyWith(
      primaryColor: accentColor,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: accentColor,
        accentColor: accentColor,
      ).copyWith(
        outline: Colors.transparent,
        surfaceTint: accentColor,
      ),
      scaffoldBackgroundColor: scaffoldColor,
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: primaryColor,
        surfaceTintColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: inputColor,
        filled: true,

        // iconColor: cardTitleColor,
        // prefixIconColor: cardTitleColor,
        // suffixIconColor: cardTitleColor,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 22,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: borderRadiusCard,
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: borderRadiusInput,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: borderRadiusInput,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: borderRadiusInput,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.5,
            color: Colors.pink,
          ),
          borderRadius: borderRadiusInput,
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.5,
            color: Colors.pink,
          ),
          // borderRadius: borderRadiusInput,
        ),
      ),
      tabBarTheme: TabBarTheme(
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          border: Border.all(
            color: primaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        labelColor: primaryColor,
        unselectedLabelColor: Colors.grey,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.white;
            }
            return Colors.grey;
          },
        ),
        trackColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return accentColor;
            }
            return Colors.transparent;
          },
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          textStyle: GoogleFonts.montserrat(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: accentColor,
          ),
          textStyle: GoogleFonts.montserrat(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: accentColor,
        elevation: 0.0,
      ),
      navigationRailTheme: NavigationRailThemeData(
        selectedIconTheme: IconThemeData(
          color: orangeApp,
        ),
        unselectedIconTheme: const IconThemeData(color: Colors.white70),
        selectedLabelTextStyle: GoogleFonts.montserrat(
          fontSize: 10,
          color: Colors.white,
        ),
        unselectedLabelTextStyle: GoogleFonts.montserrat(
          fontSize: 10,
        ),
      ),
      dataTableTheme: DataTableThemeData(
        headingTextStyle: GoogleFonts.montserrat(
          fontWeight: FontWeight.w500,
          // color: breadCrumbingColor,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          // boxShadow: boxShadowCard,
          // borderRadius: borderRadiusCard,
        ),
        dividerThickness: 0,
        dataRowColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.grey[200];
            }
            return null;
          },
        ),
        headingRowColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.selected)) {
              // return tableHeaderColor;
            }
            return null;
          },
        ),
      ),
      dividerColor: const Color(0xffe7e7e7),
      dividerTheme: const DividerThemeData(color: Color(0xffe7e7e7)),
      cardColor: cardColor,
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey[200],
        selectedColor: goldApp,
        labelStyle: GoogleFonts.montserrat(
          color: darkGreyApp,
          fontWeight: FontWeight.w500,
        ),
        checkmarkColor: Colors.white,
        secondaryLabelStyle: GoogleFonts.montserrat(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    final textTheme = baseTheme.textTheme;

    return baseTheme.copyWith(
      textTheme: GoogleFonts.montserratTextTheme(
        textTheme.copyWith(
          displaySmall: textTheme.displaySmall?.copyWith(
            // color: titleColor,
            fontWeight: FontWeight.w600,
            fontSize: 35,
          ),
          headlineSmall: textTheme.headlineSmall?.copyWith(
            // color: cardTitleColor,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: textTheme.titleLarge?.copyWith(
            // color: cardTitleColor,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
          titleSmall: textTheme.titleSmall?.copyWith(
            // color: cardTitleColor,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          labelLarge: textTheme.labelLarge?.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            // color: subtitleColor,
          ),
          labelMedium: textTheme.labelMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            // color: subtitleColor,
          ),
          bodyLarge: textTheme.bodyLarge?.copyWith(
            fontSize: 15,
            // color: cardTitleColor,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: textTheme.bodyMedium?.copyWith(
            fontSize: 15,
            // color: cardTitleColor,
          ),
        ),
      ),
    );
  }
}
