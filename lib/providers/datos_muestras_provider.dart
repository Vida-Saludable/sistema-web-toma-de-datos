import 'dart:convert';

import 'package:flutter_web_dashboard/models/datos_muestras_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../environment/environment.dart';
import '../models/response_api.dart';
import 'package:http/http.dart' as http;

class DatosMuestrasProviders extends GetConnect {
  String url = '${Environment.API_URL}health/'; // Ajusta la ruta según tu API

    Future<ResponseApi> getAll(String userID) async {
    try {
      final response = await get('${url}lista-datos-muestras/${userID}/'); // Asegúrate de que la URL sea correcta
      print('Ruta ${url}lista-datos-muestras/${userID}/');

      // Verifica si hubo algún error en la respuesta
      if (response.status.hasError) {
        print('Error de conexión: ${response.statusText}');
        return ResponseApi(
          success: false,
          message: 'Error de conexión: ${response.statusText}',
        );
      }

      final responseBody = response.body;
      List<dynamic> datosMuestrasJson;
      print(responseBody);

      // Procesa la respuesta y extrae los datos
      if (responseBody is Map<String, dynamic>) {
        datosMuestrasJson = responseBody['data'] as List<dynamic>;
      } else if (responseBody is List) {
        datosMuestrasJson = responseBody;
      } else {
        throw Exception('El formato de la respuesta no es compatible.');
      }

      // Convierte la lista de JSON a una lista de objetos datosMuestras
      final List<DatosMuestras> datosMuestras =
          datosMuestrasJson.map((json) => DatosMuestras.fromJson(json)).toList();

      return ResponseApi(
        success: true,
        data: datosMuestras,
      );
    } catch (e) {
      print('Error: $e'); // Imprimir el error para depuración
      return ResponseApi(
        success: false,
        message: 'Ocurrió un error inesperado: $e',
      );
    }
  }

  Future<ResponseApi> create(DatosMuestras datos) async {
    final dateFormat = DateFormat('yyyy-MM-dd');

    // Verificar campos requeridos
    if (datos.colesterol_total == null ||
        datos.colesterol_hdl == null ||
        datos.colesterol_ldl == null ||
        datos.trigliceridos == null ||
        datos.glucosa == null ||
        datos.glicemia_basal == null ||
        datos.usuario == null) {
      return ResponseApi(
        success: false,
        message: 'Datos incompletos. Todos los campos deben estar llenos.',
      );
    }

    try {
      final formattedDate = dateFormat.format(datos.fecha!);

      final Map<String, dynamic> datosJson = {
        'colesterol_total': datos.colesterol_total,
        'colesterol_hdl': datos.colesterol_hdl,
        'colesterol_ldl': datos.colesterol_ldl,
        'trigliceridos': datos.trigliceridos,
        'glucosa': datos.glucosa,
        'glicemia_basal': datos.glicemia_basal,
        'fecha': formattedDate, // Fecha actual
        // ignore: equal_keys_in_map
        'usuario': datos.usuario, // Agrega el ID del usuario si es necesario
      };

      print('JSON a enviar: ${jsonEncode(datosJson)}');

      // Hacer la solicitud POST usando GetConnect
      final response = await http.post(
        Uri.parse('${url}datos-muestras/'),
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
