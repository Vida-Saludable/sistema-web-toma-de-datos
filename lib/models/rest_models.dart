import 'dart:convert';

Rest restFromJson(String str) => Rest.fronJson(json.decode(str));

String restToJson(Rest data) => json.encode(data.toJson());

class Rest {

  int? id;
  String? fecha;
  int? tiempo;
  int? total_horas;
  int? total_minutos;
  String? hora_dormir;
  String? hora_despertar;
  int? estado;
  String? usuario;
  String? telefono;

  Rest({
    this.id,
    this.fecha,
    this.total_horas,
    this.total_minutos,
    this.hora_dormir,
    this.hora_despertar,
    this.estado,
    this.usuario,
    this.telefono,
  });

  factory Rest.fronJson(Map<String, dynamic> json) => Rest(
      id: json["id"],
      fecha: json["fecha"],
      total_horas: json["total_horas"],
      total_minutos: json["total_minutos"],
      hora_dormir: json["hora_dormir"],
      hora_despertar: json["hora_despertar"],
      estado: json["estado"],
      usuario: json["usuario"],
      telefono: json["telefono"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fecha": fecha,
    "total_horas": total_horas,
    "total_minutos": total_minutos,
    "hora_dormir": hora_dormir,
    "hora_despertar": hora_despertar,
    "estado": estado,
    "usuario": usuario,
    "telefono": telefono,
  };

}
