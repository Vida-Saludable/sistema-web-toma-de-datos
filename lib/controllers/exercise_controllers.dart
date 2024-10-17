import 'package:flutter_web_dashboard/models/exercise_models.dart';
import 'package:flutter_web_dashboard/providers/exercise_providers.dart';
import 'package:get/get.dart';

import '../models/response_api.dart';

class ExerciseController extends GetxController {

  ExerciseProviders exerciseProviders = ExerciseProviders();

  var exercises = <Exercise>[].obs;


  @override
  void onInit() {
    super.onInit();
    // listarExercisees();
  }

  void listarExercisees() async {
    ResponseApi responseApi = await exerciseProviders.getAll();
    if (responseApi.success == true) {
      exercises.value = List<Exercise>.from(responseApi.data);
    } else {
      print('Error al listar registro de agua: ${responseApi.message}');
    }
  }

}
