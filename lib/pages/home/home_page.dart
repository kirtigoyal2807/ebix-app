import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/localization.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.primary
            : Colors.blue.shade600,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.push('/settings'),
              tooltip: Localization.get('goToSettings'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Simple Header
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  Localization.get('homeWelcome'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        :Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Empty body space
          const Expanded(child: SizedBox.shrink()),
        ],
      ),
    );
  }
}
