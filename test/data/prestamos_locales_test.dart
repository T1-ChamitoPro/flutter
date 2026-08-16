import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mi_primer_app/core/json.dart';
import 'package:mi_primer_app/features/prestamos/data/prestamos_locales.dart';

const _json = '''
[
  {
    "id": "prest-001",
    "titulo": "Préstamo de proyector para sustentación",
    "descripcion": "Necesito el proyector para la sustentación del proyecto de grado.",
    "estudiante": {
      "nombre": "Valentina Ríos Mendoza",
      "codigo": "20231456"
    },
    "equipo": {
      "marca": "Epson",
      "modelo": "PowerLite X49",
      "id": "eq-proy-12"
    },
    "creadoEn": "2026-08-12T15:40:00Z",
    "estado": {
      "tipo": "solicitado",
      "solicitadoEn": "2026-08-12T15:40:00Z"
    },
    "adjuntos": []
  },
  {
    "id": "prest-002",
    "titulo": "Cámara para reportaje",
    "descripcion": "Cámara para el semillero de periodismo.",
    "estudiante": {
      "nombre": "Andrés Felipe Castro",
      "codigo": "20220891"
    },
    "equipo": {
      "marca": "Canon",
      "modelo": "EOS R50",
      "id": "eq-cam-05"
    },
    "creadoEn": "2026-08-08T11:15:00Z",
    "estado": {
      "tipo": "entregado",
      "entregadoEn": "2026-08-08T14:30:00Z",
      "entregadoPor": "tec-04"
    }
  },
  {
    "id": "prest-003",
    "titulo": "Micrófono devuelto tarde",
    "descripcion": "Se devolvió con retraso.",
    "estudiante": {
      "nombre": "Camila Andrea Vargas",
      "codigo": "20210934"
    },
    "equipo": {
      "marca": "Shure",
      "modelo": "SM58",
      "id": "eq-mic-03"
    },
    "creadoEn": "2026-08-01T09:50:00Z",
    "estado": {
      "tipo": "vencido",
      "fechaDevolucionEsperada": "2026-08-04T17:00:00Z",
      "devueltoEn": "2026-08-06T12:45:00Z",
      "motivo": "Devolución con 2 días de retraso"
    }
  }
]
''';

void main() {
  test('lee la lista completa del archivo', () async {
    final repo = PrestamosLocales(lector: (_) async => _json);
    expect((await repo.obtenerTodos()).length, 3);
  });

  test('busca por id y devuelve null cuando no está', () async {
    final repo = PrestamosLocales(lector: (_) async => _json);

    expect(
      (await repo.obtenerPorId('prest-001'))?.titulo,
      'Préstamo de proyector para sustentación',
    );
    expect(await repo.obtenerPorId('no-existe'), isNull);
  });

  test('un archivo que no es una lista se rechaza', () async {
    final repo = PrestamosLocales(lector: (_) async => '{"a": 1}');
    expect(repo.obtenerTodos(), throwsA(isA<CampoInvalido>()));
  });

  test('obtenerPendientes solo devuelve los que se pueden cancelar', () async {
    final repo = PrestamosLocales(lector: (_) async => _json);
    final pendientes = await repo.obtenerPendientes();

    // prest-001 (solicitado) y prest-002 (entregado) → se pueden cancelar
    // prest-003 (vencido) → no
    expect(pendientes.length, 2);
    expect(pendientes.every((p) => p.sePuedeCancelar), isTrue);
  });

  test(
    'el asset declarado en pubspec existe y el modelo lo entiende',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final repo = PrestamosLocales(lector: rootBundle.loadString);
      expect((await repo.obtenerTodos()).length, greaterThanOrEqualTo(3));
    },
  );
}
