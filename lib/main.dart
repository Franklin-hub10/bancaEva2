import 'package:evaluacion2/screens/depositoScreen.dart';
import 'package:evaluacion2/screens/transferenciasScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/loginScreen.dart';
import 'screens/registoScreen.dart';
import 'screens/welcomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const BancoApp());
}

class BancoApp extends StatelessWidget {
  const BancoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BancoApp',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login':    (c) => const LoginScreen(),
        '/registro': (c) => const RegistoScreen(),
        '/welcome':  (c) => const WelcomeScreen(),
      },
    );
  }
}

/// Pantalla con Bottom Tab para Transferencias y Depósitos
class HomeTabsScreen extends StatefulWidget {
  final int initialIndex;
  const HomeTabsScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _HomeTabsScreenState createState() => _HomeTabsScreenState();
}

class _HomeTabsScreenState extends State<HomeTabsScreen> {
  late int _currentIndex;

  static const List<Widget> _pages = <Widget>[
    TransferenciasScreen(),
    DepositoScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.send),
            label: 'Transferir',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Depósitos',
          ),
        ],
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

