import 'package:flutter/material.dart' show Brightness, Color, ColorScheme;

const Color _cDarkOnBackground = Color(0xFFE6E6E6); // #E6E6E6
const Color _cDarkSurface = Color(0xFF14161D);
const Color _cDarkOnSurface = Color(0xFFE1E1E1);
const Color _cSurfaceContainerHighest = Color(0xFF211F26);
const Color _cDarkOnSurfaceVariant = Color(0xFFE6E6E6);
const Color _cPrimary = Color(0xFF8080FF); // #8080FF
const Color _cPrimaryContainerDark = Color(0xFF4C4C7D);
const Color _cSecondary = Color(0xFF00BE86);
const Color _cSecondaryContainer = Color(0xFF2B2E3A);
const Color _cOutline = Color(0xFF2B2E3A);
const Color _cSurfaceTint = Color(0xFF8080FF);

const Color primaryColor = _cPrimary;

ColorScheme darkColorScheme = const ColorScheme(
  brightness: Brightness.dark,

  primary: _cPrimary,
  onPrimary: _cDarkOnBackground,
  primaryContainer: _cPrimaryContainerDark,
  onPrimaryContainer: _cDarkOnBackground,

  secondary: _cSecondary,
  onSecondary: _cDarkOnBackground,
  secondaryContainer: _cSecondaryContainer,
  onSecondaryContainer: _cDarkOnBackground,

  surface: _cDarkSurface,
  onSurface: _cDarkOnSurface,

  surfaceContainerHighest: _cSurfaceContainerHighest,
  onSurfaceVariant: _cDarkOnSurfaceVariant,

  outline: _cOutline,
  surfaceTint: _cSurfaceTint,

  error: Color(0xFFD32F2F),
  onError: Color(0xFFFFFFFF),
  inverseSurface: Color(0xFFF5F5F5),
  onInverseSurface: Color(0xFF14161D),
  inversePrimary: Color(0xFF6563E6),
  shadow: Color(0xFF000000),
  tertiary: Color(0xFFB39DDB),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFF4A3F7A),
  onTertiaryContainer: Color(0xFFFFFFFF),
);

ColorScheme lightColorScheme = const ColorScheme(
  brightness: Brightness.light,

  primary: _cPrimary,
  onPrimary: Color(0xFF14161D),
  primaryContainer: Color(0xFFF0EDFF),
  onPrimaryContainer: Color(0xFF14161D),

  secondary: _cSecondary,
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFE6FFF3),
  onSecondaryContainer: Color(0xFF14161D),
  surface: Color(0xFFF7F7FF),
  onSurface: Color(0xFF14161D),

  surfaceContainerHighest: Color(0xFFFFFFFF),
  onSurfaceVariant: Color(0xFF14161D),

  outline: Color(0xFFE6E6E6),
  surfaceTint: _cPrimary,

  error: Color(0xFFB00020),
  onError: Color(0xFFFFFFFF),
  inverseSurface: Color(0xFF14161D),
  onInverseSurface: Color(0xFFF7F7FF),
  inversePrimary: Color(0xFF6563E6),
  shadow: Color(0xFF000000),

  tertiary: Color(0xFF7C4DFF),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFEDE6FF),
  onTertiaryContainer: Color(0xFF14161D),
);

/// Provide to chip of course card colors
const List<Color> colorLibrary = [
  Color(0xFF2E3A8C),
  Color(0xFF006D5B),
  Color(0xFF8A4B2A),
  Color(0xFF4C5B21),
  Color(0xFF6B1E3B),
  Color(0xFF2D3741),
  Color(0xFF8D6B2D),
  Color(0xFF006B7B),
  Color(0xFF5B2E5A),
  Color(0xFF1F5D3D),
  Color(0xFF6E3F2E),
  Color(0xFF17224A),
  Color(0xFF7A2F6E),
  Color(0xFF5B3A2E),
  Color(0xFF2A516B),
  Color(0xFF106A43),
  Color(0xFF3C2F5B),
];
