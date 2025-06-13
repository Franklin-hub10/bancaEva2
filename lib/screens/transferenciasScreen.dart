import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransferenciasScreen extends StatefulWidget {
  const TransferenciasScreen({super.key});
  @override
  _TransferenciasScreenState createState() => _TransferenciasScreenState();
}

class _TransferenciasScreenState extends State<TransferenciasScreen> {
  final _idCtrl = TextEditingController();
  final _nombreCtrl = TextEditingController();
  final _montoCtrl = TextEditingController();
  bool _saving = false;

  Future<void> _guardar() async {
    setState(() => _saving = true);
    try {
      await FirebaseFirestore.instance.collection('transferencias').add({
        'id': _idCtrl.text.trim(),
        'destinatario': _nombreCtrl.text.trim(),
        'monto': double.tryParse(_montoCtrl.text) ?? 0.0,
        'fecha': FieldValue.serverTimestamp(),
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Éxito'),
          content: const Text('Transferencia guardada.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      _idCtrl.clear();
      _nombreCtrl.clear();
      _montoCtrl.clear();
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text('No se pudo guardar: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _idCtrl.dispose();
    _nombreCtrl.dispose();
    _montoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transferencias')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _idCtrl,
              decoration:
                  const InputDecoration(labelText: 'ID de transferencia'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nombreCtrl,
              decoration:
                  const InputDecoration(labelText: 'Nombre destinatario'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _montoCtrl,
              decoration:
                  const InputDecoration(labelText: 'Monto a transferir'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            _saving
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _guardar,
                    child: const Text('Guardar'),
                  ),
          ],
        ),
      ),
    );
  }
}
