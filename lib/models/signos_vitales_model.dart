// ignore_for_file: non_constant_identifier_names, prefer_null_aware_operators

import 'dart:convert';

SignosVitales signosVitalesFromJson(String str) => SignosVitales.fromJson(json.decode(str));

String signosVitalesToJson(SignosVitales data) => json.encode(data.toJson());

class SignosVitales {
  int? presion_sistolica;
  int? presion_diastolica;
  int? frecuencia_cardiaca;
  int? frecuencia_respiratoria;
  double? temperatura;
  int? saturacion_oxigeno;
  DateTime? fecha;
  String? tipo;
  String? usuario;

  SignosVitales({
    this.presion_sistolica,
    this.presion_diastolica,
    this.frecuencia_cardiaca,
    this.frecuencia_respiratoria,
    this.temperatura,
    this.saturacion_oxigeno,
    this.fecha,
    this.tipo,
    this.usuario,
  });

  factory SignosVitales.fromJson(Map<String, dynamic> json) => SignosVitales(
        presion_sistolica: json['presion_sistolica'] as int?,
        presion_diastolica: json['presion_diastolica'] as int?,
        frecuencia_cardiaca: json['frecuencia_cardiaca'] as int?,
        frecuencia_respiratoria: json['frecuencia_respiratoria'] as int?,
        temperatura: (json['temperatura'] is String)
            ? double.tryParse(json['temperatura'])
            : (json['temperatura'] as num?)?.toDouble(),
        saturacion_oxigeno: json['saturacion_oxigeno'] as int?,
        fecha: DateTime.tryParse(json['fecha'] as String? ?? ''),
        tipo: json["tipo"].toString(),
        usuario: json["usuario"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "presion_sistolica": presion_sistolica,
        "presion_diastolica": presion_diastolica,
        "frecuencia_cardiaca": frecuencia_cardiaca,
        "frecuencia_respiratoria": frecuencia_respiratoria,
        "temperatura": temperatura,
        "saturacion_oxigeno": saturacion_oxigeno,
        "fecha": fecha?.toIso8601String(),
        "tipo": tipo,
        "usuario": usuario,
      };
}
