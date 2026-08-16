import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mi_primer_app/core/json.dart';
import 'package:mi_primer_app/features/prestamos/domain/prestamo.dart';
import 'package:mi_primer_app/features/prestamos/domain/prestamos_repository.dart';

typedef LectorDeAssets = Future<String> Function(String ruta);

class PrestamosLocales implements PrestamosRepository {
  PrestamosLocales({
    LectorDeAssets? lector,
    this.ruta = 'assets/data/prestamos.json',
  }) : _lector = lector ?? rootBundle.loadString;

  final LectorDeAssets _lector;
  final String ruta;
  List<Prestamo>? _cache;

  @override
  Future<List<Prestamo>> obtenerTodos() async {
    final guardado = _cache;

    if (guardado != null) return guardado;

    final raw = await _lector(ruta);
    final decoded = jsonDecode(raw);

    if (decoded is! List) {
      throw const CampoInvalido(
        '(raiz)',
        'el archivo debe contener una lista',
        null,
      );
    }

    return _cache = decoded
        .map((e) => Prestamo.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  Future<Prestamo?> obtenerPorId(String id) async {
    for (final prestamo in await obtenerTodos()) {
      if (prestamo.id == id) return prestamo;
    }
    return null;
  }

  @override
  Future<List<Prestamo>> obtenerPendientes() async {
    final todos = await obtenerTodos();
    return todos.where((p) => p.sePuedeCancelar).toList();
  }
}
