import 'package:flutter_web_dashboard/models/rest_models.dart';
import 'package:get/get.dart';
import '../environment/environment.dart';
import '../models/response_api.dart';

class RestProviders extends GetConnect {
  String url = Environment.API_URL + 'habits/sleeps/';

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
      List<dynamic> restJson;
      print(responseBody);

      if (responseBody is Map<String, dynamic>) {
        restJson = responseBody['data'] as List<dynamic>;
      } else if (responseBody is List) {
        restJson = responseBody;
      } else {
        throw Exception('El formato de la respuesta no es compatible.');
      }

      final List<Rest> rest =
          restJson.map((json) => Rest.fronJson(json)).toList();

      return ResponseApi(
        success: true,
        data: rest,
      );
    } catch (e) {
      return ResponseApi(
        success: false,
        message: 'Ocurrió un error inesperado: $e',
      );
    }
  }
}
