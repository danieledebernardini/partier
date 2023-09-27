import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:partier/page/apiTest_page/apiTest.dart';
import 'package:partier/page/bottomBar_widget/bottomBar_widget.dart';
import 'package:partier/page/create_page/create_page.dart';
import 'package:partier/page/login_page/login_page.dart';
import 'package:flutter/material.dart';

import '../page/discover_page/discover_page.dart';
import '../page/user_page/user_page.dart';
import '../services/auth_service.dart';

part 'app_router.g.dart';

@TypedShellRoute<BottomBarShellRoute>(
    routes: <TypedRoute<RouteData>>[
      TypedGoRoute<HomeRoute>(
        path: '/',
      ),
      TypedGoRoute<DiscoveryRoute>(
        path: '/discovery',
      ),
      TypedGoRoute<CreateEventRoute>(
        path: '/create-event',
      ),
      TypedGoRoute<UserEventRoute>(
        path: '/user-event',
      )
    ]
)

class BottomBarShellRoute extends ShellRouteData {
  const BottomBarShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return BottomBarWidget(child: navigator);
  }
}

@immutable
class HomeRoute extends GoRouteData {
  @override
  String? redirect(BuildContext context, GoRouterState state)
    => DiscoveryRoute().location;
}

@immutable
class DiscoveryRoute extends GoRouteData {
  @override
  Widget build(BuildContext context,  GoRouterState state) {
    return DiscoverPage();
  }
}

@immutable
class CreateEventRoute extends GoRouteData {
  @override
  Widget build(BuildContext context,  GoRouterState state) {
    return CreatePage();
    //return const ApiTestPage();
  }
}

@immutable
class UserEventRoute extends GoRouteData {
  @override
  Widget build(BuildContext context,  GoRouterState state) {
    return UserPage();
  }
}

@immutable
class EventDetailRoute extends GoRouteData {
  final String id;

  const EventDetailRoute({
    required this.id,
  });

  @override
  Widget build(BuildContext context,  GoRouterState state) {
    return CreatePage();
  }
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData {
  const LoginRoute({this.from});
  final String? from;

  @override
  Widget build(BuildContext context, GoRouterState state) => LoginPage(from: from);
}

final LoginInfo loginInfo = LoginInfo();
final router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: "/discovery",
  routes: $appRoutes,
  redirect: (context, state) {

    final bool loggedIn = loginInfo.loggedIn;

    // check just the subloc in case there are query parameters
    final String loginLoc = const LoginRoute().location;
    final bool goingToLogin = state.subloc == loginLoc;

    // the user is not logged in and not headed to /login, they need to login
    if (!loggedIn && !goingToLogin) {
      return LoginRoute(from: state.subloc).location;
    }

    // the user is logged in and headed to /login, no need to login again
    if (loggedIn && goingToLogin) {
      return DiscoveryRoute().location;
    }

    // no need to redirect at all
    return null;
  },
  // changes on the listenable will cause the router to refresh it's route
  refreshListenable: loginInfo,
);



/*
class AppRouter {
  GoRouter get router => _goRouter;

  late final GoRouter _goRouter = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        routes: <GoRoute>[
          GoRoute(
            path: "home",
            name: "HOME",
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: "events",
            name: "EVENTS",
            builder: (context, state) => const DiscoverPage(),
          ),
          GoRoute(
            path: "create-event",
            name: "CREATE-EVENT",
            builder: (context, state) => const ApiTestPage(),
            redirect: (context, state) => _redirect(context),
          ),
          GoRoute(
            path: "login",
            name: "LOGIN",
            builder: (context, state) => const LoginPage(),
          ),
        ],
        path: '/',
        builder: (context, GoRouterState state) =>
        const HomePage(),
      )
    ]
  );

  String? _redirect(context) {
      var isAuthenticated = checkIfLoggedIn();

      if (isAuthenticated == null) {
        return '/login';
      } else {
        return null; // return "null" to display the intended route without redirecting
      }
  }

}
 */