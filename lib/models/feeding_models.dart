import 'dart:convert';

Feeding feedingFromJson(String str) => Feeding.fronJson(json.decode(str));

String feedingToJson(Feeding data) => json.encode(data.toJson());

class Feeding {

  int? id;
  String? fecha;
  String? desayuno_hora;
  String? almuerzo_hora;
  String? cena_hora;
  int? desayuno;
  int? almuerzo;
  int? cena;
  int? desayuno_saludable;
  int? almuerzo_saludable;
  int? cena_saludable;
  String? usuario;
  String? telefono;

  Feeding({
    this.id,
    this.fecha,
    this.desayuno_hora,
    this.almuerzo_hora,
    this.cena_hora,
    this.desayuno,
    this.almuerzo,
    this.cena,
    this.desayuno_saludable,
    this.almuerzo_saludable,
    this.cena_saludable,
    this.usuario,
    this.telefono,
  });

  factory Feeding.fronJson(Map<String, dynamic> json) => Feeding(
      id: json["id"],
      fecha: json["fecha"],
      desayuno_hora: json["desayuno_hora"],
      almuerzo_hora: json["almuerzo_hora"],
      cena_hora: json["cena_hora"],
      desayuno: json["desayuno"],
      almuerzo: json["almuerzo"],
      cena: json["cena"],
      desayuno_saludable: json["desayuno_saludable"],
      almuerzo_saludable: json["almuerzo_saludable"],
      cena_saludable: json["cena_saludable"],
      usuario: json["usuario"],
      telefono: json["telefono"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fecha": fecha,
    "desayuno_hora": desayuno_hora,
    "almuerzo_hora": almuerzo_hora,
    "cena_hora": cena_hora,
    "desayuno": desayuno,
    "almuerzo": almuerzo,
    "cena": cena,
    "desayuno_saludable": desayuno_saludable,
    "almuerzo_saludable": almuerzo_saludable,
    "cena_saludable": cena_saludable,
    "usuario": usuario,
    "telefono": telefono,
  };

}
