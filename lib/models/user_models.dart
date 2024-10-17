import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  int? id;
  String? correo;
  String? contrasenia;
  String? role;
  String? nombre;
  List<Proyectos>? proyectos;  // Cambia a List<Proyectos>

  User({
    this.id,
    this.correo,
    this.contrasenia,
    this.role,
    this.nombre,
    this.proyectos,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        correo: json["correo"],
        contrasenia: json["contrasenia"],
        role: json["role"],
        nombre: json["nombre"],
        proyectos: json["proyectos"] != null
            ? List<Proyectos>.from(json["proyectos"].map((x) => Proyectos.fromJson(x)))  // Mapeo de proyectos
            : [], // Manejar el caso donde no hay proyectos
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "correo": correo,
        "contrasenia": contrasenia,
        "role": role,
        "nombre": nombre,
        "proyectos": proyectos != null
            ? List<dynamic>.from(proyectos!.map((x) => x.toJson()))  // Serialización de proyectos
            : [],
      };
}

class Proyectos {
  int? id;
  String? nombre;

  Proyectos({
    this.id,
    this.nombre,
  });

  factory Proyectos.fromJson(Map<String, dynamic> json) => Proyectos(
        id: json["id"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
      };
}
