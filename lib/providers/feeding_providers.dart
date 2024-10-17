import 'package:flutter_web_dashboard/models/feeding_models.dart';
import 'package:get/get.dart';
import '../environment/environment.dart';
import '../models/response_api.dart';

class FeedingProviders extends GetConnect {
  String url = Environment.API_URL + 'habits/alimentaciones/';

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
      List<dynamic> feedingJson;
      print(responseBody);

      if (responseBody is Map<String, dynamic>) {
        feedingJson = responseBody['data'] as List<dynamic>;
      } else if (responseBody is List) {
        feedingJson = responseBody;
      } else {
        throw Exception('El formato de la respuesta no es compatible.');
      }

      final List<Feeding> feedings =
          feedingJson.map((json) => Feeding.fronJson(json)).toList();

      return ResponseApi(
        success: true,
        data: feedings,
      );
    } catch (e) {
      return ResponseApi(
        success: false,
        message: 'Ocurrió un error inesperado: $e',
      );
    }
  }
}
