import 'package:flutter_web_dashboard/models/air_models.dart';
import 'package:get/get.dart';
import '../environment/environment.dart';
import '../models/response_api.dart';

class AirProviders extends GetConnect {
  String url = Environment.API_URL + 'habits/aires/';

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
      List<dynamic> airJson;
      print(responseBody);

      if (responseBody is Map<String, dynamic>) {
        airJson = responseBody['data'] as List<dynamic>;
      } else if (responseBody is List) {
        airJson = responseBody;
      } else {
        throw Exception('El formato de la respuesta no es compatible.');
      }

      final List<Air> airs =
          airJson.map((json) => Air.fronJson(json)).toList();

      return ResponseApi(
        success: true,
        data: airs,
      );
    } catch (e) {
      return ResponseApi(
        success: false,
        message: 'Ocurrió un error inesperado: $e',
      );
    }
  }
}
