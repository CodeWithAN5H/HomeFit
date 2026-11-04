import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Bottom navigation for the five primary destinations.
///
/// Secondary features live inside their section rather than adding tabs.
class HomeShell extends StatelessWidget {
  const HomeShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final bool onHomeTab = navigationShell.currentIndex == 0;
    return PopScope(
      // Back leaves a secondary tab for Home instead of closing the app; only
      // Home itself lets the system pop the activity.
      canPop: onHomeTab,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
        navigationShell.goBranch(0, initialLocation: true);
      },
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.fitness_center_outlined),
              selectedIcon: Icon(Icons.fitness_center),
              label: 'Workout',
            ),
            NavigationDestination(
              icon: Icon(Icons.restaurant_outlined),
              selectedIcon: Icon(Icons.restaurant),
              label: 'Nutrition',
            ),
            NavigationDestination(
              icon: Icon(Icons.insights_outlined),
              selectedIcon: Icon(Icons.insights),
              label: 'Progress',
            ),
            NavigationDestination(
              icon: Icon(Icons.psychology_outlined),
              selectedIcon: Icon(Icons.psychology),
              label: 'Coach',
            ),
          ],
        ),
      ),
    );
  }
}
