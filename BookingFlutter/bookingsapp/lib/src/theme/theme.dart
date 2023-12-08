import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      primaryColor: ColorSchemes.primaryColor,
      hintColor: ColorSchemes.secondayColor,
      scaffoldBackgroundColor: ColorSchemes.backgroundColor,
      textTheme: TextTheme(
        displayLarge: FontsCustom.heading,
        displayMedium: FontsCustom.subHeading,
        displaySmall: FontsCustom.bodyHeading,
        headlineMedium: FontsCustom.bodyBigText,
        headlineSmall: FontsCustom.bodySmallText,
        titleLarge: FontsCustom.smallText,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: ColorSchemes.primaryColor,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: ColorSchemes.primaryColor,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: ColorSchemes.whiteColor,
        selectedTileColor: ColorSchemes.secondayColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        dense: false,
        textColor: Colors.white,
        selectedColor: Colors.white,
        iconColor: Colors.white,
      ),
    );
  }
}
