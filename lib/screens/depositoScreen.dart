import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DepositoScreen extends StatefulWidget {
  const DepositoScreen({super.key});
  @override
  State<DepositoScreen> createState() => _DepositoScreenState();
}

class _DepositoScreenState extends State<DepositoScreen> {
  late Future<List<dynamic>> _futureDepositos;

  @override
  void initState() {
    super.initState();
    _futureDepositos = fetchDepositos();
  }

  Future<List<dynamic>> fetchDepositos() async {
    final url = Uri.parse(
      'https://jritsqmet.github.io/web-api/depositos.json',
    );
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      return jsonDecode(resp.body) as List<dynamic>;
    } else {
      throw Exception('Error al cargar depósitos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo con imagen anterior
          Image.asset(
            'assets/images/bank_icon_4.png',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.7)),
          SafeArea(
            child: Column(
              children: [
                // AppBar manual
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Depósitos',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: _futureDepositos,
                    builder: (context, snap) {
                      if (snap.connectionState != ConnectionState.done) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.orange),
                        );
                      }
                      if (snap.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snap.error}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        );
                      }
                      final list = snap.data!;
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: list.length,
                        itemBuilder: (context, i) {
                          final item = list[i] as Map<String, dynamic>;
                          return Card(
                            color: Colors.black.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item['imagen'] ?? '',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                'Monto: ${item['monto']}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'Banco: ${item['banco']}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    backgroundColor: Colors.black,
                                    title: const Text(
                                      'Detalle de Depósito',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    content: Text(
                                      'Monto: ${item['monto']}\n'
                                      'Banco: ${item['banco']}\n'
                                      'ID: ${item['id'] ?? '-'}\n'
                                      '${item['descripcion'] ?? ''}',
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(color: Colors.orange),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
