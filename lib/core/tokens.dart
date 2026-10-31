// ---------------------------------------------------------------------------
// DESIGN TOKENS — RehabSense
// Single source of truth for colours, typography, spacing, radius, shadows.
// No hard-coded hex outside this file.
// ---------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── COLOURS ────────────────────────────────────────────────────────────────
abstract final class RSColors {
  // Brand
  static const Color brandGreen = Color(0xFF006241);
  static const Color brandAction = Color(0xFF00754A);
  static const Color brandDeep = Color(0xFF1E3932);
  static const Color brandUplift = Color(0xFF2B5148);
  static const Color brandMint = Color(0xFFD4E9E2);

  // Accent — gold is MILESTONE ONLY
  static const Color accentGold = Color(0xFFCBA258);
  static const Color accentGoldLight = Color(0xFFDFC49D);
  static const Color accentGoldWash = Color(0xFFFAF6EE);
  static const Color accentGoldDeep = Color(0xFF7D5E22);

  // Surfaces
  static const Color surfaceCanvas = Color(0xFFF2F0EB);
  static const Color surfaceCeramic = Color(0xFFEDEBE9);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceCool = Color(0xFFF9F9F9);
  static const Color surfaceInk = Color(0xFF000000);
  static const Color surfaceCamera = Color(0xFF101614);

  // Text
  static Color textPrimary = const Color(0xFF000000).withOpacity(0.87);
  static Color textSecondary = const Color(0xFF000000).withOpacity(0.58);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static Color textOnDarkSoft = const Color(0xFFFFFFFF).withOpacity(0.70);
  static const Color textMutedGreen = Color(0xFF33433D);

  // Borders
  static const Color borderInput = Color(0xFFD6DBDE);
  static const Color borderHairline = Color(0xFFE7E7E7);

  // Status
  static const Color statusSuccess = Color(0xFF00754A);
  static const Color statusSuccessTint = Color(0xFFEAF4F0);
  static const Color statusError = Color(0xFFC82014);
  static const Color statusErrorTint = Color(0xFFFBECEB);
  static const Color statusWarning = Color(0xFFFBBC05);
  static const Color statusWarningInk = Color(0xFF8A6100);
  static const Color statusWarningTint = Color(0xFFFEF5DA);

  // Overlays
  static Color overlayScrim = const Color(0xFF000000).withOpacity(0.50);
  static Color overlayGlass = const Color(0xFFFFFFFF).withOpacity(0.16);
}

// ─── TYPOGRAPHY ─────────────────────────────────────────────────────────────
abstract final class RSText {
  static String? _fontFamily;

  static String get fontFamily {
    _fontFamily ??= GoogleFonts.inter().fontFamily;
    return _fontFamily!;
  }

  static TextStyle displayMetric = TextStyle(
    fontFamily: fontFamily,
    fontSize: 56,
    fontWeight: FontWeight.w600,
    height: 1.0,
    letterSpacing: -0.56 * 2, // -2%
  );

  static TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 45,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.45, // -1%
  );

  static TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.32, // -1%
  );

  static TextStyle headingH1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.5, // 36px / 24px
    letterSpacing: -0.24,
    color: RSColors.brandGreen,
  );

  static TextStyle headingH2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: -0.24,
  );

  static TextStyle headingH3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 19,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: -0.19,
  );

  static TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 19,
    fontWeight: FontWeight.w400,
    height: 1.75,
    letterSpacing: -0.19,
  );

  static TextStyle bodyDefault = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: -0.16,
  );

  static TextStyle bodyStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: -0.16,
  );

  static TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: -0.14,
  );

  static TextStyle bodySmallStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: -0.14,
  );

  static TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: -0.13,
  );

  static TextStyle captionStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: -0.13,
  );

  static TextStyle labelOverline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: 1.2, // +10%
  );

  static TextStyle buttonLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.16,
  );

  static TextStyle buttonMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.14,
  );
}

// ─── SPACING ────────────────────────────────────────────────────────────────
abstract final class RSSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;
  static const double xxxl = 48;
  static const double huge = 56;
  static const double massive = 64;

  /// Default horizontal padding for screens.
  static const double screenH = 16;

  /// Default vertical gap between blocks.
  static const double blockGap = 20;

  /// Card list gap.
  static const double cardGap = 12;
}

// ─── RADIUS ─────────────────────────────────────────────────────────────────
abstract final class RSRadius {
  static const double input = 4;
  static const double card = 12;
  static const double heroCard = 16;
  static const double sheet = 24;
  static const double pill = 50;

  static BorderRadius get inputBR => BorderRadius.circular(input);
  static BorderRadius get cardBR => BorderRadius.circular(card);
  static BorderRadius get heroCardBR => BorderRadius.circular(heroCard);
  static BorderRadius get sheetBR => BorderRadius.circular(sheet);
  static BorderRadius get pillBR => BorderRadius.circular(pill);
}

// ─── SIZES ──────────────────────────────────────────────────────────────────
abstract final class RSSizes {
  static const double touchMin = 48;
  static const double buttonLarge = 52;
  static const double buttonMedium = 40;
  static const double fab = 56;
  static const double appBar = 48;
  static const double bottomNav = 80;
  static const double actionBar = 72;
  static const double iconButton = 40; // visual
  static const double iconButtonHit = 48; // hit area
}

// ─── SHADOWS ────────────────────────────────────────────────────────────────
abstract final class RSShadows {
  static List<BoxShadow> card = [
    BoxShadow(
      offset: Offset.zero,
      blurRadius: 0.5,
      color: Colors.black.withOpacity(0.14),
    ),
    BoxShadow(
      offset: const Offset(0, 1),
      blurRadius: 1,
      color: Colors.black.withOpacity(0.24),
    ),
  ];

  static List<BoxShadow> nav = [
    BoxShadow(
      offset: const Offset(0, 1),
      blurRadius: 3,
      color: Colors.black.withOpacity(0.10),
    ),
    BoxShadow(
      offset: const Offset(0, 2),
      blurRadius: 2,
      color: Colors.black.withOpacity(0.06),
    ),
    BoxShadow(
      offset: Offset.zero,
      blurRadius: 2,
      color: Colors.black.withOpacity(0.07),
    ),
  ];

  static List<BoxShadow> floating = [
    BoxShadow(
      offset: Offset.zero,
      blurRadius: 6,
      color: Colors.black.withOpacity(0.24),
    ),
    BoxShadow(
      offset: const Offset(0, 8),
      blurRadius: 12,
      color: Colors.black.withOpacity(0.14),
    ),
  ];

  static List<BoxShadow> sheet = [
    BoxShadow(
      offset: Offset.zero,
      blurRadius: 6,
      color: Colors.black.withOpacity(0.12),
    ),
    BoxShadow(
      offset: const Offset(0, 12),
      blurRadius: 24,
      color: Colors.black.withOpacity(0.16),
    ),
  ];
}
