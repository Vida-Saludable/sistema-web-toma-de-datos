import 'package:flutter_web_dashboard/models/air_models.dart';
import 'package:flutter_web_dashboard/providers/air_providers.dart';
import 'package:get/get.dart';

import '../models/response_api.dart';

class AirController extends GetxController {

  AirProviders airProviders = AirProviders();

  var airs = <Air>[].obs;


  @override
  void onInit() {
    super.onInit();
    // listarAires();
  }

  void listarAires() async {
    ResponseApi responseApi = await airProviders.getAll();
    if (responseApi.success == true) {
      airs.value = List<Air>.from(responseApi.data);
    } else {
      print('Error al listar registro de agua: ${responseApi.message}');
    }
  }

}
