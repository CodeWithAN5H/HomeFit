import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Shown when the local database cannot be opened at startup.
///
/// There is no "retry" button on purpose: recovery needs a restart, and a fake
/// control would be worse than none.
class StartupFailureApp extends StatelessWidget {
  const StartupFailureApp({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomeFit',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'HomeFit could not start',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your local database could not be opened. Your data has not '
                  'been changed. Close and reopen the app; if this repeats, '
                  'device storage may be full.',
                ),
                const SizedBox(height: 16),
                Text(message, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
