import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DepositoScreen extends StatefulWidget {
  const DepositoScreen({super.key});
  @override
  _DepositoScreenState createState() => _DepositoScreenState();
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
      appBar: AppBar(title: const Text('Depósitos')),
      body: FutureBuilder<List<dynamic>>(
        future: _futureDepositos,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final list = snap.data!;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, i) {
              final item = list[i] as Map<String, dynamic>;
              return ListTile(
                leading: Image.network(item['imagen'] ?? ''),
                title: Text('Monto: ${item['monto']}'),
                subtitle: Text('Banco: ${item['banco']}'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Detalle de Depósito'),
                      content: Text(
                        'Monto: ${item['monto']}\n'
                        'Banco: ${item['banco']}\n'
                        'ID: ${item['id'] ?? '-'}\n'
                        '${item['descripcion'] ?? ''}',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
