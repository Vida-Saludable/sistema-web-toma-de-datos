// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/controllers/patient_controllers.dart';
import 'package:flutter_web_dashboard/models/patient_models.dart';
import 'package:flutter_web_dashboard/pages/drivers/widgets/custom_analisys_dialog.dart';
import 'package:flutter_web_dashboard/pages/patient/widgets/questions_dialog.dart';
import 'package:get/get.dart';

class PatientTable extends StatelessWidget {
  const PatientTable({super.key});

  void _showDialog(BuildContext context, String patientId, String patientName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAnalysisDialog(
          patientId: patientId, // Asegúrate de pasar el ID del paciente
          patientName: patientName, // Asegúrate de pasar el nombre del paciente
        );
      },
    );
  }

  void _showDialogQuestion(
      BuildContext context, String patientId, String patientName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomQuestionsDialog(
          patientId: patientId, // Asegúrate de pasar el ID del paciente
          patientName: patientName, // Asegúrate de pasar el nombre del paciente
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final UsersController usersController = Get.find<UsersController>();
    final PatientController patientController = Get.put(PatientController());

    return Obx(() {
      // Mensaje cuando no hay pacientes
      if (patientController.patients.isEmpty) {
        return Center(child: Text('No hay pacientes disponibles'));
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 600;

          return Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 30),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  if (isWideScreen)
                    _buildWideScreenContent(patientController.patients, context)
                  else
                    _buildNarrowScreenContent(
                        patientController.patients, context),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildHeaderCell('ID'),
          _buildHeaderCell('Nombre'),
          _buildHeaderCell('Correo'),
          _buildHeaderCell('Proyecto'),
          _buildHeaderCell('Rol'),
          _buildHeaderCell('Acción'),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildWideScreenContent(
      RxList<Patient> patients, BuildContext context) {
    return Column(
      children: List.generate(patients.length, (index) {
        final paciente = patients[index]; // Acceder al objeto Patient
        return _buildPatientRow(paciente, index + 1, context);
      }),
    );
  }

  Widget _buildPatientRow(Patient paciente, int index, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildContentCell(index.toString(), context),
          _buildContentCell(paciente.nombre, context),
          _buildContentCell(paciente.correo ?? 'No disponible', context),
          _buildContentCell(
              paciente.proyectos.join(', '), context), // Mostrar proyectos
          _buildContentCell(paciente.role ?? 'No disponible', context),
          _buildActionButtons(context,
              paciente), // Asegúrate de que el botón de acción acepte Patient
        ],
      ),
    );
  }

  String _buildProjectsList(List<dynamic> proyectos) {
    if (proyectos == null || proyectos.isEmpty) {
      return 'No hay proyectos';
    }
    return proyectos
        .join(', '); // Une los nombres de los proyectos con una coma
  }

  Widget _buildContentCell(String content, BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width < 600
                  ? 14
                  : 16), // Tamaño de texto adaptable
        ),
      ),
    );
  }

Widget _buildActionButtons(BuildContext context, Patient paciente) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          onPressed: () {
            _showEditDialog(context, paciente);
          },
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Cambia el valor si necesitas un borderRadius diferente
            ),
            side: const BorderSide(color: Colors.indigo), // Color del borde
          ).copyWith(
            overlayColor:
              MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered)) {
                    return Colors.indigo.withOpacity(0.1);
                  }
                    return null;
                },
              ),
          ),
          child: const Icon(Icons.edit, color: Colors.indigo, size: 20),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: () => _showDialog(context, paciente.id.toString(), paciente.nombre),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Cambia el valor si necesitas un borderRadius diferente
            ),
            side: const BorderSide(color: Colors.green), // Color del borde
          ).copyWith(
            overlayColor:
              MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered)) {
                    return Colors.green.withOpacity(0.1);
                  }
                    return null;
                },
              ),
          ),
          child: const Icon(Icons.add_chart_rounded, color: Colors.green, size: 20),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: () => _showDialogQuestion(context, paciente.id.toString(), paciente.nombre),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Cambia el valor si necesitas un borderRadius diferente
            ),
            side: const BorderSide(color: Color.fromARGB(255, 39, 133, 176)), // Color del borde
          ).copyWith(
            overlayColor:
              MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered)) {
                    return Color.fromARGB(255, 39, 133, 176).withOpacity(0.1);
                  }
                    return null;
                },
              ),
          ),
          child: const Icon(Icons.question_answer, color: Color.fromARGB(255, 39, 133, 176), size: 20),
        ),
      ],
    ),
  );
}


  Widget _buildNarrowScreenContent(
      RxList<Patient> patients, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: List.generate(patients.length, (index) {
          final paciente = patients[index]; // Acceder al objeto Patient
          return _buildNarrowPatientRow(paciente);
        }),
      ),
    );
  }

  Widget _buildNarrowPatientRow(Patient paciente) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildRow('N°', paciente.id.toString()),
          _buildRow('Correo', paciente.correo ?? 'No disponible'),
          _buildRow('Nombre', paciente.nombre ?? 'No disponible'),
          _buildRow(
              'Proyectos', paciente.proyectos.join(', ')), // Mostrar proyectos
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.indigo),
                  onPressed: () {
                    // Lógica de edición aquí
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Lógica de eliminación aquí
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 2,
              child:
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 5, child: Text(content)),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, usuario) {

    // final UsersController userController = Get.find<UsersController>();
    final PatientController patientController = Get.find<PatientController>();
    List<String> selectedProjectIds = [];

    patientController.correoController.text = usuario.correo ?? '';
    patientController.nombreController.text = usuario.nombre ?? '';
    patientController.roleController.text = usuario.role ?? '';
    // userController.proyectos_idsController.text = usuario.proyectos_ids ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.5, // Max width
            ),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                bool isWideScreen =
                    constraints.maxWidth > 600; // Arbitrary breakpoint

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Editar Información',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: isWideScreen
                              ? [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller:
                                              patientController.nombreController,
                                          decoration: InputDecoration(
                                            labelText: 'Nombre Completo',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: TextField(
                                          controller:
                                              patientController.correoController,
                                          decoration: InputDecoration(
                                            labelText: 'Correo Electrónico',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Obx(() =>
                                            DropdownButtonFormField<int>(
                                              decoration: InputDecoration(
                                                labelText: 'Rol',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              items: patientController.roles
                                                  .map((role) {
                                                return DropdownMenuItem<int>(
                                                  value: role.id ?? 0,
                                                  child: Text(role.name ?? ''),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                patientController.roleController
                                                    .text = value.toString();
                                              },
                                            )),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Obx(() =>
                                            DropdownButtonFormField<int>(
                                              decoration: InputDecoration(
                                                labelText: 'Proyecto',
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                              items: patientController.proyectos.map((proyecto) {
                                                return DropdownMenuItem<int>(
                                                  value: proyecto.id,
                                                  child: Text(proyecto.nombre ?? ''),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                // Actualiza la lista de selectedProjectIds
                                                selectedProjectIds.clear();
                                                if (value != null) {
                                                  selectedProjectIds.add(value.toString());
                                                }

                                                // También actualiza el controlador si es necesario
                                                patientController.proyectos_idsController.text = value?.toString() ?? '';
                                              },
                                            ),

                                            ),
                                      ),
                                    ],
                                  ),
                                ]
                              : [
                                  TextField(
                                    controller: patientController.nombreController,
                                    decoration: InputDecoration(
                                      labelText: 'Nombre Completo',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  TextField(
                                    controller: patientController.correoController,
                                    decoration: InputDecoration(
                                      labelText: 'Correo Electrónico',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 16),
                                  DropdownButtonFormField<int>(
                                    decoration: InputDecoration(
                                      labelText: 'Rol',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    items: patientController.roles.map((role) {
                                      return DropdownMenuItem<int>(
                                        value: role.id,
                                        child: Text(role.name ?? ''),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      // selectedRoleId = value;
                                      patientController.roleController.text =
                                          value.toString();
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  DropdownButtonFormField<int>(
                                    decoration: InputDecoration(
                                      labelText: 'Proyecto',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    items: patientController.proyectos.map((proyecto) {
                                      return DropdownMenuItem<int>(
                                        value: proyecto.id,
                                        child: Text(proyecto.nombre ?? ''),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      // Actualiza la lista de selectedProjectIds
                                      selectedProjectIds.clear();
                                      if (value != null) {
                                        selectedProjectIds.add(value.toString());
                                      }

                                      // También actualiza el controlador si es necesario
                                      patientController.proyectos_idsController.text = value?.toString() ?? '';
                                    },
                                  ),
                                ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text('Cancelar'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                patientController.updateUsuario(int.parse(usuario.id.toString()),selectedProjectIds);
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.indigo,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                elevation: 5,
                                shadowColor: Colors.indigo.withOpacity(0.2),
                              ),
                              child: const Text('Guardar'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
