import 'dart:convert';
import 'package:flutter_web_dashboard/models/proyectos_usuarios_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../environment/environment.dart';
import '../models/proyecto_models.dart';
import '../models/response_api.dart';
import 'package:http/http.dart' as http;

class ProyectoProviders extends GetConnect {
  String url = '${Environment.API_URL}users';

Future<ResponseApi> deleteProyecto(int id) async {
  try {
    final response = await http.delete(Uri.parse('$url/proyectos/$id/'));

    if (response.statusCode == 200) {
      return ResponseApi(success: true, message: 'El proyecto se eliminó correctamente');
    } else {
      return ResponseApi(success: false, message: 'No se pudo eliminar el proyecto');
    }
  } catch (e) {
    return ResponseApi(success: false, message: 'Hubo un problema al intentar eliminar el proyecto');
  }
}


Future<ResponseApi> create(Proyecto proyecto) async {
  final dateFormat = DateFormat('yyyy-MM-dd');

  if (proyecto.nombre == null ||
      proyecto.descripcion == null ||
      proyecto.fecha_inicio == null ||
      proyecto.fecha_fin == null ||
      proyecto.estado == null) {
    return ResponseApi(
      success: false,
      message: 'Datos incompletos. Todos los campos deben estar llenos.',
    );
  }

  try {
    final formattedStartDate = dateFormat.format(proyecto.fecha_inicio!);
    final formattedEndDate = dateFormat.format(proyecto.fecha_fin!);

    final Map<String, dynamic> proyectoJson = {
      'nombre': proyecto.nombre,
      'descripcion': proyecto.descripcion,
      'fecha_inicio': formattedStartDate,
      'fecha_fin': formattedEndDate,
      'estado': proyecto.estado,
    };

    print('JSON a enviar: ${jsonEncode(proyectoJson)}');

    final response = await http.post(
      Uri.parse('$url/proyectos/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(proyectoJson),
    );

    if (response.statusCode != 201) {
      print('Error de conexión: ${response.reasonPhrase}');
      return ResponseApi(
        success: false,
        message: 'Error de conexión: ${response.reasonPhrase}',
      );
    }

    final responseJson = jsonDecode(response.body);
    ResponseApi responseApi = ResponseApi.fromJson(responseJson);
    return responseApi;
  } catch (e, stacktrace) {
    print('Excepción: $e');
    print('Stacktrace: $stacktrace');
    return ResponseApi(
      success: false,
      message: 'Ocurrió un error inesperado: $e',
    );
  }
}


  Future<ResponseApi> update(Proyecto proyecto) async {
    final dateFormat = DateFormat('yyyy-MM-dd');

    if (proyecto.nombre == null ||
        proyecto.fecha_inicio == null ||
        proyecto.fecha_fin == null) {
      return ResponseApi(
        success: false,
        message: 'Datos incompletos. Todos los campos deben estar llenos.',
      );
    }

    try {
      final formattedStartDate = dateFormat.format(proyecto.fecha_inicio!);
      final formattedEndDate = dateFormat.format(proyecto.fecha_fin!);

      final Map<String, dynamic> proyectoJson = {
        'nombre': proyecto.nombre,
        'fecha_inicio': formattedStartDate,
        'fecha_fin': formattedEndDate,
      };
      final response = await http.put(
        Uri.parse('$url/proyectos/${proyecto.id}/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(proyectoJson),
      );
      print(response.statusCode);

      if (response.statusCode != 200) {
        return ResponseApi(
          success: false,
          message: 'Error de conexión: ${response.reasonPhrase}',
        );
      }

      final responseJson = jsonDecode(response.body);
      print(responseJson);
      ResponseApi responseApi = ResponseApi.fromJson(responseJson);
      return responseApi;
    } catch (e) {
      return ResponseApi(
        success: false,
        message: 'Ocurrió un error inesperado: $e',
      );
    }
  }

    Future<ResponseApi> updateEstado(Proyecto proyecto) async {
    try {

      final Map<String, dynamic> proyectoJson = {
        "estado": proyecto.estado
      };
      final response = await http.put(
        Uri.parse('$url/proyectos/${proyecto.id}/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(proyectoJson),
      );
      print(response.statusCode);

      if (response.statusCode != 200) {
        return ResponseApi(
          success: false,
          message: 'Error de conexión: ${response.reasonPhrase}',
        );
      }

      final responseJson = jsonDecode(response.body);
      print(responseJson);
      ResponseApi responseApi = ResponseApi.fromJson(responseJson);
      return responseApi;
    } catch (e) {
      return ResponseApi(
        success: false,
        message: 'Ocurrió un error inesperado: $e',
      );
    }
  }

  Future<ResponseApi> getAll() async {
    try {
      final response = await get(
          '$url/proyectos/');
      print(response.statusCode);
      if (response.status.hasError) {
        print('Error de conexión: ${response.statusText}');
        print('Código de estado: ${response.statusCode}');
        print('Respuesta: ${response.bodyString}');
        return ResponseApi(
          success: false,
          message: 'Error de conexión: ${response.statusText}',
        );
      }

      final responseBody = response.body;
      List<dynamic> proyectosJson;
      print(responseBody);

      if (responseBody is Map<String, dynamic>) {
        proyectosJson = responseBody['data'] as List<dynamic>;
      } else if (responseBody is List) {
        proyectosJson = responseBody;
      } else {
        throw Exception('El formato de la respuesta no es compatible.');
      }

      final List<Proyecto> proyectos =
          proyectosJson.map((json) => Proyecto.fromJson(json)).toList();

      return ResponseApi(
        success: true,
        data: proyectos,
      );
    } catch (e) {
      print('Excepción capturada: $e');
      return ResponseApi(
        success: false,
        message: 'Ocurrió un error inesperado: $e',
      );
    }
  }

    Future<ResponseApi> getProyectoUsuario(int id) async {
    try {
      final response = await get(
          '$url/proyectos-de-usuarios/$id');
      print(response.statusCode);
      if (response.status.hasError) {
        print('Error de conexión: ${response.statusText}');
        print('Código de estado: ${response.statusCode}');
        print('Respuesta: ${response.bodyString}');
        return ResponseApi(
          success: false,
          message: 'Error de conexión: ${response.statusText}',
        );
      }

      final responseBody = response.body;
      List<dynamic> proyectosJson;
      print(responseBody);

      if (responseBody is Map<String, dynamic>) {
        proyectosJson = responseBody['data'] as List<dynamic>;
      } else if (responseBody is List) {
        proyectosJson = responseBody;
      } else {
        throw Exception('El formato de la respuesta no es compatible.');
      }

      final List<Proyecto> proyectos =
          proyectosJson.map((json) => Proyecto.fromJson(json)).toList();

      return ResponseApi(
        success: true,
        data: proyectos,
      );
    } catch (e) {
      print('Excepción capturada: $e');
      return ResponseApi(
        success: false,
        message: 'Ocurrió un error inesperado: $e',
      );
    }
  }

  Future<ResponseApi> deleteProyectoAsignado(int id) async {
    try {
      final response = await http.delete(Uri.parse('$url/usuario-proyectos/$id/'));

      if (response.statusCode == 200) {
        return ResponseApi(success: true, message: 'El proyecto se eliminó correctamente');
      } else {
        return ResponseApi(success: false, message: 'No se pudo eliminar el proyecto');
      }
    } catch (e) {
      return ResponseApi(success: false, message: 'Hubo un problema al intentar eliminar el proyecto');
    }
  }

  
  Future<ResponseApi> asignarProyecto(UsuarioProyecto usuarioProyecto) async {

    if (usuarioProyecto.usuario == null ||
        usuarioProyecto.proyecto == null) {
      return ResponseApi(
        success: false,
        message: 'Datos incompletos. Todos los campos deben estar llenos.',
      );
    }

    try {

      final Map<String, dynamic> proyectoJson = {
        'usuario': usuarioProyecto.usuario,
        'proyecto': usuarioProyecto.proyecto,
      };

      print('JSON a enviar: ${jsonEncode(proyectoJson)}');

      final response = await http.post(
        Uri.parse('$url/usuario-proyectos/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(proyectoJson),
      );

      if (response.statusCode != 201) {
        print('Error de conexión: ${response.reasonPhrase}');
        return ResponseApi(
          success: false,
          message: 'Error de conexión: ${response.reasonPhrase}',
        );
      }

      final responseJson = jsonDecode(response.body);
      ResponseApi responseApi = ResponseApi.fromJson(responseJson);
      return responseApi;
    } catch (e, stacktrace) {
      print('Excepción: $e');
      print('Stacktrace: $stacktrace');
      return ResponseApi(
        success: false,
        message: 'Ocurrió un error inesperado: $e',
      );
    }
  }
}
