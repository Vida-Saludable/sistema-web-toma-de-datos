// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

DatosHabitosAlimentacion datosHabitosAlimentacionFromJson(String str) => DatosHabitosAlimentacion.fromJson(json.decode(str));

String datosHabitosAlimentacionToJson(DatosHabitosAlimentacion data) => json.encode(data.toJson());

class DatosHabitosAlimentacion {
  int? id;
  int? consumo_3_comidas_horario_fijo;
  int? consumo_5_porciones_frutas_verduras;
  int? consumo_3_porciones_proteinas;
  int? ingiero_otros_alimentos;
  int? consumo_carbohidratos;
  int? consumo_alimentos_fritos;
  int? consumo_alimentos_hechos_en_casa;
  int? consumo_liquidos_mientras_como;
  DateTime? fecha;
  String? tipo;
  String? usuario;

  DatosHabitosAlimentacion({
    this.id,
    this.consumo_3_comidas_horario_fijo,
    this.consumo_5_porciones_frutas_verduras,
    this.consumo_3_porciones_proteinas,
    this.ingiero_otros_alimentos,
    this.consumo_carbohidratos,
    this.consumo_alimentos_fritos,
    this.consumo_alimentos_hechos_en_casa,
    this.consumo_liquidos_mientras_como,
    this.fecha,
    this.tipo,
    this.usuario,
  });

  factory DatosHabitosAlimentacion.fromJson(Map<String, dynamic> json) => DatosHabitosAlimentacion(
    id: json['id'] as int?,
    consumo_3_comidas_horario_fijo: json['consumo_3_comidas_horario_fijo'] as int?,
    consumo_5_porciones_frutas_verduras: json['consumo_5_porciones_frutas_verduras'] as int?,
    consumo_3_porciones_proteinas: json['consumo_3_porciones_proteinas'] as int?,
    ingiero_otros_alimentos: json['ingiero_otros_alimentos'] as int?,
    consumo_carbohidratos: json['consumo_carbohidratos'] as int?,
    consumo_alimentos_fritos: json['consumo_alimentos_fritos'] as int?,
    consumo_alimentos_hechos_en_casa: json['consumo_alimentos_hechos_en_casa'] as int?,
    consumo_liquidos_mientras_como: json['consumo_liquidos_mientras_como'] as int?,
    fecha: DateTime.tryParse(json['fecha'] as String? ?? ''),
    tipo: json["tipo"].toString(),
    usuario: json["usuario"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "consumo_3_comidas_horario_fijo": consumo_3_comidas_horario_fijo,
    "consumo_5_porciones_frutas_verduras": consumo_5_porciones_frutas_verduras,
    "consumo_3_porciones_proteinas": consumo_3_porciones_proteinas,
    "ingiero_otros_alimentos": ingiero_otros_alimentos,
    "consumo_carbohidratos": consumo_carbohidratos,
    "consumo_alimentos_fritos": consumo_alimentos_fritos,
    "consumo_alimentos_hechos_en_casa": consumo_alimentos_hechos_en_casa,
    "consumo_liquidos_mientras_como": consumo_liquidos_mientras_como,
    "fecha": fecha?.toIso8601String(),
    "tipo": tipo,
    "usuario": usuario,
  };
}
