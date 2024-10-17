import 'package:flutter_web_dashboard/models/report_general.dart';
import 'package:flutter_web_dashboard/providers/report_regeneral_providers.dart';
import 'package:get/get.dart';

import '../models/response_api.dart';

class ReporteController extends GetxController {
  final ReporteProviders reporteProviders = ReporteProviders();

  var reportes = <Reporte>[].obs;

  @override
  void onInit() {
    super.onInit();
    listarReportes();
  }

  void listarReportes() async {
    ResponseApi responseApi = await reporteProviders.getAll();
    if (responseApi.success == true) {
      reportes.value = List<Reporte>.from(responseApi.data);
    } else {
      print('Error al listar reportes: ${responseApi.message}');
    }
  }
}
