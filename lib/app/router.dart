import 'package:go_router/go_router.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/access_choice_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/accessibility/accessibility_setup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/locations/places_screen.dart';
import '../screens/locations/place_detail_screen.dart';
import '../screens/routes/routes_screen.dart';
import '../screens/reports/report_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../models/place.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: '/access', builder: (context, state) => const AccessChoiceScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/accessibility', builder: (context, state) => const AccessibilitySetupScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/places', builder: (context, state) => const PlacesScreen()),
    GoRoute(
      path: '/place/:id',
      builder: (context, state) => PlaceDetailScreen(
        place: state.extra is Place ? state.extra as Place : null,
      ),
    ),
    GoRoute(path: '/routes', builder: (context, state) => const RoutesScreen()),
    GoRoute(path: '/report', builder: (context, state) => const ReportScreen()),
    GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
  ],
);
