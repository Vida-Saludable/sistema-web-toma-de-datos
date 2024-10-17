import 'dart:convert';

import 'package:flutter_web_dashboard/models/patient_models.dart';
import 'package:flutter_web_dashboard/models/user_models.dart';
import 'package:get/get.dart';
import '../environment/environment.dart';
import '../models/response_api.dart';
import 'package:http/http.dart' as http;

class PatientProvider extends GetConnect {

  String url = '${Environment.API_URL}users/'; // Cambia esto por tu endpoint

  Future<ResponseApi> getAll() async {
    try {
      final response = await get('${url}lista-pacientes/');
      
      if (response.status.hasError) {
        return ResponseApi(
          success: false,
          message: 'Error de conexión: ${response.statusText}',
        );
      }

      final responseBody = response.body;
      List<dynamic> patientJson;
      print(responseBody);

      if (responseBody is Map<String, dynamic>) {
        patientJson = responseBody['data'] as List<dynamic>;
      } else if (responseBody is List) {
        patientJson = responseBody;
      } else {
        throw Exception('El formato de la respuesta no es compatible.');
      }

      final List<Patient> patients =
          patientJson.map((json) => Patient.fromJson(json)).toList();

      return ResponseApi(
        success: true,
        data: patients,
      );
    } catch (e) {
      return ResponseApi(
        success: false,
        message: 'Ocurrió un error inesperado: $e',
      );
    }
  }

    Future<ResponseApi> update(User user) async {
    // Validación de campos requeridos
    if (user.correo == null || 
    user.role == null || 
    user.nombre == null || 
    user.id == null ||
    user.proyectos == null) {
      return ResponseApi(
        success: false,
        message: 'Datos incompletos. Todos los campos deben estar llenos.',
      );
    }

    try {
      List<int> proyectosIds = user.proyectos!.map((proyecto) => proyecto.id!).toList();

      final Map<String, dynamic> userJson = {
        'correo': user.correo,
        'role': user.role,
        'nombre': user.nombre,
        'proyectos': proyectosIds,
      };

      print('JSON a enviar: ${jsonEncode(userJson)}'); // Para depuración
      final response = await http.put(
        Uri.parse('${url}editar-paciente/${user.id}/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userJson),
      );
      print('Ruta : ${url}editar-paciente/${user.id}/');

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
