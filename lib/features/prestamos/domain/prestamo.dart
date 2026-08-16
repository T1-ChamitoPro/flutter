import 'package:mi_primer_app/core/comparaciones.dart';
import 'package:mi_primer_app/core/json.dart';
import 'package:mi_primer_app/features/prestamos/domain/estado_prestamo.dart';
import 'package:mi_primer_app/features/prestamos/domain/equipo.dart'; // tu clase Equipo

// Un préstamo de equipo audiovisual.
class Prestamo {
  const Prestamo({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.nombreEstudiante,
    required this.codigoEstudiante,
    required this.equipo,
    required this.creadoEn,
    required this.estado,
    this.adjuntos = const <String>[],
  });

  factory Prestamo.fromJson(Map<String, dynamic> json) {
    final estudiante = leerMapa(json, 'estudiante');
    final equipoJson = leerMapa(json, 'equipo');

    return Prestamo(
      id: leerTexto(json, 'id'),
      titulo: leerTexto(json, 'titulo'),
      descripcion: leerTexto(json, 'descripcion'),
      nombreEstudiante: leerTexto(estudiante, 'nombre'),
      codigoEstudiante: leerTexto(estudiante, 'codigo'),
      equipo: Equipo(
        marca: leerTexto(equipoJson, 'marca'),
        modelo: leerTexto(equipoJson, 'modelo'),
        numeroSerie: leerTexto(equipoJson, 'id'),
      ),
      creadoEn: leerFecha(json, 'creadoEn'),
      estado: EstadoPrestamo.fromJson(leerMapa(json, 'estado')),
      adjuntos: leerTextos(json, 'adjuntos'),
    );
  }

  final String id;
  final String titulo;
  final String descripcion;
  final String nombreEstudiante;
  final String codigoEstudiante;
  final Equipo equipo;
  final DateTime creadoEn;
  final EstadoPrestamo estado;
  final List<String> adjuntos;

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'descripcion': descripcion,
    'estudiante': {'nombre': nombreEstudiante, 'codigo': codigoEstudiante},
    'equipo': {
      'marca': equipo.marca,
      'modelo': equipo.modelo,
      'id': equipo.numeroSerie,
    },
    'creadoEn': creadoEn.toUtc().toIso8601String(),
    'estado': estado.toJson(),
    'adjuntos': adjuntos,
  };

  // ── Reglas de negocio ───────────────────────────────────────────────────

  bool get tieneAdjuntos => adjuntos.isNotEmpty;

  bool get sePuedeCancelar => estado.sePuedeCancelar;

  Duration antiguedad(DateTime ahora) => ahora.difference(creadoEn);

  bool estaAtrasado(DateTime ahora) =>
      antiguedad(ahora) > const Duration(days: 7) && sePuedeCancelar;

  // ── Copia ───────────────────────────────────────────────────────────────
  Prestamo copyWith({
    String? titulo,
    String? descripcion,
    String? nombreEstudiante,
    String? codigoEstudiante,
    Equipo? equipo,
    EstadoPrestamo? estado,
    List<String>? adjuntos,
  }) => Prestamo(
    id: id,
    titulo: titulo ?? this.titulo,
    descripcion: descripcion ?? this.descripcion,
    nombreEstudiante: nombreEstudiante ?? this.nombreEstudiante,
    codigoEstudiante: codigoEstudiante ?? this.codigoEstudiante,
    equipo: equipo ?? this.equipo,
    creadoEn: creadoEn,
    estado: estado ?? this.estado,
    adjuntos: adjuntos ?? this.adjuntos,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Prestamo &&
          other.id == id &&
          other.titulo == titulo &&
          other.descripcion == descripcion &&
          other.nombreEstudiante == nombreEstudiante &&
          other.codigoEstudiante == codigoEstudiante &&
          other.equipo == equipo &&
          other.creadoEn == creadoEn &&
          other.estado == estado &&
          listasIguales(other.adjuntos, adjuntos);

  @override
  int get hashCode => Object.hash(
    id,
    titulo,
    descripcion,
    nombreEstudiante,
    codigoEstudiante,
    equipo,
    creadoEn,
    estado,
    Object.hashAll(adjuntos),
  );

  @override
  String toString() => 'Prestamo($id, $titulo, ${estado.etiqueta})';
}
