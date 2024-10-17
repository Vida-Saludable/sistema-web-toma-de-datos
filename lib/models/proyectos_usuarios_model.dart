import 'dart:convert';

UsuarioProyecto usuarioProyectoFromJson(String str) => UsuarioProyecto.fromJson(json.decode(str));

String usuarioProyectoToJson(UsuarioProyecto data) => json.encode(data.toJson());

class UsuarioProyecto {
  int? usuario;
  int? proyecto;


  UsuarioProyecto({
    this.usuario,
    this.proyecto,
  });

  factory UsuarioProyecto.fromJson(Map<String, dynamic> json) => UsuarioProyecto(
        usuario: json["usuario"],
        proyecto: json["proyecto"],
      );

  Map<String, dynamic> toJson() => {
        "usuario": usuario,
        "proyecto": proyecto,
      };
}
