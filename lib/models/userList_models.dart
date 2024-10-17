
import 'dart:convert';

Usuarios usuariosFromJson(String str) => Usuarios.fronJson(json.decode(str));

String usuariosToJson(Usuarios data) => json.encode(data.toJson());


class Usuarios {

  int? id;
  String? correo;
  String? contrasenia;
  String? role;
  String? nombre;

  Usuarios({
    this.id,
    this.correo,
    this.contrasenia,
    this.role,
    this.nombre,
  });

  factory Usuarios.fronJson(Map<String, dynamic> json) => Usuarios(
      id: json["id"],
      correo: json["correo"],
      contrasenia: json["contrasenia"],
      role: json["role"],
      nombre: json["nombre"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "correo": correo,
    "contrasenia": contrasenia,
    "role": role,
    "nombre": nombre,
  };

}
