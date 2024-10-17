import 'package:flutter_web_dashboard/models/water_models.dart';
import 'package:get/get.dart';
import '../environment/environment.dart';
import '../models/response_api.dart';

class WaterProviders extends GetConnect {
  String url = Environment.API_URL + 'habits/aguas/';

  Future<ResponseApi> getAll() async {
    try {
      final response = await get(
          '${url}');
      if (response.status.hasError) {
        return ResponseApi(
          success: false,
          message: 'Error de conexión: ${response.statusText}',
        );
      }

      final responseBody = response.body;
      List<dynamic> waterJson;
      print(responseBody);

      if (responseBody is Map<String, dynamic>) {
        waterJson = responseBody['data'] as List<dynamic>;
      } else if (responseBody is List) {
        waterJson = responseBody;
      } else {
        throw Exception('El formato de la respuesta no es compatible.');
      }

      final List<Water> waters =
          waterJson.map((json) => Water.fronJson(json)).toList();

      return ResponseApi(
        success: true,
        data: waters,
      );
    } catch (e) {
      print('Excepción capturada: $e');
      return ResponseApi(
        success: false,
        message: 'Ocurrió un error inesperado: $e',
      );
    }
  }
}
