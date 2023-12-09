import 'package:bookingsapp/src/assets/colors.dart';
import 'package:bookingsapp/src/assets/fonts.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
        useMaterial3: false,
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
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorSchemes.primaryColor,
            textStyle: TextStyle(color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: ColorSchemes.primaryColor,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: ColorSchemes.primaryColor,
          foregroundColor: Colors.white,
        ),
        listTileTheme: ListTileThemeData(
          tileColor: ColorSchemes.backgroundColor,
          selectedTileColor: ColorSchemes.secondayColor,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          dense: false,
          textColor: ColorSchemes.secondayColor,
          selectedColor: ColorSchemes.secondayColor,
          iconColor: ColorSchemes.secondayColor,
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: ColorSchemes.primaryColor,
        ),
        tabBarTheme: TabBarTheme(
          labelColor: ColorSchemes.whiteColor,
          unselectedLabelColor: ColorSchemes.secondayColor,
          indicatorColor: ColorSchemes.tertiaryColor,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(
          color: ColorSchemes.whiteColor,
        ));
  }
}
