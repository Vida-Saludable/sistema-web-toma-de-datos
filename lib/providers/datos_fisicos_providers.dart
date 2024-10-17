import 'dart:convert';

import 'package:flutter_web_dashboard/models/datos_fisicos_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../environment/environment.dart';
import '../models/response_api.dart';
import 'package:http/http.dart' as http;

class DatosFisicosProviders extends GetConnect {
  String url = '${Environment.API_URL}health'; // Ajusta la ruta según tu API

    Future<ResponseApi> getAll(String userID) async {
      final String urlList = '$url/lista-datos-fisicos/$userID/';

      try {
        final response = await http.get(Uri.parse(urlList));
        print('Ruta: $urlList');
        print('Código de estado: ${response.statusCode}');

        // Verificar si la respuesta fue exitosa (código 200)
        if (response.statusCode != 200) {
          print('Error de conexión: ${response.statusCode}');
          return ResponseApi(
            success: false,
            message: 'Error de conexión: ${response.statusCode}',
          );
        }

        final responseBody = json.decode(response.body);
        List<dynamic> datosFisicosJson;
        print(responseBody);

        // Procesar la respuesta y extraer los datos
        if (responseBody is Map<String, dynamic> && responseBody['data'] != null) {
          datosFisicosJson = responseBody['data'] as List<dynamic>;
        } else if (responseBody is List) {
          datosFisicosJson = responseBody;
        } else {
          throw Exception('El formato de la respuesta no es compatible.');
        }

        // Convertir la lista de JSON a una lista de objetos DatosFisicos
        final List<DatosFisicos> datosFisicos =
            datosFisicosJson.map((json) => DatosFisicos.fromJson(json)).toList();

        return ResponseApi(
          success: true,
          data: datosFisicos,
        );
      } catch (e) {
        print('Error: $e'); // Imprimir el error para depuración
        return ResponseApi(
          success: false,
          message: 'Ocurrió un error inesperado: $e',
        );
      }
    }
  Future<ResponseApi> create(DatosFisicos datos) async {
    final dateFormat = DateFormat('yyyy-MM-dd');

    // Verificar campos requeridos
    if (datos.peso == null ||
        datos.altura == null ||
        datos.imc == null ||
        datos.radio_abdominal == null ||
        datos.grasa_corporal == null ||
        datos.grasa_visceral == null ||
        datos.porcentaje_musculo == null ||
        datos.usuario == null) {
      return ResponseApi(
        success: false,
        message: 'Datos incompletos. Todos los campos deben estar llenos.',
      );
    }

    try {
      final formattedDate = dateFormat.format(datos.fecha!);

      final Map<String, dynamic> datosJson = {
        'peso': datos.peso,
        'altura': datos.altura,
        'imc': datos.imc,
        'radio_abdominal': datos.radio_abdominal,
        'grasa_corporal': datos.grasa_corporal,
        'grasa_visceral': datos.grasa_visceral,
        'porcentaje_musculo': datos.porcentaje_musculo,
        'fecha': formattedDate, // Fecha actual
        // ignore: equal_keys_in_map
        'usuario': datos.usuario, // Agrega el ID del usuario si es necesario
      };

      print('JSON a enviar: ${jsonEncode(datosJson)}');

      // Hacer la solicitud POST usando GetConnect
      final response = await http.post(
        Uri.parse('$url/datos-fisicos/'),
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
