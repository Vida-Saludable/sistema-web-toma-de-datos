import 'dart:convert';
import 'package:get/get.dart';

import '../environment/environment.dart';
import '../models/response_api.dart';
import '../models/user_models.dart';
import 'package:http/http.dart' as http;

class UsersProviders extends GetConnect {
  String url = Environment.API_URL + 'users/usuarios/';
  String urlList = Environment.API_URL + 'users/';

Future<ResponseApi> create(User user) async {
  // Validar que los campos requeridos no sean nulos
  if (user.correo == null ||
      user.contrasenia == null ||
      user.role == null ||
      user.nombre == null ||
      user.proyectos == null) {
    return ResponseApi(
      success: false,
      message: 'Datos incompletos. Todos los campos deben estar llenos.',
    );
  }

  try {
    // Convertir la lista de objetos Proyectos a una lista de enteros (IDs de proyectos)
    List<int> proyectosIds = user.proyectos!.map((proyecto) => proyecto.id!).toList(); // Asegúrate de que id no sea null

    final Map<String, dynamic> userJson = {
      'correo': user.correo,
      'contrasenia': user.contrasenia,
      'role': user.role,
      'nombre': user.nombre,
      'proyectos': proyectosIds, // Enviar la lista de IDs de proyectos
    };

    print('JSON a enviar: ${jsonEncode(userJson)}');

    final response = await http.post(
      Uri.parse('$url'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userJson),
    );

    // Verificar el estado de la respuesta
    if (response.statusCode != 201) {
      print('Error de conexión: ${response.reasonPhrase}');
      return ResponseApi(
        success: false,
        message: 'Error de conexión: ${response.reasonPhrase}',
      );
    }

    // Procesar la respuesta del servidor
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

  Future<ResponseApi> getAll() async {
    try {
      final response = await get(
          '${urlList}lista-usuarios/');
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
      List<dynamic> userJson;
      print(responseBody);

      if (responseBody is Map<String, dynamic>) {
        userJson = responseBody['data'] as List<dynamic>;
      } else if (responseBody is List) {
        userJson = responseBody;
      } else {
        throw Exception('El formato de la respuesta no es compatible.');
      }

      final List<User> roles =
          userJson.map((json) => User.fromJson(json)).toList();

      return ResponseApi(
        success: true,
        data: roles,
      );
    } catch (e) {
      print('Excepción capturada: $e');
      return ResponseApi(
        success: false,
        message: 'Ocurrió un error inesperado: $e',
      );
    }
  }

  Future<ResponseApi> deleteUsuario(int id) async {
    try {
      final response = await http.delete(Uri.parse('${url}${id}/'));

      if (response.statusCode == 200) {
        return ResponseApi(success: true, message: 'El usuario se eliminó correctamente');
      } else {
        return ResponseApi(success: false, message: 'No se pudo eliminar el usuario');
      }
    } catch (e) {
      return ResponseApi(success: false, message: 'Hubo un problema al intentar eliminar el usuario');
    }
  }

  Future<ResponseApi> update(User user) async {
    // Validación de campos requeridos
    if (user.correo == null || user.role == null || user.nombre == null || user.id == null) {
      return ResponseApi(
        success: false,
        message: 'Datos incompletos. Todos los campos deben estar llenos.',
      );
    }

    try {
      final Map<String, dynamic> userJson = {
        'correo': user.correo,
        'role': user.role,
        'nombre': user.nombre,
      };

      print('JSON a enviar: ${jsonEncode(userJson)}'); // Para depuración
      final response = await http.put(
        Uri.parse('$url${user.id}/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userJson),
      );

      print('Código de estado de la respuesta: ${response.statusCode}'); // Para depuración

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        return ResponseApi.fromJson(responseJson);
      } else {
        // Manejo de diferentes códigos de error
        String message = 'Error desconocido';
        if (response.statusCode == 400) {
          message = 'Datos inválidos. Verifica tu entrada.';
        } else if (response.statusCode == 404) {
          message = 'Usuario no encontrado.';
        } else if (response.statusCode == 500) {
          message = 'Error en el servidor. Intenta más tarde.';
        }
        return ResponseApi(
          success: false,
          message: message,
        );
      }
    } catch (e) {
      return ResponseApi(
        success: false,
        message: 'Ocurrió un error inesperado: $e',
      );
    }
  }

}
