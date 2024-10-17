import 'dart:convert';

import 'package:flutter_web_dashboard/models/test_ruffier_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../environment/environment.dart';
import '../models/response_api.dart';
import 'package:http/http.dart' as http;

class TestRuffierProviders extends GetConnect {
  String url = '${Environment.API_URL}health/'; // Ajusta la ruta según tu API

  Future<ResponseApi> getAll(String userID) async {
    try {
      final response = await get('${url}lista-test-ruffier/${userID}/'); // Asegúrate de que la URL sea correcta
      print('Ruta ${url}lista-test-ruffier/${userID}/');

      // Verifica si hubo algún error en la respuesta
      if (response.status.hasError) {
        print('Error de conexión: ${response.statusText}');
        return ResponseApi(
          success: false,
          message: 'Error de conexión: ${response.statusText}',
        );
      }

      final responseBody = response.body;
      List<dynamic> testRuffierJson;
      print(responseBody);

      // Procesa la respuesta y extrae los datos
      if (responseBody is Map<String, dynamic>) {
        testRuffierJson = responseBody['data'] as List<dynamic>;
      } else if (responseBody is List) {
        testRuffierJson = responseBody;
      } else {
        throw Exception('El formato de la respuesta no es compatible.');
      }

      // Convierte la lista de JSON a una lista de objetos TestRuffier
      final List<TestRuffier> testRuffier =
          testRuffierJson.map((json) => TestRuffier.fromJson(json)).toList();

      return ResponseApi(
        success: true,
        data: testRuffier,
      );
    } catch (e) {
      print('Error: $e'); // Imprimir el error para depuración
      return ResponseApi(
        success: false,
        message: 'Ocurrió un error inesperado: $e',
      );
    }
  }

  Future<ResponseApi> create(TestRuffier datos) async {
    final dateFormat = DateFormat('yyyy-MM-dd');

    // Verificar campos requeridos
    if (datos.frecuencia_cardiaca_en_reposo == null ||
        datos.frecuencia_cardiaca_despues_de_45_segundos == null ||
        datos.frecuencia_cardiaca_1_minuto_despues == null ||
        datos.resultado_test_ruffier == null ||
        datos.usuario == null) {
      return ResponseApi(
        success: false,
        message: 'Datos incompletos. Todos los campos deben estar llenos.',
      );
    }

    try {
      final formattedDate = dateFormat.format(datos.fecha!);

      final Map<String, dynamic> datosJson = {
        'frecuencia_cardiaca_en_reposo': datos.frecuencia_cardiaca_en_reposo,
        'frecuencia_cardiaca_despues_de_45_segundos': datos.frecuencia_cardiaca_despues_de_45_segundos,
        'frecuencia_cardiaca_1_minuto_despues': datos.frecuencia_cardiaca_1_minuto_despues,
        'resultado_test_ruffier': datos.resultado_test_ruffier,
        'fecha': formattedDate, // Fecha actual
        // ignore: equal_keys_in_map
        'usuario': datos.usuario, // Agrega el ID del usuario si es necesario
      };

      print('JSON a enviar: ${jsonEncode(datosJson)}');

      // Hacer la solicitud POST usando GetConnect
      final response = await http.post(
        Uri.parse('${url}test-ruffier/'),
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
