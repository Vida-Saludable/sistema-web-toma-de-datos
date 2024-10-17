import 'dart:convert';

Sun sunFromJson(String str) => Sun.fronJson(json.decode(str));

String sunToJson(Sun data) => json.encode(data.toJson());

class Sun {

  int? id;
  String? fecha;
  int? tiempo;
  String? usuario;
  String? telefono;

  Sun({
    this.id,
    this.fecha,
    this.tiempo,
    this.usuario,
    this.telefono,
  });

  factory Sun.fronJson(Map<String, dynamic> json) => Sun(
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
