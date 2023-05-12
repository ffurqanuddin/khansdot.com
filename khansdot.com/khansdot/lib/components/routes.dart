

import '../Pages/home_page.dart';
import '../Pages/splash_page.dart';

class Routes{
  static final routes = {
   home : (context) => const HomePage(),
    splash : (context) => const SplashPage(),
  };

  static String splash = "Splash Page";
  static String home = "Home Page";
}