import 'package:flutter_web_dashboard/models/hope_models.dart';
import 'package:flutter_web_dashboard/providers/hope_providers.dart';
import 'package:get/get.dart';

import '../models/response_api.dart';

class HopeController extends GetxController {

  HopeProviders hopeProviders = HopeProviders();

  var hope = <Hope>[].obs;


  @override
  void onInit() {
    super.onInit();
    // listarAires();
  }

  void listarEsperanza() async {
    ResponseApi responseApi = await hopeProviders.getAll();
    if (responseApi.success == true) {
      hope.value = List<Hope>.from(responseApi.data);
    } else {
      print('Error al listar registro de Esperanza: ${responseApi.message}');
    }
  }

}
