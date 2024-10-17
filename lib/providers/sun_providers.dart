import 'package:flutter_web_dashboard/models/sun_models.dart';
import 'package:get/get.dart';
import '../environment/environment.dart';
import '../models/response_api.dart';

class SunProviders extends GetConnect {
  String url = Environment.API_URL + 'habits/soles/';

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
      List<dynamic> sunJson;
      print(responseBody);

      if (responseBody is Map<String, dynamic>) {
        sunJson = responseBody['data'] as List<dynamic>;
      } else if (responseBody is List) {
        sunJson = responseBody;
      } else {
        throw Exception('El formato de la respuesta no es compatible.');
      }

      final List<Sun> suns =
          sunJson.map((json) => Sun.fronJson(json)).toList();

      return ResponseApi(
        success: true,
        data: suns,
      );
    } catch (e) {
      return ResponseApi(
        success: false,
        message: 'Ocurrió un error inesperado: $e',
      );
    }
  }
}
