import 'dart:convert';

import 'package:flutter_web_dashboard/models/signos_vitales_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../environment/environment.dart';
import '../models/response_api.dart';
import 'package:http/http.dart' as http;

class SignosVitalesProviders extends GetConnect {
  String url = '${Environment.API_URL}health/'; // Ajusta la ruta según tu API

  Future<ResponseApi> getAll(String userID) async {
    try {
      final response = await get('${url}lista-signos-vitales/${userID}/'); // Asegúrate de que la URL sea correcta
      print('Ruta ${url}lista-signos-vitales/${userID}/');

      // Verifica si hubo algún error en la respuesta
      if (response.status.hasError) {
        print('Error de conexión: ${response.statusText}');
        return ResponseApi(
          success: false,
          message: 'Error de conexión: ${response.statusText}',
        );
      }

      final responseBody = response.body;
      List<dynamic> signosVitalesJson;
      print(responseBody);

      // Procesa la respuesta y extrae los datos
      if (responseBody is Map<String, dynamic>) {
        signosVitalesJson = responseBody['data'] as List<dynamic>;
      } else if (responseBody is List) {
        signosVitalesJson = responseBody;
      } else {
        throw Exception('El formato de la respuesta no es compatible.');
      }

      // Convierte la lista de JSON a una lista de objetos signosVitales
      final List<SignosVitales> signosVitales =
          signosVitalesJson.map((json) => SignosVitales.fromJson(json)).toList();

      return ResponseApi(
        success: true,
        data: signosVitales,
      );
    } catch (e) {
      print('Error: $e'); // Imprimir el error para depuración
      return ResponseApi(
        success: false,
        message: 'Ocurrió un error inesperado: $e',
      );
    }
  }

  Future<ResponseApi> create(SignosVitales datos) async {
    final dateFormat = DateFormat('yyyy-MM-dd');

    // Verificar campos requeridos
    if (datos.presion_sistolica == null ||
        datos.presion_diastolica == null ||
        datos.frecuencia_cardiaca == null ||
        datos.frecuencia_respiratoria == null ||
        datos.temperatura == null ||
        datos.saturacion_oxigeno == null ||
        datos.usuario == null) {
      return ResponseApi(
        success: false,
        message: 'Datos incompletos. Todos los campos deben estar llenos.',
      );
    }

    try {
      final formattedDate = dateFormat.format(datos.fecha!);

      final Map<String, dynamic> datosJson = {
        'presion_sistolica': datos.presion_sistolica,
        'presion_diastolica': datos.presion_diastolica,
        'frecuencia_cardiaca': datos.frecuencia_cardiaca,
        'frecuencia_respiratoria': datos.frecuencia_respiratoria,
        'temperatura': datos.temperatura,
        'saturacion_oxigeno': datos.saturacion_oxigeno,
        'fecha': formattedDate, // Fecha actual
        // ignore: equal_keys_in_map
        'usuario': datos.usuario, // Agrega el ID del usuario si es necesario
      };

      print('JSON a enviar: ${jsonEncode(datosJson)}');

      // Hacer la solicitud POST usando GetConnect
      final response = await http.post(
        Uri.parse('${url}signos-vitales/'),
        body: jsonEncode(datosJson),
        headers: {'Content-Type': 'application/json'},
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
