import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_primer_app/core/json.dart';
import 'package:mi_primer_app/features/prestamos/domain/estado_prestamo.dart';
import 'package:mi_primer_app/features/prestamos/domain/prestamo.dart';
import 'package:mi_primer_app/features/prestamos/domain/equipo.dart'; // contiene la clase Equipo

Prestamo ejemplo({EstadoPrestamo? estado, List<String>? adjuntos}) => Prestamo(
  id: 'prest-001',
  titulo: 'Préstamo de proyector para sustentación',
  descripcion:
      'Necesito el proyector para la sustentación del proyecto de grado.',
  nombreEstudiante: 'Valentina Ríos Mendoza',
  codigoEstudiante: '20231456',
  equipo: const Equipo(
    marca: 'Epson',
    modelo: 'PowerLite X49',
    numeroSerie: 'eq-proy-12',
  ),
  creadoEn: DateTime.utc(2026, 8, 12, 15, 40),
  estado: estado ?? Solicitado(DateTime.utc(2026, 8, 12, 15, 40)),
  adjuntos: adjuntos ?? const <String>[],
);

void main() {
  group('serialización', () {
    test('un préstamo sobrevive la ida y vuelta a JSON sin perder nada', () {
      final original = ejemplo(
        estado: Entregado(DateTime.utc(2026, 8, 12, 16, 10), 'tec-04'),
        adjuntos: const ['https://ejemplo.co/f/autorizacion.pdf'],
      );

      final texto = jsonEncode(original.toJson());
      final vuelta = Prestamo.fromJson(
        jsonDecode(texto) as Map<String, dynamic>,
      );

      expect(vuelta, equals(original));
    });

    test('un préstamo sin la clave adjuntos se lee con la lista vacía', () {
      final json = ejemplo().toJson()..remove('adjuntos');
      expect(Prestamo.fromJson(json).adjuntos, isEmpty);
    });

    test('un préstamo sin título dice QUÉ campo falló, no solo que falló', () {
      final json = ejemplo().toJson()..remove('titulo');
      expect(
        () => Prestamo.fromJson(json),
        throwsA(isA<CampoInvalido>().having((e) => e.campo, 'campo', 'titulo')),
      );
    });

    test('una fecha que no es ISO 8601 se rechaza', () {
      final json = ejemplo().toJson()..['creadoEn'] = '12 de agosto';
      expect(() => Prestamo.fromJson(json), throwsA(isA<CampoInvalido>()));
    });

    test('la hora se conserva en UTC y no se corre cinco horas', () {
      final json = ejemplo().toJson();
      expect(json['creadoEn'], '2026-08-12T15:40:00.000Z');
    });
  });

  group('igualdad', () {
    test('dos préstamos con los mismos datos son iguales', () {
      expect(ejemplo(), equals(ejemplo()));
    });

    test('dos préstamos con los mismos datos comparten hashCode', () {
      // Sin esto, meterlos en un Set daría dos elementos donde debería haber uno.
      expect(ejemplo().hashCode, equals(ejemplo().hashCode));
      expect({ejemplo(), ejemplo()}.length, 1);
    });

    test('dos préstamos con adjuntos distintos NO son iguales', () {
      expect(
        ejemplo(adjuntos: const ['a']),
        isNot(equals(ejemplo(adjuntos: const ['b']))),
      );
    });

    test('copyWith cambia solo lo que se le pasa', () {
      final original = ejemplo();
      final copia = original.copyWith(titulo: 'Otro título');

      expect(copia.titulo, 'Otro título');
      expect(copia.id, original.id);
      expect(copia.creadoEn, original.creadoEn);
      expect(copia.nombreEstudiante, original.nombreEstudiante);
    });
  });

  group('reglas de negocio', () {
    test('un préstamo entregado sí se puede cancelar', () {
      expect(
        ejemplo(
          estado: Entregado(DateTime.utc(2026, 8, 12, 16, 10), 'tec-04'),
        ).sePuedeCancelar,
        isTrue,
      );
    });

    test('un préstamo ya devuelto NO se puede cancelar', () {
      expect(
        ejemplo(
          estado: Devuelto(
            DateTime.utc(2026, 8, 12, 16, 10),
            DateTime.utc(2026, 8, 15, 18, 0),
            DateTime.utc(2026, 8, 14, 17, 30),
            'tec-02',
          ),
        ).sePuedeCancelar,
        isFalse,
      );
    });

    test(
      'un préstamo de hace 10 días está atrasado si aún se puede cancelar',
      () {
        final ahora = DateTime.utc(2026, 8, 22);
        expect(ejemplo().estaAtrasado(ahora), isTrue);
      },
    );
  });
}
