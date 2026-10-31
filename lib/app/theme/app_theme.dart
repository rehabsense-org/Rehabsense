import 'package:flutter/material.dart';
import '../../core/tokens.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: RSText.fontFamily,
    scaffoldBackgroundColor: RSColors.surfaceCanvas,
    colorScheme: ColorScheme.light(
      primary: RSColors.brandAction,
      onPrimary: RSColors.textOnDark,
      secondary: RSColors.brandMint,
      onSecondary: RSColors.brandGreen,
      error: RSColors.statusError,
      onError: RSColors.textOnDark,
      surface: RSColors.surfaceCard,
      onSurface: RSColors.textPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: RSColors.surfaceCanvas,
      foregroundColor: RSColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: RSSizes.appBar,
      centerTitle: true,
      titleTextStyle: RSText.bodyStrong.copyWith(color: RSColors.textPrimary),
    ),
    cardTheme: CardThemeData(
      color: RSColors.surfaceCard,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: RSRadius.cardBR),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: RSColors.brandAction,
        foregroundColor: RSColors.textOnDark,
        minimumSize: const Size(double.infinity, RSSizes.buttonLarge),
        shape: const StadiumBorder(),
        textStyle: RSText.buttonLarge,
        elevation: 0,
        disabledBackgroundColor: RSColors.surfaceCeramic,
        disabledForegroundColor: RSColors.textSecondary,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: RSColors.brandAction,
        minimumSize: const Size(double.infinity, RSSizes.buttonLarge),
        shape: const StadiumBorder(),
        side: const BorderSide(color: RSColors.brandAction, width: 1.5),
        textStyle: RSText.buttonLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: RSColors.brandAction,
        textStyle: RSText.buttonLarge,
        minimumSize: const Size(double.infinity, RSSizes.buttonMedium),
        shape: const StadiumBorder(),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: RSColors.surfaceCard,
      border: OutlineInputBorder(
        borderRadius: RSRadius.inputBR,
        borderSide: const BorderSide(color: RSColors.borderInput),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: RSRadius.inputBR,
        borderSide: const BorderSide(color: RSColors.borderInput),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: RSRadius.inputBR,
        borderSide: const BorderSide(color: RSColors.brandAction, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: RSRadius.inputBR,
        borderSide: const BorderSide(color: RSColors.statusError),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: RSRadius.inputBR,
        borderSide: const BorderSide(color: RSColors.statusError, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      labelStyle: RSText.bodySmallStrong.copyWith(color: RSColors.textSecondary),
      hintStyle: RSText.bodyDefault.copyWith(color: RSColors.textSecondary),
      errorStyle: RSText.caption.copyWith(color: RSColors.statusError),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: RSColors.surfaceCard,
      selectedItemColor: RSColors.brandAction,
      unselectedItemColor: Color(0xFF757575),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    dividerTheme: const DividerThemeData(
      color: RSColors.borderHairline,
      thickness: 1,
      space: 0,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: RSColors.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(RSRadius.sheet)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: RSColors.surfaceCard,
      shape: RoundedRectangleBorder(borderRadius: RSRadius.sheetBR),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: RSColors.brandDeep,
      contentTextStyle: RSText.bodySmall.copyWith(color: RSColors.textOnDark),
      shape: RoundedRectangleBorder(borderRadius: RSRadius.cardBR),
      behavior: SnackBarBehavior.floating,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return RSColors.brandAction;
        return RSColors.surfaceCard;
      }),
      checkColor: WidgetStateProperty.all(RSColors.textOnDark),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: const BorderSide(color: RSColors.borderInput, width: 1.5),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return RSColors.surfaceCard;
        return RSColors.surfaceCeramic;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return RSColors.brandAction;
        return RSColors.borderInput;
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: RSColors.brandAction,
      linearTrackColor: RSColors.surfaceCeramic,
    ),
  );
}
