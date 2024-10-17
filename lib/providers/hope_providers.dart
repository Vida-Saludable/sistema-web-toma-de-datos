import 'package:flutter_web_dashboard/models/hope_models.dart';
import 'package:get/get.dart';
import '../environment/environment.dart';
import '../models/response_api.dart';

class HopeProviders extends GetConnect {
  String url = Environment.API_URL + 'habits/esperanzas/';

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
      List<dynamic> hopeJson;
      print(responseBody);

      if (responseBody is Map<String, dynamic>) {
        hopeJson = responseBody['data'] as List<dynamic>;
      } else if (responseBody is List) {
        hopeJson = responseBody;
      } else {
        throw Exception('El formato de la respuesta no es compatible.');
      }

      final List<Hope> hopes =
          hopeJson.map((json) => Hope.fronJson(json)).toList();

      return ResponseApi(
        success: true,
        data: hopes,
      );
    } catch (e) {
      return ResponseApi(
        success: false,
        message: 'Ocurrió un error inesperado: $e',
      );
    }
  }
}
