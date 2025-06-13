import 'package:flutter/material.dart';
import '../main.dart'; // para HomeTabsScreen

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenido')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeTabsScreen(initialIndex: 0),
                  ),
                );
              },
              child: const Text('Transferencias'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeTabsScreen(initialIndex: 1),
                  ),
                );
              },
              child: const Text('Depósitos'),
            ),
            const SizedBox(height: 32),
            const Text('Desarrollado por: Fabo'),
            const Text('GitHub: @TuUsuario'),
          ],
        ),
      ),
    );
  }
}
