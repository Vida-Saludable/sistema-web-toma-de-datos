import 'dart:convert';
import 'package:flutter_web_dashboard/models/datos_habitos_alimentacion_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../environment/environment.dart';
import '../models/response_api.dart';
import 'package:http/http.dart' as http;

class DatosHabitosAlimentacionProviders extends GetConnect {
  String url = '${Environment.API_URL}habits'; // Ajusta la ruta según tu API

    // Future<ResponseApi> getAll(String userID) async {
    //   final String urlList = '$url/lista-datos-fisicos/$userID/';

    //   try {
    //     final response = await http.get(Uri.parse(urlList));
    //     print('Ruta: $urlList');
    //     print('Código de estado: ${response.statusCode}');

    //     // Verificar si la respuesta fue exitosa (código 200)
    //     if (response.statusCode != 200) {
    //       print('Error de conexión: ${response.statusCode}');
    //       return ResponseApi(
    //         success: false,
    //         message: 'Error de conexión: ${response.statusCode}',
    //       );
    //     }

    //     final responseBody = json.decode(response.body);
    //     List<dynamic> datosFisicosJson;
    //     print(responseBody);

    //     // Procesar la respuesta y extraer los datos
    //     if (responseBody is Map<String, dynamic> && responseBody['data'] != null) {
    //       datosFisicosJson = responseBody['data'] as List<dynamic>;
    //     } else if (responseBody is List) {
    //       datosFisicosJson = responseBody;
    //     } else {
    //       throw Exception('El formato de la respuesta no es compatible.');
    //     }

    //     // Convertir la lista de JSON a una lista de objetos DatosFisicos
    //     final List<DatosFisicos> datosFisicos =
    //         datosFisicosJson.map((json) => DatosFisicos.fromJson(json)).toList();

    //     return ResponseApi(
    //       success: true,
    //       data: datosFisicos,
    //     );
    //   } catch (e) {
    //     print('Error: $e'); // Imprimir el error para depuración
    //     return ResponseApi(
    //       success: false,
    //       message: 'Ocurrió un error inesperado: $e',
    //     );
    //   }
    // }
  Future<ResponseApi> create(DatosHabitosAlimentacion datos) async {
    final dateFormat = DateFormat('yyyy-MM-dd');

    // Verificar campos requeridos
    if (datos.consumo_3_comidas_horario_fijo == null ||
        datos.consumo_5_porciones_frutas_verduras == null ||
        datos.consumo_3_porciones_proteinas == null ||
        datos.ingiero_otros_alimentos == null ||
        datos.consumo_carbohidratos == null ||
        datos.consumo_alimentos_fritos == null ||
        datos.consumo_alimentos_hechos_en_casa == null ||
        datos.consumo_liquidos_mientras_como == null ||
        datos.usuario == null) {
      return ResponseApi(
        success: false,
        message: 'Datos incompletos. Todos los campos deben estar llenos.',
      );
    }

    try {
      final formattedDate = dateFormat.format(datos.fecha!);

      final Map<String, dynamic> datosJson = {
        'consumo_3_comidas_horario_fijo': datos.consumo_3_comidas_horario_fijo,
        'consumo_5_porciones_frutas_verduras': datos.consumo_5_porciones_frutas_verduras,
        'consumo_3_porciones_proteinas': datos.consumo_3_porciones_proteinas,
        'ingiero_otros_alimentos': datos.ingiero_otros_alimentos,
        'consumo_carbohidratos': datos.consumo_carbohidratos,
        'consumo_alimentos_fritos': datos.consumo_alimentos_fritos,
        'consumo_alimentos_hechos_en_casa': datos.consumo_alimentos_hechos_en_casa,
        'consumo_liquidos_mientras_como': datos.consumo_liquidos_mientras_como,
        'fecha': formattedDate, // Fecha actual
        // ignore: equal_keys_in_map
        'usuario': datos.usuario, // Agrega el ID del usuario si es necesario
      };

      print('JSON a enviar: ${jsonEncode(datosJson)}');

      // Hacer la solicitud POST usando GetConnect
      final response = await http.post(
        Uri.parse('$url/datos-habitos-alimentacion/'),
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
