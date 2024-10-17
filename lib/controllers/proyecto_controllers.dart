import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/models/proyecto_models.dart';
import 'package:flutter_web_dashboard/providers/proyecto_providers.dart';
import 'package:get/get.dart';

import '../models/response_api.dart';

class Estado {
  final int id;
  final String nombre;

  Estado({required this.id, required this.nombre});
}
class ProyectoController extends GetxController {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();

  ProyectoProviders proyectoProviders = ProyectoProviders();

  var proyectos = <Proyecto>[].obs; // Lista observable de proyectos

  var estados = [
  Estado(id: 1, nombre: 'Activo'),
  Estado(id: 0, nombre: 'Inactivo'),
];


  @override
  void onInit() {
    super.onInit();
    listarProyectos();
  }

  Future<void> selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      controller.text = "${pickedDate.toLocal()}".split(' ')[0];
    }
  }

  void createProyecto() async {
    String nombre = nombreController.text.trim();
    String descripcion = descripcionController.text.trim();
    String startDateText = startDateController.text.trim();
    String endDateText = endDateController.text.trim();
    String estadoText = estadoController.text.trim();

    if (nombre.isEmpty || startDateText.isEmpty || endDateText.isEmpty || descripcion.isEmpty) {
      Get.snackbar(
          'Formulario no válido', 'Todos los campos deben estar llenos');
      return;
    }

    DateTime? dateTimeInicio = DateTime.tryParse(startDateText);
    DateTime? dateTimeFin = DateTime.tryParse(endDateText);

    if (dateTimeInicio == null || dateTimeFin == null) {
      Get.snackbar(
          'Fecha no válida', 'Las fechas proporcionadas no son válidas');
      return;
    }

      int? estado = int.tryParse(estadoText);

    if (estado == null) {
      Get.snackbar('Estado no válido', 'El estado proporcionado no es un número válido');
    return;
    }

    Proyecto proyecto = Proyecto(
      nombre: nombre,
      descripcion: descripcion,
      fecha_inicio: dateTimeInicio,
      fecha_fin: dateTimeFin,
      estado: estado,
    );

    ResponseApi responseApi = await proyectoProviders.create(proyecto);

    if (responseApi.success == true) {
      Get.snackbar('Registro exitoso', responseApi.message ?? '');
      listarProyectos();
      _clearControllers();
    } else {
      Get.snackbar('Error', responseApi.message ?? 'No se pudo registrar');
    }
  }

  void updateProyecto(int id) async {
    String nombre = nombreController.text.trim();
    String descripcion = descripcionController.text.trim();
    String startDateText = startDateController.text.trim();
    String endDateText = endDateController.text.trim();

    if (nombre.isEmpty || startDateText.isEmpty || endDateText.isEmpty || descripcion.isEmpty) {
      Get.snackbar(
          'Formulario no válido', 'Todos los campos deben estar llenos');
      return;
    }

    DateTime? dateTimeInicio = DateTime.tryParse(startDateText);
    DateTime? dateTimeFin = DateTime.tryParse(endDateText);

    if (dateTimeInicio == null || dateTimeFin == null) {
      Get.snackbar(
          'Fecha no válida', 'Las fechas proporcionadas no son válidas');
      return;
    }

    Proyecto proyecto = Proyecto(
      id: id,
      nombre: nombre,
      descripcion: descripcion,
      fecha_inicio: dateTimeInicio,
      fecha_fin: dateTimeFin,
    );

    ResponseApi responseApi = await proyectoProviders.update(proyecto);

    if (responseApi.success == true) {
      Get.snackbar('Actualización exitosa', responseApi.message ?? '');
      listarProyectos();
      _clearControllers();
    } else {
      Get.snackbar('Error', responseApi.message ?? 'No se pudo actualizar');
    }
  }

void deleteProyecto(int id) async {
  try {
    ResponseApi responseApi = await proyectoProviders.deleteProyecto(id);

    if (responseApi.success == true) {
      proyectos.removeWhere((proyecto) => proyecto.id == id);
      Get.snackbar('Eliminación exitosa', responseApi.message ?? '');
    } else {
      Get.snackbar('Error', responseApi.message ?? 'No se pudo eliminar el proyecto');
    }
  } catch (e) {
    Get.snackbar('Error', 'Hubo un problema al intentar eliminar el proyecto');
  } finally {
    listarProyectos();
  }
}



  void listarProyectos() async {
    ResponseApi responseApi = await proyectoProviders.getAll();
    if (responseApi.success == true) {
      proyectos.value = List<Proyecto>.from(responseApi.data);
    } else {
      print('Error al listar proyectos: ${responseApi.message}');
    }
  }

  void updateProyectoEstado(String? id, int estado) async {
  if (id == null) return; // Manejo de caso nulo si es necesario

  int proyectoId = int.tryParse(id) ?? 0;

  Proyecto proyecto = Proyecto(
    id: proyectoId,
    estado: estado,
  );

  ResponseApi responseApi = await proyectoProviders.updateEstado(proyecto);

  if (responseApi.success == true) {
    Get.snackbar('Actualización exitosa', 'Cambio de estado exitoso');
    listarProyectos();
  } else {
    Get.snackbar('Error', responseApi.message ?? 'No se pudo actualizar');
  }
}

  void _clearControllers() {
    // Método para limpiar los TextEditingControllers
    nombreController.clear();
    descripcionController.clear();
    startDateController.clear();
    endDateController.clear();
  }


}
