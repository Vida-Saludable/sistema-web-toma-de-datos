// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

DatosPersonales datosPersonalesFromJson(String str) => DatosPersonales.fromJson(json.decode(str));

String datosPersonalesToJson(DatosPersonales data) => json.encode(data.toJson());

class DatosPersonales {
  int? id;
  String? nombres_apellidos;
  String? sexo;
  int? edad;
  String? estado_civil;
  DateTime? fecha_nacimiento;
  String? telefono;
  String? grado_instruccion;
  String? procedencia;
  String? religion;
  DateTime? fecha;
  String? usuario;

  DatosPersonales({
    this.id,
    this.nombres_apellidos,
    this.sexo,
    this.edad,
    this.estado_civil,
    this.fecha_nacimiento,
    this.telefono,
    this.grado_instruccion,
    this.procedencia,
    this.religion,
    this.fecha,
    this.usuario,
  });

  factory DatosPersonales.fromJson(Map<String, dynamic> json) => DatosPersonales(
    id: json['id'] as int?,
    nombres_apellidos: json["nombres_apellidos"].toString(),
    sexo: json["sexo"].toString(),
    edad: json["edad"] as int?,
    estado_civil: json["estado_civil"].toString(),
    fecha_nacimiento: DateTime.tryParse(json['fecha_nacimiento'] as String? ?? ''),
    telefono: json["telefono"].toString(),
    grado_instruccion: json["grado_instruccion"].toString(),
    procedencia: json["procedencia"].toString(),
    religion: json["religion"].toString(),
    fecha: DateTime.tryParse(json['fecha'] as String? ?? ''),
    usuario: json["usuario"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nombres_apellidos": nombres_apellidos,
    "sexo": sexo,
    "edad": edad,
    "estado_civil": estado_civil,
    "fecha_nacimiento": fecha_nacimiento?.toIso8601String(),
    "telefono": telefono,
    "grado_instruccion": grado_instruccion,
    "procedencia": procedencia,
    "religion": religion,
    "fecha": fecha?.toIso8601String(),
    "usuario": usuario,
  };
}
