import 'dart:convert';

Air airFromJson(String str) => Air.fronJson(json.decode(str));

String airToJson(Air data) => json.encode(data.toJson());

class Air {

  int? id;
  String? fecha;
  int? tiempo;
  String? usuario;
  String? telefono;

  Air({
    this.id,
    this.fecha,
    this.tiempo,
    this.usuario,
    this.telefono,
  });

  factory Air.fronJson(Map<String, dynamic> json) => Air(
      id: json["id"],
      fecha: json["fecha"],
      tiempo: json["tiempo"],
      usuario: json["usuario"],
      telefono: json["telefono"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fecha": fecha,
    "tiempo": tiempo,
    "usuario": usuario,
    "telefono": telefono,
  };

}
