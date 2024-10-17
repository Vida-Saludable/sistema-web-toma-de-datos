import 'package:flutter_web_dashboard/models/rest_models.dart';
import 'package:flutter_web_dashboard/providers/rest_providers.dart';
import 'package:get/get.dart';

import '../models/response_api.dart';

class RestController extends GetxController {

  RestProviders restProviders = RestProviders();

  var rest = <Rest>[].obs;


  @override
  void onInit() {
    super.onInit();
    // listarAires();
  }

  void listarDescanso() async {
    ResponseApi responseApi = await restProviders.getAll();
    if (responseApi.success == true) {
      rest.value = List<Rest>.from(responseApi.data);
    } else {
      print('Error al listar registro de descanso: ${responseApi.message}');
    }
  }

}
