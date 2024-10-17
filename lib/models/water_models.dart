import 'dart:convert';

Water waterFromJson(String str) => Water.fronJson(json.decode(str));

String waterToJson(Water data) => json.encode(data.toJson());

class Water {

  int? id;
  String? fecha;
  String? hora;
  int? cantidad;
  String? usuario;
  String? telefono;

  Water({
    this.id,
    this.fecha,
    this.hora,
    this.cantidad,
    this.usuario,
    this.telefono,
  });

  factory Water.fronJson(Map<String, dynamic> json) => Water(
      id: json["id"],
      fecha: json["fecha"],
      hora: json["hora"],
      cantidad: json["cantidad"],
      usuario: json["usuario"],
      telefono: json["telefono"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fecha": fecha,
    "hora": hora,
    "cantidad": cantidad,
    "usuario": usuario,
    "telefono": telefono,
  };

}
