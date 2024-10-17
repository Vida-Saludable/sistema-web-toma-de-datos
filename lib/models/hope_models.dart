import 'dart:convert';

Hope hopeFromJson(String str) => Hope.fronJson(json.decode(str));

String hopeToJson(Hope data) => json.encode(data.toJson());

class Hope {

  int? id;
  String? fecha;
  String? oracion;
  String? leer_biblia;
  String? usuario;
  String? telefono;

  Hope({
    this.id,
    this.fecha,
    this.oracion,
    this.leer_biblia,
    this.usuario,
    this.telefono,
  });

  factory Hope.fronJson(Map<String, dynamic> json) => Hope(
      id: json["id"],
      fecha: json["fecha"],
      oracion: json["oracion"],
      leer_biblia: json["leer_biblia"],
      usuario: json["usuario"],
      telefono: json["telefono"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fecha": fecha,
    "oracion": oracion,
    "leer_biblia": leer_biblia,
    "usuario": usuario,
    "telefono": telefono,
  };

}
