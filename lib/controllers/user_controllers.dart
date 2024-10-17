import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/controllers/patient_controllers.dart';
import 'package:flutter_web_dashboard/models/proyecto_models.dart';
import 'package:flutter_web_dashboard/models/proyectos_usuarios_model.dart';
import 'package:flutter_web_dashboard/models/role_models.dart';
import 'package:flutter_web_dashboard/models/user_models.dart';
import 'package:flutter_web_dashboard/providers/proyecto_providers.dart';
import 'package:flutter_web_dashboard/providers/role_providers.dart';
import 'package:flutter_web_dashboard/providers/user_providers.dart';
import 'package:get/get.dart';

import '../models/response_api.dart';

class UsersController extends GetxController {
  final PatientController patientController = Get.find();

  final TextEditingController correoController = TextEditingController();
  final TextEditingController contraseniaController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController proyectos_idsController = TextEditingController();

  final TextEditingController proyecto_idController = TextEditingController();
  // final TextEditingController usuario_idController= TextEditingController();

  UsersProviders userProviders = UsersProviders();
  ProyectoProviders proyectoProviders = ProyectoProviders();
  RoleProviders roleProviders = RoleProviders();

  var proyectos = <Proyecto>[].obs;
  var proyectosUser = <Proyecto>[].obs;
  var roles = <Role>[].obs;
  var users = <User>[].obs;

  @override
  void onInit() {
    super.onInit();
    listarUsuarios();
    listarProyectos();
    listarRoles();
  }

    void listarUsuarios() async {
    ResponseApi responseApi = await userProviders.getAll();
    if (responseApi.success == true) {
      users.value = List<User>.from(responseApi.data);
    } else {
      print('Error al listar usuarios: ${responseApi.message}');
    }
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

void createUser(List<String> proyectosIds) async {
  String correo = correoController.text.trim();
  String contrasenia = contraseniaController.text.trim();
  String role = roleController.text.trim();
  String nombre = nombreController.text.trim();

  if (correo.isEmpty || contrasenia.isEmpty || nombre.isEmpty || proyectosIds.isEmpty) {
    Get.snackbar('Formulario no válido', 'Todos los campos deben estar llenos');
    return;
  }

  // Convertir los IDs de los proyectos en una lista de objetos Proyecto
  List<Proyectos> proyectos = proyectosIds.map((id) => Proyectos(id: int.parse(id))).toList();

  // Crear el objeto User con la lista de proyectos convertida
  User user = User(
    correo: correo,
    contrasenia: contrasenia,
    role: role,
    nombre: nombre,
    proyectos: proyectos,  // Lista de Proyecto
  );

  // Llamar al método create en el provider para enviar la solicitud
  ResponseApi responseApi = await userProviders.create(user);

  // Verificar el resultado de la creación del usuario
  if (responseApi.success == true) {
    Get.snackbar('Registro exitoso', responseApi.message ?? '');
    listarUsuarios();  // Método para listar los usuarios después de crear uno nuevo
    patientController.listarPacientes(); // Actualizar la lista de pacientes
    _clearControllers();
  } else {
    Get.snackbar('Error', responseApi.message ?? 'No se pudo registrar');
  }
}


  void updateUsuario(int id) async {
    String correo = correoController.text.trim();
    String roleId = roleController.text.trim(); // Asegúrate de que esto contenga el ID del rol
    String nombre = nombreController.text.trim();

    // Validación de campos
    if (correo.isEmpty || roleId.isEmpty || nombre.isEmpty) {
      Get.snackbar('Formulario no válido', 'Todos los campos deben estar llenos');
      return;
    }

    // Crear el objeto User con el ID del rol
    User user = User(
      id: id,
      correo: correo,
      role: roleId, // Asegúrate de que se esté utilizando el ID del rol
      nombre: nombre,
    );

    // Mostrar un indicador de carga
    Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);

    try {
      // Llamar al método update en el provider para enviar la solicitud de actualización
      ResponseApi responseApi = await userProviders.update(user);

      // Cerrar el indicador de carga
      Get.back();

      if (responseApi.success == true) {
        Get.snackbar('Actualización exitosa', responseApi.message ?? '');
        listarUsuarios();
        _clearControllers();
      } else {
        Get.snackbar('Error', responseApi.message ?? 'No se pudo actualizar');
      }
    } catch (e) {
      // Manejo de errores inesperados
      Get.back(); // Cerrar el indicador de carga
      Get.snackbar('Error', 'Ocurrió un error inesperado: $e');
    }
  }

  void listarProyectosUsuarios(int id) async {
    ResponseApi responseApi = await proyectoProviders.getProyectoUsuario(id);
    if (responseApi.success == true) {
      proyectosUser.value = List<Proyecto>.from(responseApi.data);
    } else {
      print('Error al listar proyectos de Usuarios: ${responseApi.message}');
    }
  }

  void deleteProyectoAsignado(int id, int usuario) async {
    try {
      ResponseApi responseApi = await proyectoProviders.deleteProyectoAsignado(id);

      if (responseApi.success == true) {
        proyectosUser.removeWhere((proyectoUser) => proyectoUser.id == id);
        Get.snackbar('Eliminación exitosa', responseApi.message ?? '');
      } else {
        Get.snackbar('Error', responseApi.message ?? 'No se pudo eliminar el proyecto');
      }
    } catch (e) {
      Get.snackbar('Error', 'Hubo un problema al intentar eliminar el proyecto');
    } finally {
      listarProyectosUsuarios(usuario);
    }
  }

  void asignarProyecto(int usuario) async {

  int? proyecto = int.tryParse(proyecto_idController.text.trim());
  UsuarioProyecto asignarProyecto = UsuarioProyecto(
    usuario: usuario,
    proyecto: proyecto,
  );

  ResponseApi responseApi = await proyectoProviders.asignarProyecto(asignarProyecto);

  // Verificar el resultado de la creación del usuario
  if (responseApi.success == true) {
    Get.snackbar('Registro exitoso', responseApi.message ?? '');
    listarProyectosUsuarios(usuario);
  } else {
    Get.snackbar('Error', responseApi.message ?? 'No se pudo registrar');
  }
}

  void _clearControllers() {
    correoController.clear();
    contraseniaController.clear();
    nombreController.clear();
  }

}
