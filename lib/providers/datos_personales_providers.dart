import 'dart:convert';

import 'package:flutter_web_dashboard/models/datos_personales_models.dart'; // Asegúrate de que la ruta sea correcta
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../environment/environment.dart';
import '../models/response_api.dart';
import 'package:http/http.dart' as http;

class DatosPersonalesProviders extends GetConnect {
  String url = Environment.API_URL + 'users';

      Future<ResponseApi> getAll(String userID) async {
      final String urlList = '$url/lista-datos-personales/$userID/';

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
        List<dynamic> datosPersonalesJson;
        print(responseBody);

        // Procesar la respuesta y extraer los datos
        if (responseBody is Map<String, dynamic> && responseBody['data'] != null) {
          datosPersonalesJson = responseBody['data'] as List<dynamic>;
        } else if (responseBody is List) {
          datosPersonalesJson = responseBody;
        } else {
          throw Exception('El formato de la respuesta no es compatible.');
        }

        // Convertir la lista de JSON a una lista de objetos datosPersonales
        final List<DatosPersonales> datosPersonales =
            datosPersonalesJson.map((json) => DatosPersonales.fromJson(json)).toList();

        return ResponseApi(
          success: true,
          data: datosPersonales,
        );
      } catch (e) {
        print('Error: $e'); // Imprimir el error para depuración
        return ResponseApi(
          success: false,
          message: 'Ocurrió un error inesperado: $e',
        );
      }
    }
  Future<ResponseApi> create(DatosPersonales datos) async {
    final dateFormat = DateFormat('yyyy-MM-dd');

    // Verificar campos requeridos
    if (datos.nombres_apellidos == null ||
        datos.sexo == null ||
        datos.edad == null ||
        datos.estado_civil == null ||
        datos.fecha_nacimiento == null ||
        datos.telefono == null ||
        datos.grado_instruccion == null ||
        datos.procedencia == null ||
        datos.religion == null) {
      return ResponseApi(
        success: false,
        message: 'Datos incompletos. Todos los campos deben estar llenos.',
      );
    }

    try {
      // Formatear la fecha de nacimiento
      final formattedBirthDate = dateFormat.format(datos.fecha_nacimiento!);
      final formattedDate = dateFormat.format(datos.fecha!);

      final Map<String, dynamic> datosJson = {
        'nombres_apellidos': datos.nombres_apellidos,
        'sexo': datos.sexo,
        'edad': datos.edad,
        'estado_civil': datos.estado_civil,
        'fecha_nacimiento': formattedBirthDate,
        'telefono': datos.telefono,
        'grado_instruccion': datos.grado_instruccion,
        'procedencia': datos.procedencia,
        'religion': datos.religion,
        'fecha': formattedDate, // Fecha actual
        'usuario': datos.usuario, // Agrega el ID del usuario si es necesario
      };

      print('JSON a enviar: ${jsonEncode(datosJson)}');

      // Hacer la solicitud POST usando GetConnect
      final response = await http.post(
        Uri.parse('$url/usuarios-personales/'),
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
