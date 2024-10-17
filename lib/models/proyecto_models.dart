import 'dart:convert';

Proyecto proyectoFromJson(String str) => Proyecto.fromJson(json.decode(str));

String proyectoToJson(Proyecto data) => json.encode(data.toJson());

class Proyecto {
  int? id;
  String? nombre;
  String? descripcion;
  DateTime? fecha_inicio;
  DateTime? fecha_fin;
  int? estado;

  Proyecto({
    this.id,
    this.nombre,
    this.descripcion,
    this.fecha_inicio,
    this.fecha_fin,
    this.estado,
  });

factory Proyecto.fromJson(Map<String, dynamic> json) => Proyecto(
  id: json["id"],
  nombre: json["nombre"] ?? 'Sin nombre', // Valor por defecto si es null
  descripcion: json["descripcion"] ?? 'Sin descripción', // Valor por defecto si es null
  fecha_inicio: json["fecha_inicio"] != null 
      ? DateTime.tryParse(json["fecha_inicio"]) 
      : DateTime.now(),
  fecha_fin: json["fecha_fin"] != null 
      ? DateTime.tryParse(json["fecha_fin"]) 
      : DateTime.now(),
  estado: json["estado"] ?? 0, // Valor por defecto si es null
);
  Map<String, dynamic> toJson() => {
    "id": id,
    "nombre": nombre,
    "descripcion": descripcion,
    "fecha_inicio": fecha_inicio?.toIso8601String(), // Mejor formato para fechas
    "fecha_fin": fecha_fin?.toIso8601String(), // Mejor formato para fechas
    "estado": estado,
  };
}
