import 'package:flutter_web_dashboard/models/role_models.dart';
import 'package:get/get.dart';
import '../environment/environment.dart';
import '../models/response_api.dart';

class RoleProviders extends GetConnect {
  String url = Environment.API_URL + 'users/roles/';

  Future<ResponseApi> getAll() async {
    try {
      final response = await get(
          '${url}');
      print(response.statusCode);
      if (response.status.hasError) {
        print('Error de conexión: ${response.statusText}');
        print('Código de estado: ${response.statusCode}');
        print('Respuesta: ${response.bodyString}');
        return ResponseApi(
          success: false,
          message: 'Error de conexión: ${response.statusText}',
        );
      }

      final responseBody = response.body;
      List<dynamic> roleJson;
      print(responseBody);

      if (responseBody is Map<String, dynamic>) {
        roleJson = responseBody['data'] as List<dynamic>;
      } else if (responseBody is List) {
        roleJson = responseBody;
      } else {
        throw Exception('El formato de la respuesta no es compatible.');
      }

      final List<Role> roles =
          roleJson.map((json) => Role.fromJson(json)).toList();

      return ResponseApi(
        success: true,
        data: roles,
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
