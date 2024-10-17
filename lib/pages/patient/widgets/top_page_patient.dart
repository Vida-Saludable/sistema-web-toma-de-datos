// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/controllers/user_controllers.dart';
import 'package:get/get.dart';


class TopPagePatient extends StatefulWidget {
  const TopPagePatient({Key? key}) : super(key: key);

  @override
  _TopPagePatientState createState() => _TopPagePatientState();
}

class _TopPagePatientState extends State<TopPagePatient> {
  late final UsersController _userController;

  @override
  void initState() {
    super.initState();
    _userController = Get.put(UsersController()); // Inicializa el controlador aquí
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Buscar...",
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 50),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showRegisterDialog(context);
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    "Registrar",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    elevation: 5,
                    shadowColor: Colors.indigo.withOpacity(0.5),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

void _showRegisterDialog(BuildContext context) {
  List<String> selectedProjectIds = [];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.5,
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              bool isWideScreen = constraints.maxWidth > 600;

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity, // Ocupar todo el ancho
                      decoration: const BoxDecoration(
                        color: Colors.indigo, // Color de fondo del encabezado
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10), // Igual que el diálogo
                          topRight: Radius.circular(10), // Igual que el diálogo
                        ),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: const Center( // Centrar el texto
                              child: Text(
                                'Registrar Paciente',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Color del texto
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close, // Icono de cerrar
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(); // Cerrar el diálogo
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15), // Espaciado entre header y inputs
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: isWideScreen
                            ? [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _userController.nombreController,
                                        decoration: InputDecoration(
                                          labelText: 'Nombre completo',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextField(
                                        controller: _userController.correoController,
                                        decoration: InputDecoration(
                                          labelText: 'Correo Electrónico',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        keyboardType: TextInputType.emailAddress,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _userController.contraseniaController,
                                        decoration: InputDecoration(
                                          labelText: 'Contraseña',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        obscureText: true,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Obx(() => DropdownButtonFormField<int>(
                                        decoration: InputDecoration(
                                          labelText: 'Rol',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        items: _userController.roles.map((role) {
                                          return DropdownMenuItem<int>(
                                            value: role.id ?? 0,
                                            child: Text(role.name ?? ''),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          _userController.roleController.text = value.toString();
                                        },
                                      )),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Obx(() => DropdownButtonFormField<int>(
                                        decoration: InputDecoration(
                                          labelText: 'Proyecto',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        items: _userController.proyectos.map((proyecto) {
                                          return DropdownMenuItem<int>(
                                            value: proyecto.id,
                                            child: Text(proyecto.nombre ?? ''),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            selectedProjectIds = [value.toString()]; // Asumiendo que solo seleccionas un proyecto
                                            _userController.proyectos_idsController.text = selectedProjectIds.join(', ');
                                          }
                                        },
                                      )),
                                    ),
                                  ],
                                ),
                              ]
                            : [
                                TextField(
                                  controller: _userController.nombreController,
                                  decoration: InputDecoration(
                                    labelText: 'Nombre completo',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _userController.correoController,
                                  decoration: InputDecoration(
                                    labelText: 'Correo Electrónico',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: _userController.contraseniaController,
                                  decoration: InputDecoration(
                                    labelText: 'Contraseña',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  obscureText: true,
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<int>(
                                  decoration: InputDecoration(
                                    labelText: 'Rol',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  items: _userController.roles.map((role) {
                                    return DropdownMenuItem<int>(
                                      value: role.id,
                                      child: Text(role.name ?? ''),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    _userController.roleController.text = value.toString();
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
                                  items: _userController.proyectos.map((proyecto) {
                                    return DropdownMenuItem<int>(
                                      value: proyecto.id,
                                      child: Text(proyecto.nombre ?? ''),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      selectedProjectIds = [value.toString()]; // Asumiendo que solo seleccionas un proyecto
                                      _userController.proyectos_idsController.text = selectedProjectIds.join(', ');
                                    }
                                  },
                                ),
                              ],
                      ),
                    ),
                    const SizedBox(height: 8), // Espaciado entre inputs y botón
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Cerrar el diálogo
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
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
                            ),
                            child: const Text('Cancelar'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              _userController.createUser(selectedProjectIds);
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
