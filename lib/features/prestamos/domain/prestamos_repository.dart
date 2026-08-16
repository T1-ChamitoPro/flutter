import 'package:mi_primer_app/features/prestamos/domain/prestamo.dart';

abstract interface class PrestamosRepository {
  Future<List<Prestamo>> obtenerTodos();
  Future<Prestamo?> obtenerPorId(String id);
  Future<List<Prestamo>> obtenerPendientes();
}
