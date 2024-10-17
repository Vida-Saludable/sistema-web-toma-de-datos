// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/models/datos_habitos_alimentacion_model.dart';
import 'package:flutter_web_dashboard/providers/datos_habitos_alimentacion_provider.dart';
import 'package:get/get.dart';
import '../models/response_api.dart';

class DatosHabitosAlimentacionController extends GetxController {
  final TextEditingController consumo_3_comidas_horario_fijoController = TextEditingController();
  final TextEditingController consumo_5_porciones_frutas_verdurasController = TextEditingController();
  final TextEditingController consumo_3_porciones_proteinasController = TextEditingController();
  final TextEditingController ingiero_otros_alimentosController = TextEditingController();
  final TextEditingController consumo_carbohidratosController = TextEditingController();
  final TextEditingController consumo_alimentos_fritosController = TextEditingController();
  final TextEditingController consumo_alimentos_hechos_en_casaController = TextEditingController();
  final TextEditingController consumo_liquidos_mientras_comoController = TextEditingController();
  
  DatosHabitosAlimentacionProviders datosHabitosAlimentacionProviders = DatosHabitosAlimentacionProviders();

  var datosHabitosAlimentacion = <DatosHabitosAlimentacion>[].obs;

  @override
  void onInit() {
    super.onInit();
    // listarDatosHabitosAlimentacion();
  }

  void createDatosHabitosAlimentacion(String usuario) async {
    // Convertimos los valores a double, si no son válidos retornamos
    int? consumo_3_comidas_horario_fijo = int.tryParse(consumo_3_comidas_horario_fijoController.text.trim());
    int? consumo_5_porciones_frutas_verduras = int.tryParse(consumo_5_porciones_frutas_verdurasController.text.trim());
    int? consumo_3_porciones_proteinas = int.tryParse(consumo_3_porciones_proteinasController.text.trim());
    int? ingiero_otros_alimentos = int.tryParse(ingiero_otros_alimentosController.text.trim());
    int? consumo_carbohidratos = int.tryParse(consumo_carbohidratosController.text.trim());
    int? consumo_alimentos_fritos = int.tryParse(consumo_alimentos_fritosController.text.trim());
    int? consumo_alimentos_hechos_en_casa = int.tryParse(consumo_alimentos_hechos_en_casaController.text.trim());
    int? consumo_liquidos_mientras_como = int.tryParse(consumo_liquidos_mientras_comoController.text.trim());


    // Validamos que todos los campos estén llenos y sean válidos
    if (consumo_3_comidas_horario_fijo == null || consumo_5_porciones_frutas_verduras == null || consumo_3_porciones_proteinas == null || ingiero_otros_alimentos == null || 
        consumo_carbohidratos == null || consumo_alimentos_fritos == null || consumo_alimentos_hechos_en_casa == null || consumo_liquidos_mientras_como == null) {
      Get.snackbar('Formulario no válido', 'Todos los campos deben estar llenos y ser válidos');
      return;
    }

    // Creamos el objeto DatosHabitosAlimentacion
    DatosHabitosAlimentacion datos = DatosHabitosAlimentacion(
      consumo_3_comidas_horario_fijo: consumo_3_comidas_horario_fijo,
      consumo_5_porciones_frutas_verduras: consumo_5_porciones_frutas_verduras,
      consumo_3_porciones_proteinas: consumo_3_porciones_proteinas,
      ingiero_otros_alimentos: ingiero_otros_alimentos,
      consumo_carbohidratos: consumo_carbohidratos,
      consumo_alimentos_fritos: consumo_alimentos_fritos,
      consumo_alimentos_hechos_en_casa: consumo_alimentos_hechos_en_casa,
      consumo_liquidos_mientras_como: consumo_liquidos_mientras_como,
      fecha: DateTime.now(), // Fecha actual o puedes pasar una fecha específica
      usuario: usuario, // Cambia esto según el usuario autenticado
    );

    // Llamamos al método de creación en el provider
    ResponseApi responseApi = await datosHabitosAlimentacionProviders.create(datos);

    if (responseApi.success == true) {
      Get.snackbar('Registro exitoso', responseApi.message ?? '');
      // listarDatosHabitosAlimentacion(usuario);
      _clearControllers();
    } else {
      Get.snackbar('Error', responseApi.message ?? 'No se pudo registrar');
    }
  }

  void updateDatosHabitosAlimentacion(int id) async {
    // Implementación de la actualización similar a createDatosHabitosAlimentacion
  }

  void deleteDatosHabitosAlimentacion(int id) async {
    // Implementación del borrado
  }

  // void listarDatosHabitosAlimentacion(String usuario) async {
  //   ResponseApi responseApi = await datosHabitosAlimentacionProviders.getAll(usuario);
  //   if (responseApi.success == true) {
  //     datosHabitosAlimentacion.value = List<DatosHabitosAlimentacion>.from(responseApi.data);
  //   } else {
  //     print('Error al listar datos HabitosAlimentacion: ${responseApi.message}');
  //   }
  // }

      void _clearControllers() {
    // Método para limpiar los TextEditingControllers
    consumo_3_comidas_horario_fijoController.clear();
    consumo_5_porciones_frutas_verdurasController.clear();
    consumo_3_porciones_proteinasController.clear();
    ingiero_otros_alimentosController.clear();
    consumo_carbohidratosController.clear();
    consumo_alimentos_fritosController.clear();
    consumo_alimentos_hechos_en_casaController.clear();
    consumo_liquidos_mientras_comoController.clear();
  }

  void clearDatosHabitosAlimentacion() {
    datosHabitosAlimentacion.clear(); // Limpia los datos anteriores
  }
}
