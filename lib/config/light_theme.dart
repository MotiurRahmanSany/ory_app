part of 'theme_provider.dart';


final _lightTheme = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xff001F3F),
    brightness: Brightness.light,
  ),
  useMaterial3: true,
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: EdgeInsets.all(16.0),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: const Color(0xff001F3F),
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: const Color(0xff001F3F),
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),

    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: const Color(0xff001F3F),
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Color(0xff001F3F),
      padding: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      minimumSize: Size(double.infinity, 48.0),
      textStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

);