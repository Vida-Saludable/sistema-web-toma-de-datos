// ignore_for_file: non_constant_identifier_names, prefer_null_aware_operators

import 'dart:convert';

TestRuffier testRuffierFromJson(String str) => TestRuffier.fromJson(json.decode(str));

String testRuffierToJson(TestRuffier data) => json.encode(data.toJson());

class TestRuffier {
  int? frecuencia_cardiaca_en_reposo;
  int? frecuencia_cardiaca_despues_de_45_segundos;
  int? frecuencia_cardiaca_1_minuto_despues;
  double? resultado_test_ruffier;
  DateTime? fecha;
  String? usuario;
  String? tipo;

  TestRuffier({
    this.frecuencia_cardiaca_en_reposo,
    this.frecuencia_cardiaca_despues_de_45_segundos,
    this.frecuencia_cardiaca_1_minuto_despues,
    this.resultado_test_ruffier,
    this.fecha,
    this.usuario,
    this.tipo
  });

  factory TestRuffier.fromJson(Map<String, dynamic> json) => TestRuffier(
        frecuencia_cardiaca_en_reposo: json['frecuencia_cardiaca_en_reposo'] as int?,
        frecuencia_cardiaca_despues_de_45_segundos: json['frecuencia_cardiaca_despues_de_45_segundos'] as int?,
        frecuencia_cardiaca_1_minuto_despues: json['frecuencia_cardiaca_1_minuto_despues'] as int?,
        resultado_test_ruffier: (json['resultado_test_ruffier'] is String)
            ? double.tryParse(json['resultado_test_ruffier'])
            : (json['resultado_test_ruffier'] as num?)?.toDouble(),
        fecha: DateTime.tryParse(json['fecha'] as String? ?? ''),
        usuario: json['usuario']?.toString(),
        tipo: json['tipo']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'frecuencia_cardiaca_en_reposo': frecuencia_cardiaca_en_reposo,
        'frecuencia_cardiaca_despues_de_45_segundos': frecuencia_cardiaca_despues_de_45_segundos,
        'frecuencia_cardiaca_1_minuto_despues': frecuencia_cardiaca_1_minuto_despues,
        'resultado_test_ruffier': resultado_test_ruffier,
        'fecha': fecha?.toIso8601String(), // Convierte a string en formato ISO
        'usuario': usuario,
        'tipo': tipo,
      };
}
