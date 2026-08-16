import 'package:mi_primer_app/core/json.dart';

class Equipo {
  const Equipo({
    required this.marca,
    required this.modelo,
    required this.numeroSerie,
  }) : assert(marca != ''),
       assert(modelo != ''),
       assert(numeroSerie != '');

  factory Equipo.fromJson(Map<String, dynamic> json) => Equipo(
    marca: leerTexto(json, 'marca'),
    modelo: leerTexto(json, 'modelo'),
    numeroSerie: leerTexto(json, 'numeroSerie'),
  );

  final String marca;
  final String modelo;
  final String numeroSerie;

  Map<String, dynamic> toJson() => {
    'marca': marca,
    'modelo': modelo,
    'numeroSerie': numeroSerie,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Equipo &&
          other.marca == marca &&
          other.modelo == modelo &&
          other.numeroSerie == numeroSerie;

  @override
  int get hashCode => Object.hash(marca, modelo, numeroSerie);

  @override
  String toString() => 'Equipo($marca $modelo - $numeroSerie)';
}
