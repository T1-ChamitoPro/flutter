import 'package:flutter/material.dart';

import 'package:mi_primer_app/features/prestamos/data/prestamos_locales.dart';

import 'package:mi_primer_app/features/prestamos/domain/prestamo.dart';

void main() => runApp(const MiApp());

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Reportes',

    theme: ThemeData(colorSchemeSeed: Colors.indigo),

    home: const PantallaReportes(),
  );
}

class PantallaReportes extends StatefulWidget {
  const PantallaReportes({super.key});

  @override
  State<PantallaReportes> createState() => _PantallaReportesState();
}

class _PantallaReportesState extends State<PantallaReportes> {
  // `late final` en el campo: el Future se crea UNA vez.

  // Crearlo dentro de build() lo relanza en cada reconstrucción, y esa es la

  // causa del 90 % de los FutureBuilder que parpadean sin parar.

  late final Future<List<Prestamo>> _prestamos = PrestamosLocales()
      .obtenerTodos();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Reportes')),

    body: FutureBuilder<List<Prestamo>>(
      future: _prestamos,

      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          // El mensaje de CampoInvalido dice el campo. Aquí se ve por qué

          // valió la pena escribirlo.

          return Center(child: Text('No se pudo leer:\n${snapshot.error}'));
        }

        final prestamos = snapshot.data ?? const <Prestamo>[];

        return ListView.separated(
          itemCount: prestamos.length,

          separatorBuilder: (_, _) => const Divider(height: 1),

          itemBuilder: (context, i) {
            final prestamo = prestamos[i];

            return ListTile(
              title: Text(prestamo.titulo),

              subtitle: Text(
                '${prestamo.nombreEstudiante} · ${prestamo.equipo.numeroSerie}',
              ),

              trailing: prestamo.estado.sePuedeCancelar
                  ? const Icon(Icons.photo_outlined)
                  : null,
            );
          },
        );
      },
    ),
  );
}
