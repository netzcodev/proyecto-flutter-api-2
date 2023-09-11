import 'package:cars_app/config/router/app_router_notifier.dart';
import 'package:cars_app/features/auth/auth.dart';
import 'package:cars_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:cars_app/features/calendar/calendar.dart';
import 'package:cars_app/features/customers/customers.dart';
import 'package:cars_app/features/dashboard/dashboard.dart';
import 'package:cars_app/features/employees/employees.dart';
import 'package:cars_app/features/people/people.dart';
import 'package:cars_app/features/permissions/permissions.dart';
import 'package:cars_app/features/roles/reoles.dart';
import 'package:cars_app/features/schedules/schedules.dart';
import 'package:cars_app/features/services/services.dart';
import 'package:cars_app/features/users/users.dart';
import 'package:cars_app/features/vehicles/vehicles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      //* Primera Pantalla
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/customers',
        builder: (context, state) => const CustomersScreen(),
      ),
      GoRoute(
        path: '/employees',
        builder: (context, state) => const EmployeesScreen(),
      ),
      GoRoute(
        path: '/people',
        builder: (context, state) => const PeopleScreen(),
      ),
      GoRoute(
        path: '/people/:id',
        builder: (context, state) => PersonScreen(
          peopleId: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/permissions',
        builder: (context, state) => const PermissionsScreen(),
      ),
      GoRoute(
        path: '/roles',
        builder: (context, state) => const RolesScreen(),
      ),
      GoRoute(
        path: '/schedules',
        builder: (context, state) => const SchedulesScreen(),
      ),
      GoRoute(
        path: '/services',
        builder: (context, state) => const ServicesScreen(),
      ),
      GoRoute(
        path: '/users',
        builder: (context, state) => const UsersScreen(),
      ),
      GoRoute(
        path: '/vehicles',
        builder: (context, state) => const VehiclesScreen(),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
    redirect: (context, state) {
      final isGoingTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;

      if (isGoingTo == "/splash" && authStatus == AuthStatus.chenking) {
        return null;
      }

      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') return null;
        return '/login';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash') {
          return '/';
        }
      }

      return null;
    },
  );
});
