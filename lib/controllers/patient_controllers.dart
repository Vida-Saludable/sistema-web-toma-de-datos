import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/models/patient_models.dart';
import 'package:flutter_web_dashboard/models/proyecto_models.dart';
import 'package:flutter_web_dashboard/models/role_models.dart';
import 'package:flutter_web_dashboard/models/user_models.dart';
import 'package:flutter_web_dashboard/providers/patient_providers.dart';
import 'package:flutter_web_dashboard/providers/proyecto_providers.dart';
import 'package:flutter_web_dashboard/providers/role_providers.dart';
import 'package:get/get.dart';
import '../models/response_api.dart';

class PatientController extends GetxController {
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contraseniaController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController proyectos_idsController = TextEditingController();

  PatientProvider patientProvider = PatientProvider();
  ProyectoProviders proyectoProviders = ProyectoProviders();
  RoleProviders roleProviders = RoleProviders();

  var patients = <Patient>[].obs; // Cambiado a "patients"
  var proyectos = <Proyecto>[].obs;
  var roles = <Role>[].obs;

  @override
  void onInit() {
    super.onInit();
    listarPacientes();
    listarProyectos();
    listarRoles();
  }

    void listarRoles() async {
    ResponseApi responseApi = await roleProviders.getAll();
    if (responseApi.success == true) {
      roles.value = List<Role>.from(responseApi.data);
    } else {
      print('Error al listar roles: ${responseApi.message}');
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

  void listarPacientes() async {
    ResponseApi responseApi = await patientProvider.getAll();
    if (responseApi.success == true) {
      patients.value = List<Patient>.from(responseApi.data);
    } else {
      print('Error al listar pacientes: ${responseApi.message}');
      // Puedes mostrar un mensaje en la UI o hacer otra cosa
    }
  }

    void updateUsuario(int id, List<String> proyectosIds) async {
    String correo = correoController.text.trim();
    String roleId = roleController.text.trim(); // Asegúrate de que esto contenga el ID del rol
    String nombre = nombreController.text.trim();

    // Validación de campos
    if (correo.isEmpty || roleId.isEmpty || nombre.isEmpty) {
      Get.snackbar('Formulario no válido', 'Todos los campos deben estar llenos');
      return;
    }

    List<Proyectos> proyectos = proyectosIds.map((id) => Proyectos(id: int.parse(id))).toList();

    // Crear el objeto User con el ID del rol
    User user = User(
      id: id,
      correo: correo,
      role: roleId, // Asegúrate de que se esté utilizando el ID del rol
      nombre: nombre,
      proyectos: proyectos,
    );

    // Mostrar un indicador de carga
    Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);

    try {
      // Llamar al método update en el provider para enviar la solicitud de actualización
      ResponseApi responseApi = await patientProvider.update(user);

      // Cerrar el indicador de carga
      Get.back();

      if (responseApi.success == true) {
        Get.snackbar('Actualización exitosa', responseApi.message ?? '');
        listarPacientes();
      } else {
        Get.snackbar('Error', responseApi.message ?? 'No se pudo actualizar');
      }
    } catch (e) {
      // Manejo de errores inesperados
      Get.back(); // Cerrar el indicador de carga
      Get.snackbar('Error', 'Ocurrió un error inesperado: $e');
    }
  }
}
