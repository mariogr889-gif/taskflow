import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';

// ---- Funciones de la Sesión 1 (simulan servidor y CPU) ----

Future<String> cargarPerfil() =>
    Future.delayed(const Duration(seconds: 2), () => 'Ana');

Future<int> cargarPendientes() =>
    Future.delayed(const Duration(seconds: 3), () => 7);

/// Cálculo deliberadamente pesado (CPU), sin ninguna espera.
int calculoPesado(int n) {
  var total = 0;
  for (var i = 0; i < n; i++) {
    total += i % 7;
  }
  return total;
}

// MAL: congela la interfaz durante todo el cálculo.
Future<int> sinIsolate() async => calculoPesado(400000000);

// BIEN: el cálculo corre en otro isolate.
Future<int> conIsolate() => Isolate.run(() => calculoPesado(400000000));

/// Laboratorio de la Semana 14: event loop, secuencial vs concurrente e
/// isolates. El indicador que gira siempre debe verse; si se detiene,
/// el hilo principal está bloqueado.
class LaboratorioAsyncScreen extends StatefulWidget {
  const LaboratorioAsyncScreen({super.key});

  @override
  State<LaboratorioAsyncScreen> createState() => _LaboratorioAsyncScreenState();
}

class _LaboratorioAsyncScreenState extends State<LaboratorioAsyncScreen> {
  List<String> _orden = [];
  String _tiempos = '';
  String _isolate = '';
  bool _ocupado = false;

  Future<void> _ordenEventLoop() async {
    final log = <String>[];
    log.add('A. inicio');
    Future(() => log.add('B. evento (cola de eventos)'));
    scheduleMicrotask(() => log.add('C. microtarea'));
    Future.delayed(Duration.zero, () => log.add('D. temporizador de 0 ms'));
    log.add('E. fin');
    await Future.delayed(const Duration(milliseconds: 50));
    if (!mounted) return;
    setState(() => _orden = log);
  }

  Future<void> _secuencialVsConcurrente() async {
    setState(() {
      _ocupado = true;
      _tiempos = 'Midiendo...';
    });
    final reloj = Stopwatch()..start();

    final perfil = await cargarPerfil();
    final pendientes = await cargarPendientes();
    final tSec = reloj.elapsed.inSeconds;

    reloj
      ..reset()
      ..start();
    final (perfil2, pendientes2) =
        await (cargarPerfil(), cargarPendientes()).wait;
    final tCon = reloj.elapsed.inSeconds;

    if (!mounted) return;
    setState(() {
      _ocupado = false;
      _tiempos = 'Secuencial: $tSec s -> $perfil, $pendientes\n'
          'Concurrente: $tCon s -> $perfil2, $pendientes2';
    });
  }

  Future<void> _medir(Future<int> Function() trabajo, String nombre) async {
    setState(() {
      _ocupado = true;
      _isolate = '$nombre: calculando...';
    });
    // Deja que Flutter dibuje el mensaje antes de empezar el cálculo.
    await Future.delayed(const Duration(milliseconds: 100));
    final reloj = Stopwatch()..start();
    final resultado = await trabajo();
    if (!mounted) return;
    setState(() {
      _ocupado = false;
      _isolate = '$nombre: $resultado en ${reloj.elapsed.inMilliseconds} ms';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laboratorio async')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(child: CircularProgressIndicator()),
          const SizedBox(height: 4),
          const Center(
            child: Text('Si este indicador se detiene, el hilo está bloqueado.',
                textAlign: TextAlign.center),
          ),
          const SizedBox(height: 20),
          Text('1. Event loop', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          FilledButton(
              onPressed: _ordenEventLoop, child: const Text('Ver orden')),
          if (_orden.isNotEmpty) ...[
            const SizedBox(height: 8),
            for (final linea in _orden) Text(linea),
          ],
          const SizedBox(height: 24),
          Text('2. Secuencial vs concurrente (≈ 8 s)',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _ocupado ? null : _secuencialVsConcurrente,
            child: const Text('Medir con Stopwatch'),
          ),
          if (_tiempos.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(_tiempos),
          ],
          const SizedBox(height: 24),
          Text('3. Isolates (cálculo pesado)',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          FilledButton(
            onPressed:
                _ocupado ? null : () => _medir(sinIsolate, 'Sin isolate'),
            child: const Text('Sin isolate (congela)'),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed:
                _ocupado ? null : () => _medir(conIsolate, 'Con isolate'),
            child: const Text('Con isolate (no congela)'),
          ),
          if (_isolate.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(_isolate),
          ],
        ],
      ),
    );
  }
}
