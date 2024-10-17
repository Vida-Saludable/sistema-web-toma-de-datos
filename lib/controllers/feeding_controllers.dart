import 'package:flutter_web_dashboard/models/feeding_models.dart';
import 'package:flutter_web_dashboard/providers/feeding_providers.dart';
import 'package:get/get.dart';

import '../models/response_api.dart';

class FeedingController extends GetxController {

  FeedingProviders feedingProviders = FeedingProviders();

  var feedings = <Feeding>[].obs;


  @override
  void onInit() {
    super.onInit();
    // listarFeedinges();
  }

  void listarAlimentacion() async {
    ResponseApi responseApi = await feedingProviders.getAll();
    if (responseApi.success == true) {
      feedings.value = List<Feeding>.from(responseApi.data);
    } else {
      print('Error al listar registro de Alimentacion: ${responseApi.message}');
    }
  }

}
