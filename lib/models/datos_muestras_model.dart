// ignore_for_file: non_constant_identifier_names, prefer_null_aware_operators

import 'dart:convert';

DatosMuestras datosMuestrasFromJson(String str) => DatosMuestras.fromJson(json.decode(str));

String datosMuestrasToJson(DatosMuestras data) => json.encode(data.toJson());

class DatosMuestras {
  double? colesterol_total;
  double? colesterol_hdl;
  double? colesterol_ldl;
  double? trigliceridos;
  double? glucosa;
  double? glicemia_basal;
  DateTime? fecha;
  String? tipo;
  String? usuario;

  DatosMuestras({
    this.colesterol_total,
    this.colesterol_hdl,
    this.colesterol_ldl,
    this.trigliceridos,
    this.glucosa,
    this.glicemia_basal,
    this.fecha,
    this.tipo,
    this.usuario,
  });

  factory DatosMuestras.fromJson(Map<String, dynamic> json) => DatosMuestras(
    colesterol_total: (json['colesterol_total'] is String)
            ? double.tryParse(json['colesterol_total'])
            : (json['colesterol_total'] as num?)?.toDouble(),
    colesterol_hdl: (json['colesterol_hdl'] is String)
            ? double.tryParse(json['colesterol_hdl'])
            : (json['colesterol_hdl'] as num?)?.toDouble(),
    colesterol_ldl: (json['colesterol_ldl'] is String)
            ? double.tryParse(json['colesterol_ldl'])
            : (json['colesterol_ldl'] as num?)?.toDouble(),
    trigliceridos: (json['trigliceridos'] is String)
            ? double.tryParse(json['trigliceridos'])
            : (json['trigliceridos'] as num?)?.toDouble(),
    glucosa: (json['glucosa'] is String)
            ? double.tryParse(json['glucosa'])
            : (json['glucosa'] as num?)?.toDouble(),
    glicemia_basal: (json['glicemia_basal'] is String)
            ? double.tryParse(json['glicemia_basal'])
            : (json['glicemia_basal'] as num?)?.toDouble(),
    fecha: DateTime.tryParse(json['fecha'] as String? ?? ''),
    tipo: json['tipo']?.toString(),
    usuario: json['usuario']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "colesterol_total": colesterol_total,
    "colesterol_hdl": colesterol_hdl,
    "colesterol_ldl": colesterol_ldl,
    "trigliceridos": trigliceridos,
    "glucosa": glucosa,
    "glicemia_basal": glicemia_basal,
    "fecha": fecha?.toIso8601String(),
    "tipo": tipo,
    "usuario": usuario,
  };
}
