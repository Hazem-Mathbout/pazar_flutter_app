import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pazar/app/core/values/colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryRed,
      scaffoldBackgroundColor: AppColors.lightGrey,
      fontFamily: 'Rubik',
      useMaterial3: true,

      // AppBar
      appBarTheme: const AppBarTheme(
        // backgroundColor: Colors.white,
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor ?? Colors.red,
        foregroundColor: AppColors.foregroundPrimary,
        elevation: 1,
        iconTheme: IconThemeData(color: AppColors.foregroundSecondary),
        titleTextStyle: TextStyle(
          color: AppColors.foregroundPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // black icons
          statusBarBrightness: Brightness.light, // for iOS
          systemNavigationBarColor: Colors.white,
        ),
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: AppColors.darkGrey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 5,
      ),

      // Text
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.foregroundPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.foregroundSecondary),
        bodySmall: TextStyle(color: AppColors.foregroundHint),
        titleMedium: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.foregroundPrimary,
        ),
        labelLarge: TextStyle(color: AppColors.primaryRed),
      ),

      // TextField / Input
      inputDecorationTheme: const InputDecorationTheme(
        filled: false,
        // fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(12),
        //   borderSide: const BorderSide(color: AppColors.borderDefault),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(8),
        //   borderSide: const BorderSide(color: AppColors.primaryRed, width: 1.5),
        // ),
        // enabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(12),
        //   borderSide: const BorderSide(color: AppColors.foregroundHint),
        // ),
        hintStyle: TextStyle(color: AppColors.foregroundHint),
        labelStyle: TextStyle(color: AppColors.foregroundPrimary),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        ),
      ),

      // Dropdown
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white),
          surfaceTintColor: WidgetStateProperty.all(AppColors.lightGrey),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderDefault),
          ),
        ),
      ),

      // Divider
      dividerColor: AppColors.mediumGrey,

      // Chip
      chipTheme: const ChipThemeData(
        backgroundColor: AppColors.backgroundDefault,
        disabledColor: AppColors.foregroundDisabled,
        selectedColor: AppColors.primaryRed,
        secondarySelectedColor: AppColors.primaryRed,
        labelStyle: TextStyle(color: AppColors.foregroundPrimary),
        secondaryLabelStyle: TextStyle(color: Colors.white),
        brightness: Brightness.light,
      ),

      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryRed,
        onPrimary: Colors.white,
        secondary: AppColors.foregroundSecondary,
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: AppColors.foregroundPrimary,
        error: Colors.redAccent,
        onError: Colors.white,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light, // white icons
          statusBarBrightness: Brightness.dark, // for iOS
          systemNavigationBarColor: Colors.white,
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      // Add other dark theme customizations
    );
  }
}
