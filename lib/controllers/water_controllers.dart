import 'package:flutter_web_dashboard/models/water_models.dart';
import 'package:flutter_web_dashboard/providers/water_providers.dart';
import 'package:get/get.dart';

import '../models/response_api.dart';

class WaterController extends GetxController {

  WaterProviders waterProviders = WaterProviders();

  var waters = <Water>[].obs;


  @override
  void onInit() {
    super.onInit();
    // listarAguas();
  }

  void listarAguas() async {
    ResponseApi responseApi = await waterProviders.getAll();
    if (responseApi.success == true) {
      waters.value = List<Water>.from(responseApi.data);
    } else {
      print('Error al listar registro de agua: ${responseApi.message}');
    }
  }

}
