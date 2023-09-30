import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:partier/routing/app_router.dart';
import 'package:partier/services/auth_service.dart';

class BottomBarWidget extends StatelessWidget {
  // Class variables
  final Widget child;

  const BottomBarWidget({super.key, required this.child});

  /// Returns current page index.
  /// HAS TO BE FIXED
  int getCurrentIndex(BuildContext context) {
    int out;
    final String location = GoRouter.of(context).location;

    if(location.startsWith('/discovery')) {
      out = 0;
    } else if(location.startsWith('/create-event')) {
      out = 1;
    } else if(location.startsWith('/user-event')) {
      out = 2;
    } else {
        out = 3;
    }

    return out;
  }

  /// Defines behaviour of navigation bar upon tap.
  /// TO BE IMPLEMENTED
  /*
  void _onItemTapped(int index) async {
    // ...
  }
   */

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = getCurrentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Discovery',
            tooltip: 'Discover page',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Creator',
            tooltip: 'Create event',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Saved',
            tooltip: 'User page',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (int index) async {
          switch (index) {
            case 0:
              DiscoveryRoute().go(context);
              break;
            case 1:
              CreateEventRoute().go(context);
              break;
            case 2:
              UserEventRoute().go(context);
              break;
            case 3:
              await context.read<LoginInfo>().signOut();

              if (!context.mounted) return;
              context.go("/");
              break;
          }
        },
      ),
    );
  }
}