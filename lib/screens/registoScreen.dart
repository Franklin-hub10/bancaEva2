import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistoScreen extends StatefulWidget {
  const RegistoScreen({super.key});
  @override
  _RegistoScreenState createState() => _RegistoScreenState();
}

class _RegistoScreenState extends State<RegistoScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _registrar() async {
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      String msg = 'Error desconocido';
      if (e.code == 'weak-password') msg = 'La contraseña es muy débil.';
      if (e.code == 'email-already-in-use') msg = 'Ese correo ya existe.';
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Registro fallido'),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 32),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _registrar,
                    child: const Text('Registrarse'),
                  ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('¿Ya tienes cuenta? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
