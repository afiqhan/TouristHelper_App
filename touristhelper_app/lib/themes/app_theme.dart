import 'package:flutter/material.dart';
import 'package:touristhelper_app/themes/colors.dart' as clrs;

/// This class defines global themes for the app. Right now they are defined as
/// final variables but we can refactor this to take the values in a constructor,
/// to define multiple different themes (ie a Pitt color theme, dark theme, etc.)
@immutable
class AppTheme extends ThemeExtension<AppTheme> {
  
  // Global color theme
  final Color veryLight = clrs.veryLight;
  final Color veryDark = clrs.veryDark;
  final Color background = clrs.background;
  final Color blueLight = clrs.blue_light;
  final Color blueMeium = clrs.blue_medium;
  final Color blueDark = clrs.blue_dark;

  // Global text themes
  final TextStyle titleStyle = TextStyle(
      color: clrs.veryLight,
      fontFamily: "OpenSans",
      fontWeight: FontWeight.bold,
      fontSize: 20);
  final TextStyle subtitleStyle = TextStyle(
      color: clrs.veryLight,
      fontFamily: "OpenSans",
      fontWeight: FontWeight.bold,
      fontSize: 16);
  final TextStyle decoratedSubtitleStyle = TextStyle(
      color: clrs.blue_medium,
      fontFamily: "OpenSans",
      fontStyle: FontStyle.italic,
      fontSize: 16);
  final TextStyle regularStyle = TextStyle(
    color: clrs.blue_medium,
    fontFamily: "OpenSans",
    fontSize: 12,
  );
  final TextStyle decoratedRegularStyle = TextStyle(
      color: clrs.blue_medium,
      fontStyle: FontStyle.italic,
      fontFamily: "OpenSans",
      fontSize: 12);
  final TextStyle hintStyle = TextStyle(
      color: clrs.veryDark.withOpacity(0.7), fontFamily: "OpenSans", fontSize: 12,  );

  final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: clrs.blue_dark,
    foregroundColor: clrs.veryLight,
  );

  // Define shared BoxDecorations and other shared themes here
  final BoxDecoration constantBackgroundDecoration =
      BoxDecoration(color: clrs.background);
  final BoxDecoration gradientBackgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.white, clrs.blue_light],
      stops: [0.1, 0.9],
    ),
  );
  final BoxDecoration boxDecorationWithBackgroudnImage = BoxDecoration(
      color: clrs.blue_dark,
      image: const DecorationImage(
          fit: BoxFit.cover,
          opacity: 0.3,
          image: AssetImage(
            'assets/images/arabic.jpg',
          )));
  final BoxDecoration cardSectionDecoration = BoxDecoration(
      color: clrs.blue_light,
      border: Border.all(width: 3, color: clrs.blue_medium),
      borderRadius: const BorderRadius.all(Radius.circular(10)));
  final BoxDecoration cardBodyDecoration = BoxDecoration(
    color: clrs.blue_dark,
    border: Border.all(width: 3, color: clrs.veryLight),
    borderRadius: const BorderRadius.all(Radius.circular(10)),
  );
  final BoxDecoration textFieldDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: clrs.veryLight,
        blurRadius: 2.0,
        offset: Offset(0, 2),
      ),
    ],
  );
  final BoxDecoration profilePictureDecoration = BoxDecoration(
      color: clrs.blue_medium,
      shape: BoxShape.circle,
      border: Border.all(width: 3, color: clrs.blue_medium));
  final BoxDecoration navBarDecoration = BoxDecoration(
    color: clrs.blue_medium,
    // border: Border.all(width: 3, color: secondary),
    borderRadius: const BorderRadius.all(Radius.circular(5)),
  );

  @override
  AppTheme copyWith() => null!;

  @override
  AppTheme lerp(
          ThemeExtension<AppTheme>? other, double t) =>
      // ignore: null_check_always_fails
      other is! AppTheme ? this : AppTheme();

  @override
  String toString() => '';


  static ThemeData getTheme() => ThemeData(extensions: <ThemeExtension<dynamic>>[AppTheme()], useMaterial3: true);
}