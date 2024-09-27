part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final Color color;
  final Brightness brightness;
  final bool useMaterial3;
  final Color backgroundColor;
  final bool overrideBackgroundColor;
  final bool useOldTheme;
  final String fontFamily;
  final Locale? locale;
  const ThemeState({
    required this.color,
    required this.brightness,
    required this.useMaterial3,
    required this.backgroundColor,
    required this.overrideBackgroundColor,
    required this.useOldTheme,
    required this.fontFamily,
    required this.locale,
  });

  ThemeData get theme {
    if (useOldTheme && !useMaterial3) {
      return ThemeData(
        useMaterial3: false,
        brightness: brightness,
        colorSchemeSeed: color,
        fontFamily: fontFamily,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );
    }
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: color,
        brightness: brightness,
        surface: overrideBackgroundColor ? backgroundColor : null,
      ),
      useMaterial3: useMaterial3,
      fontFamily: fontFamily,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  ThemeState copyWith({
    Color? color,
    Brightness? brightness,
    bool? useMaterial3,
    Color? backgroundColor,
    bool? overrideBackgroundColor,
    bool? useOldTheme,
    String? fontFamily,
    Locale? locale,
  }) {
    return ThemeState(
      color: color ?? this.color,
      brightness: brightness ?? this.brightness,
      useMaterial3: useMaterial3 ?? this.useMaterial3,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      overrideBackgroundColor:
          overrideBackgroundColor ?? this.overrideBackgroundColor,
      useOldTheme: useOldTheme ?? this.useOldTheme,
      fontFamily: fontFamily ?? this.fontFamily,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props {
    return [
      color,
      brightness,
      useMaterial3,
      backgroundColor,
      overrideBackgroundColor,
      useOldTheme,
      fontFamily,
      locale,
    ];
  }
}
