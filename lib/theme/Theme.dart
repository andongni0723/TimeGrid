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

ColorScheme darkColorScheme = const ColorScheme(
  brightness: Brightness.dark,

  // 主色系（你給了）
  primary: _cPrimary,
  onPrimary: _cDarkOnBackground, // 你原文是白/淺灰字，使用 E6E6E6
  primaryContainer: _cPrimaryContainerDark,
  onPrimaryContainer: _cDarkOnBackground,

  // 次要色（你給了）
  secondary: _cSecondary,
  onSecondary: _cDarkOnBackground,
  secondaryContainer: _cSecondaryContainer,
  onSecondaryContainer: _cDarkOnBackground,

  // 背景 / surface（你給了）
  surface: _cDarkSurface,
  onSurface: _cDarkOnSurface,

  // surface variant（你給了）
  surfaceContainerHighest: _cSurfaceContainerHighest,
  onSurfaceVariant: _cDarkOnSurfaceVariant,

  // 其他 M3 欄位（Compose 有的也有對應）
  outline: _cOutline,
  surfaceTint: _cSurfaceTint,

  // 以下為沒有在原文指定的欄位，我放入合理預設（可再調整）
  error: Color(0xFFB00020),
  onError: Color(0xFFFFFFFF),
  inverseSurface: Color(0xFFF5F5F5),
  onInverseSurface: Color(0xFF14161D),
  inversePrimary: Color(0xFF6563E6),
  shadow: Color(0xFF000000),
  // tertiary / onTertiary / containers 可視需求再補
  tertiary: Color(0xFFB39DDB),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFF4A3F7A),
  onTertiaryContainer: Color(0xFFFFFFFF),
);

ColorScheme lightColorScheme = const ColorScheme(
  brightness: Brightness.light,

  // 你提供的 light 色票
  primary: _cPrimary,
  onPrimary: Color(0xFF14161D), // 你給的是深色字
  primaryContainer: Color(0xFFF0EDFF), // fallback（淺的 primary container）
  onPrimaryContainer: Color(0xFF14161D),

  secondary: _cSecondary,
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFE6FFF3),
  onSecondaryContainer: Color(0xFF14161D),
  surface: Color(0xFFF7F7FF),
  onSurface: Color(0xFF14161D),

  surfaceContainerHighest: Color(0xFFFFFFFF),
  onSurfaceVariant: Color(0xFF14161D),

  // fallback / 補齊欄位
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
