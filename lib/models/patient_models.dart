import 'dart:convert';

Patient patientFromJson(String str) => Patient.fromJson(json.decode(str));

String patientToJson(Patient data) => json.encode(data.toJson());

class Patient {
  int id;
  String nombre;
  String correo;
  String role;
  List<String> proyectos;

  Patient({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.role,
    required this.proyectos,
  });

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        id: json["id"],
        nombre: json["nombre"],
        correo: json["correo"],
        role: json["role"],
        proyectos: List<String>.from(json["proyectos"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "correo": correo,
        "role": role,
        "proyectos": List<dynamic>.from(proyectos.map((x) => x)),
      };
}
