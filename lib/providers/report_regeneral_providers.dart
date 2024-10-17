import 'package:flutter_web_dashboard/models/report_general.dart';
import 'package:get/get.dart';
import '../environment/environment.dart';
import '../models/response_api.dart';

class ReporteProviders extends GetConnect {
  String url = Environment.API_URL + 'reports/registros-diarios/'; // Cambia la URL según tu API

  Future<ResponseApi> getAll() async {
    try {
      final response = await get('${url}');
      if (response.status.hasError) {
        return ResponseApi(
          success: false,
          message: 'Error de conexión: ${response.statusText}',
        );
      }

      final responseBody = response.body;
      List<dynamic> reportesJson;
      print(responseBody);

      if (responseBody is Map<String, dynamic>) {
        reportesJson = responseBody['data'] as List<dynamic>;
      } else if (responseBody is List) {
        reportesJson = responseBody;
      } else {
        throw Exception('El formato de la respuesta no es compatible.');
      }

      final List<Reporte> reportes =
          reportesJson.map((json) => Reporte.fromJson(json)).toList();

      return ResponseApi(
        success: true,
        data: reportes,
      );
    } catch (e) {
      return ResponseApi(
        success: false,
        message: 'Ocurrió un error inesperado: $e',
      );
    }
  }
}
