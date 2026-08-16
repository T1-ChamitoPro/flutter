import 'package:flutter_test/flutter_test.dart';

import 'package:mi_primer_app/main.dart';

void main() {
  testWidgets('La aplicación de préstamos inicia correctamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MiApp());

    expect(find.text('Reportes'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byType(PantallaReportes), findsOneWidget);
  });
}
