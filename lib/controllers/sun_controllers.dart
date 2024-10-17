import 'package:flutter_web_dashboard/models/sun_models.dart';
import 'package:flutter_web_dashboard/providers/sun_providers.dart';
import 'package:get/get.dart';

import '../models/response_api.dart';

class SunController extends GetxController {

  SunProviders sunProviders = SunProviders();

  var suns = <Sun>[].obs;


  @override
  void onInit() {
    super.onInit();
    // listarSuns();
  }

  void listarSuns() async {
    ResponseApi responseApi = await sunProviders.getAll();
    if (responseApi.success == true) {
      suns.value = List<Sun>.from(responseApi.data);
    } else {
      print('Error al listar registro de agua: ${responseApi.message}');
    }
  }

}
