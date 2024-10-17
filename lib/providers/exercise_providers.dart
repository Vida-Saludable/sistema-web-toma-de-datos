import 'package:flutter_web_dashboard/models/exercise_models.dart';
import 'package:get/get.dart';
import '../environment/environment.dart';
import '../models/response_api.dart';

class ExerciseProviders extends GetConnect {
  String url = Environment.API_URL + 'habits/ejercicios/';

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
      List<dynamic> exerciseJson;
      print(responseBody);

      if (responseBody is Map<String, dynamic>) {
        exerciseJson = responseBody['data'] as List<dynamic>;
      } else if (responseBody is List) {
        exerciseJson = responseBody;
      } else {
        throw Exception('El formato de la respuesta no es compatible.');
      }

      final List<Exercise> exercises =
          exerciseJson.map((json) => Exercise.fronJson(json)).toList();

      return ResponseApi(
        success: true,
        data: exercises,
      );
    } catch (e) {
      return ResponseApi(
        success: false,
        message: 'Ocurrió un error inesperado: $e',
      );
    }
  }
}
