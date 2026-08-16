import 'package:mi_primer_app/core/json.dart';

sealed class EstadoPrestamo {
  const EstadoPrestamo();

  factory EstadoPrestamo.fromJson(Map<String, dynamic> json) {
    final tipo = leerTexto(json, 'tipo');
    return switch (tipo) {
      'solicitado' => Solicitado(leerFecha(json, 'solicitadoEn')),
      'entregado' => Entregado(
        leerFecha(json, 'entregadoEn'),
        leerTexto(json, 'entregadoPor'),
      ),
      'devuelto' => Devuelto(
        leerFecha(json, 'entregadoEn'),
        leerFecha(json, 'fechaDevolucionEsperada'),
        leerFecha(json, 'devueltoEn'),
        leerTexto(json, 'recibidoPor'),
      ),
      'vencido' => Vencido(
        leerFecha(json, 'fechaDevolucionEsperada'),
        leerFecha(json, 'devueltoEn'),
        leerTexto(json, 'motivo'),
      ),
      _ => throw CampoInvalido('estado.tipo', 'no es un estado conocido', tipo),
    };
  }

  Map<String, dynamic> toJson() => switch (this) {
    Solicitado(:final solicitadoEn) => {
      'tipo': 'solicitado',
      'solicitadoEn': solicitadoEn.toIso8601String(),
    },
    Entregado(:final entregadoEn, :final entregadoPor) => {
      'tipo': 'entregado',
      'entregadoEn': entregadoEn.toIso8601String(),
      'entregadoPor': entregadoPor,
    },
    Devuelto(
      :final entregadoEn,
      :final fechaDevolucionEsperada,
      :final devueltoEn,
      :final recibidoPor,
    ) =>
      {
        'tipo': 'devuelto',
        'entregadoEn': entregadoEn.toIso8601String(),
        'fechaDevolucionEsperada': fechaDevolucionEsperada.toIso8601String(),
        'devueltoEn': devueltoEn.toIso8601String(),
        'recibidoPor': recibidoPor,
      },
    Vencido(:final fechaDevolucionEsperada, :final devueltoEn, :final motivo) =>
      {
        'tipo': 'vencido',
        'fechaDevolucionEsperada': fechaDevolucionEsperada.toIso8601String(),
        'devueltoEn': devueltoEn.toIso8601String(),
        'motivo': motivo,
      },
  };

  bool get sePuedeCancelar => switch (this) {
    Solicitado() || Entregado() => true,
    Devuelto() || Vencido() => false,
  };

  String get etiqueta => switch (this) {
    Solicitado() => 'Solicitado',
    Entregado(:final entregadoPor) => 'Entregado · $entregadoPor',
    Devuelto() => 'Devuelto',
    Vencido(:final motivo) => 'Vencido: $motivo',
  };
}

final class Solicitado extends EstadoPrestamo {
  const Solicitado(this.solicitadoEn);
  final DateTime solicitadoEn;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Solicitado && other.solicitadoEn == solicitadoEn;

  @override
  int get hashCode => Object.hash(runtimeType, solicitadoEn);

  @override
  String toString() => 'Solicitado($solicitadoEn)';
}

final class Entregado extends EstadoPrestamo {
  const Entregado(this.entregadoEn, this.entregadoPor)
    : assert(entregadoPor != '');

  final DateTime entregadoEn;
  final String entregadoPor;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entregado &&
          other.entregadoEn == entregadoEn &&
          other.entregadoPor == entregadoPor;

  @override
  int get hashCode => Object.hash(runtimeType, entregadoEn, entregadoPor);

  @override
  String toString() => 'Entregado($entregadoEn, $entregadoPor)';
}

final class Devuelto extends EstadoPrestamo {
  const Devuelto(
    this.entregadoEn,
    this.fechaDevolucionEsperada,
    this.devueltoEn,
    this.recibidoPor,
  ) : assert(recibidoPor != '');

  final DateTime entregadoEn;
  final DateTime fechaDevolucionEsperada;
  final DateTime devueltoEn;
  final String recibidoPor;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Devuelto &&
          other.entregadoEn == entregadoEn &&
          other.fechaDevolucionEsperada == fechaDevolucionEsperada &&
          other.devueltoEn == devueltoEn &&
          other.recibidoPor == recibidoPor;

  @override
  int get hashCode => Object.hash(
    runtimeType,
    entregadoEn,
    fechaDevolucionEsperada,
    devueltoEn,
    recibidoPor,
  );

  @override
  String toString() =>
      'Devuelto($entregadoEn, $fechaDevolucionEsperada, $devueltoEn, $recibidoPor)';
}

final class Vencido extends EstadoPrestamo {
  const Vencido(this.fechaDevolucionEsperada, this.devueltoEn, this.motivo)
    : assert(motivo != '');

  final DateTime fechaDevolucionEsperada;
  final DateTime devueltoEn;
  final String motivo;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vencido &&
          other.fechaDevolucionEsperada == fechaDevolucionEsperada &&
          other.devueltoEn == devueltoEn &&
          other.motivo == motivo;

  @override
  int get hashCode =>
      Object.hash(runtimeType, fechaDevolucionEsperada, devueltoEn, motivo);

  @override
  String toString() =>
      'Vencido($fechaDevolucionEsperada, $devueltoEn, $motivo)';
}
