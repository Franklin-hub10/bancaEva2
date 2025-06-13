import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistoScreen extends StatefulWidget {
  const RegistoScreen({super.key});
  @override
  State<RegistoScreen> createState() => _RegistoScreenState();
}

class _RegistoScreenState extends State<RegistoScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool  _loading   = false;

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
      if (e.code == 'weak-password')        msg = 'La contraseña es muy débil.';
      else if (e.code == 'email-already-in-use') msg = 'Ese correo ya existe.';
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.black,
          title: const Text('Registro fallido', style: TextStyle(color: Colors.white)),
          content: Text(msg, style: const TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK', style: TextStyle(color: Colors.orange)),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Encabezado con logo y título
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/bank_icon_1.png',
                    width: 48,
                    height: 48,
                  ),
                  const Spacer(),
                  const Text(
                    'Registro',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Espacio antes de los campos
            const SizedBox(height: 40),

            // Campos centrados
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Correo
                    TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Correo',
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white38),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                        prefixIcon: const Icon(Icons.email, color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Contraseña
                    TextField(
                      controller: _passCtrl,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white38),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Botón Registrarse
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: _loading
                          ? const Center(
                              child: CircularProgressIndicator(color: Colors.orange),
                            )
                          : ElevatedButton(
                              onPressed: _registrar,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Registrarse',
                                style: TextStyle(color: Colors.black, fontSize: 18),
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),

                    // Enlace a Login
                    TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      child: const Text(
                        '¿Ya tienes cuenta? Login',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
