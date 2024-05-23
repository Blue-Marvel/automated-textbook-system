import 'package:automated_texbook_system/views/screens/home.dart';
import 'package:automated_texbook_system/views/screens/librarian_dashboard_screen.dart';
import 'package:automated_texbook_system/views/screens/library_admin_register.dart';
import 'package:automated_texbook_system/views/screens/register_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter routes = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: LibrarianRegister.routeName,
      builder: (context, state) => const LibrarianRegister(),
    ),
    GoRoute(
      path: LibrarianDashboardScreen.routeName,
      // path: '/',
      builder: (context, state) => const LibrarianDashboardScreen(),
    ),
    GoRoute(
      path: HomeScreen.routeName,
      // path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
