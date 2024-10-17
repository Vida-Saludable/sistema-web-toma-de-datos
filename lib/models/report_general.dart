import 'dart:convert';

Reporte reporteFromJson(String str) => Reporte.fromJson(json.decode(str));

String reporteToJson(Reporte data) => json.encode(data.toJson());

class Reporte {
  String fecha;
  Usuario usuario;
  Alimentacion alimentacion;
  Aire aire;
  Agua agua;
  List<Ejercicio> ejercicio;
  List<Esperanza> esperanza;
  Sol sol;
  Descanso descanso;
  List<String> proyectos;

  Reporte({
    required this.fecha,
    required this.usuario,
    required this.alimentacion,
    required this.aire,
    required this.agua,
    required this.ejercicio,
    required this.esperanza,
    required this.sol,
    required this.descanso,
    required this.proyectos,
  });

  factory Reporte.fromJson(Map<String, dynamic> json) => Reporte(
        fecha: json["fecha"],
        usuario: Usuario.fromJson(json["usuario"]),
        alimentacion: Alimentacion.fromJson(json["alimentacion"]),
        aire: Aire.fromJson(json["aire"]),
        agua: Agua.fromJson(json["agua"]),
        ejercicio: List<Ejercicio>.from(json["ejercicio"].map((x) => Ejercicio.fromJson(x))),
        esperanza: List<Esperanza>.from(json["esperanza"].map((x) => Esperanza.fromJson(x))),
        sol: Sol.fromJson(json["sol"]),
        descanso: Descanso.fromJson(json["descanso"]),
        proyectos: List<String>.from(json["proyectos"]),
      );

  Map<String, dynamic> toJson() => {
        "fecha": fecha,
        "usuario": usuario.toJson(),
        "alimentacion": alimentacion.toJson(),
        "aire": aire.toJson(),
        "agua": agua.toJson(),
        "ejercicio": List<dynamic>.from(ejercicio.map((x) => x.toJson())),
        "esperanza": List<dynamic>.from(esperanza.map((x) => x.toJson())),
        "sol": sol.toJson(),
        "descanso": descanso.toJson(),
        "proyectos": proyectos,
      };
}

class Usuario {
  String nombresApellidos;
  String telefono;

  Usuario({
    required this.nombresApellidos,
    required this.telefono,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        nombresApellidos: json["nombres_apellidos"],
        telefono: json["telefono"],
      );

  Map<String, dynamic> toJson() => {
        "nombres_apellidos": nombresApellidos,
        "telefono": telefono,
      };
}

class Alimentacion {
  int? desayuno; // Hacer desayuno opcional
  int? almuerzo; // Hacer almuerzo opcional
  int? cena; // Hacer cena opcional

  Alimentacion({
    this.desayuno,
    this.almuerzo,
    this.cena,
  });

  factory Alimentacion.fromJson(Map<String, dynamic> json) => Alimentacion(
        desayuno: json["desayuno"] != null ? json["desayuno"] as int : null,
        almuerzo: json["almuerzo"] != null ? json["almuerzo"] as int : null,
        cena: json["cena"] != null ? json["cena"] as int : null,
      );

  Map<String, dynamic> toJson() => {
        "desayuno": desayuno,
        "almuerzo": almuerzo,
        "cena": cena,
      };
}

class Aire {
  int tiempo;

  Aire({required this.tiempo});

  factory Aire.fromJson(Map<String, dynamic> json) => Aire(
        tiempo: json["tiempo"],
      );

  Map<String, dynamic> toJson() => {
        "tiempo": tiempo,
      };
}

class Agua {
  int cantidad;

  Agua({required this.cantidad});

  factory Agua.fromJson(Map<String, dynamic> json) => Agua(
        cantidad: json["cantidad"],
      );

  Map<String, dynamic> toJson() => {
        "cantidad": cantidad,
      };
}

class Ejercicio {
  String tipo;
  int tiempo;

  Ejercicio({required this.tipo, required this.tiempo});

  factory Ejercicio.fromJson(Map<String, dynamic> json) => Ejercicio(
        tipo: json["tipo"],
        tiempo: json["tiempo"],
      );

  Map<String, dynamic> toJson() => {
        "tipo": tipo,
        "tiempo": tiempo,
      };
}

class Esperanza {
  String tipoPractica;

  Esperanza({required this.tipoPractica});

  factory Esperanza.fromJson(Map<String, dynamic> json) => Esperanza(
        tipoPractica: json["tipo_practica"],
      );

  Map<String, dynamic> toJson() => {
        "tipo_practica": tipoPractica,
      };
}

class Sol {
  int tiempo;

  Sol({required this.tiempo});

  factory Sol.fromJson(Map<String, dynamic> json) => Sol(
        tiempo: json["tiempo"],
      );

  Map<String, dynamic> toJson() => {
        "tiempo": tiempo,
      };
}

class Descanso {
  int totalHoras;
  int totalMinutos;

  Descanso({required this.totalHoras, required this.totalMinutos});

  factory Descanso.fromJson(Map<String, dynamic> json) => Descanso(
        totalHoras: json["total_horas"],
        totalMinutos: json["total_minutos"],
      );

  Map<String, dynamic> toJson() => {
        "total_horas": totalHoras,
        "total_minutos": totalMinutos,
      };
}


class Proyecto {
  String nombre;

  Proyecto({required this.nombre});

  factory Proyecto.fromJson(Map<String, dynamic> json) => Proyecto(
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
      };
}
