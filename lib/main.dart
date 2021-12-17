import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/authentication/auth.dart';
import 'screens/bottom_nav_screen/bottom_nav_bar.dart';
import 'widgets/loading/feed_loading.dart';
import 'widgets/loading/loading_profile.dart';
import 'widgets/loading/search_page_loading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefrences = await SharedPreferences.getInstance();
  String? uid = prefrences.getString('uid');
  var dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  await Hive.openBox('notifications');
  await Hive.openBox('recents');
  runApp(MyApp(
    uid: uid,
  ));
}

class MyApp extends StatelessWidget {
  final String? uid;
  const MyApp({
    Key? key,
    this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor:
            const Color.fromRGBO(28, 24, 47, 1), // navigation bar color
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.grey.shade900,
      ),
    );
    return MaterialApp(
        title: 'Projectfolio',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromRGBO(28, 24, 47, 1),
          primarySwatch: Colors.blue,
          splashColor: Colors.blueAccent,
          highlightColor: Colors.transparent,
          fontFamily: 'BespokeSans-Medium',
          primaryColor: Colors.blue,
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              side: MaterialStateProperty.all<BorderSide>(
                BorderSide(
                  color: Colors.white.withOpacity(.6),
                  width: 1,
                ),
              ),
            ),
          ),
          textTheme: const TextTheme(
            headline1: TextStyle(
              fontFamily: 'BespokeSans-Medium',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            bodyText1: TextStyle(
              fontFamily: 'BespokeSans-Medium',
              fontSize: 15,
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.w400,
            ),
          ),
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Colors.blue,
            circularTrackColor: Colors.white,
            linearTrackColor: Colors.black12,
            refreshBackgroundColor: Color.fromRGBO(28, 24, 47, 1),
            linearMinHeight: .5,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 20,
            ),
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(.7),
            ),
            fillColor: Colors.white.withOpacity(.1),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade600,
                width: .5,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade600,
                width: .5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade600,
                width: .5,
              ),
            ),
          ),
        ),
        builder: (context, child) {
          return MediaQuery(
            child: ScrollConfiguration(
              behavior: NoGlowBehavior(),
              child: child!,
            ),
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        },
        home: uid == null
            ? const LoginPage()
            : BottomNavBar(
                uid: uid!,
              ));
  }
}

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
