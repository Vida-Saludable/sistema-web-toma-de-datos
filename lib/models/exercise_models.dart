import 'dart:convert';

Exercise exerciseFromJson(String str) => Exercise.fronJson(json.decode(str));

String exerciseToJson(Exercise data) => json.encode(data.toJson());

class Exercise {

  int? id;
  String? fecha;
  String? tipo;
  int? tiempo;
  String? usuario;
  String? telefono;

  Exercise({
    this.id,
    this.fecha,
    this.tipo,
    this.tiempo,
    this.usuario,
    this.telefono,
  });

  factory Exercise.fronJson(Map<String, dynamic> json) => Exercise(
      id: json["id"],
      fecha: json["fecha"],
      tipo: json["tipo"],
      tiempo: json["tiempo"],
      usuario: json["usuario"],
      telefono: json["telefono"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fecha": fecha,
    "tipo": tipo,
    "tiempo": tiempo,
    "usuario": usuario,
    "telefono": telefono,
  };

}
