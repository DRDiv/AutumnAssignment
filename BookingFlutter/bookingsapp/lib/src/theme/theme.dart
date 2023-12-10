import 'package:flutter/material.dart';

// class ColorSchemes {
//   static Color backgroundColor = Colors.white;
//   static Color primaryColor = Color(0xFF1D3557);
//   static Color secondayColor = Color(0xFF457B9D);
//   static Color tertiaryColor = Color(0xFFA8DADC);
//   static Color blendColor = Color(0xFF34a0a4);
//   static Color whiteColor = Colors.white;
// }

// class FontsCustom {
//   static final TextStyle heading = TextStyle(
//     color: Colors.black87,
//     fontFamily: 'Montserrat',
//     fontSize: 36,
//     fontWeight: FontWeight.bold,
//   );

//   static final TextStyle subHeading = TextStyle(
//     color: Colors.black87,
//     fontFamily: 'Montserrat',
//     fontSize: 24,
//     fontWeight: FontWeight.w400,
//   );

//   static final TextStyle bodyBigText = TextStyle(
//     fontFamily: 'OpenSans',
//     fontSize: 18,
//     fontWeight: FontWeight.w400,
//     color: Colors.black54,
//   );

//   static final TextStyle bodyHeading = TextStyle(
//     fontFamily: 'Montserrat',
//     fontSize: 28,
//     fontWeight: FontWeight.bold,
//     color: Colors.black87,
//   );

//   static final TextStyle bodySmallText = TextStyle(
//     fontFamily: 'OpenSans',
//     fontSize: 15,
//     fontWeight: FontWeight.w500,
//     color: Colors.black54,
//   );

//   static final TextStyle smallText = TextStyle(
//     color: Colors.white70,
//     fontWeight: FontWeight.bold,
//     fontFamily: 'Roboto',
//     fontSize: 7,
//   );
// }

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme(
            primary: ColorSchemes.primaryColor,
            secondary: ColorSchemes.secondayColor,
            background: ColorSchemes.backgroundColor),
        primaryColor: ColorSchemes.primaryColor,
        hintColor: ColorSchemes.secondayColor,
        scaffoldBackgroundColor: ColorSchemes.backgroundColor,
        textTheme: TextTheme(
          displayLarge: FontsCustom.heading,
          displayMedium: FontsCustom.subHeading,
          displaySmall: FontsCustom.bodyHeading,
          bodyLarge: FontsCustom.bodyBigText,
          bodySmall: FontsCustom.bodySmallText,
          labelSmall: FontsCustom.smallText,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: ColorSchemes.primaryColor,
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: ColorSchemes.secondayColor,
          inactiveTrackColor: ColorSchemes.tertiaryColor,
          thumbColor: ColorSchemes.primaryColor,
          overlayColor: ColorSchemes.secondayColor.withOpacity(0.4),
          valueIndicatorColor: ColorSchemes.primaryColor,
          valueIndicatorTextStyle: TextStyle(
            color: Colors.white,
          ),
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
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: ColorSchemes.primaryColor,
            fontWeight: FontWeight.bold,
          ),
          hintStyle: TextStyle(
            color: ColorSchemes.secondayColor,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorSchemes.primaryColor,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorSchemes.secondayColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: ColorSchemes.tertiaryColor,
          contentTextStyle: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: ColorSchemes.whiteColor,
        ));
  }
}
