// ignore_for_file: unnecessary_const, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/controllers/user_controllers.dart';
import 'package:get/get.dart';

// import '../../../models/proyecto_models.dart';
import '../../../models/user_models.dart';

class DriversTable extends StatelessWidget {
  const DriversTable({super.key});

  // void _showDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return const CustomAnalysisDialog();
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final UsersController userController = Get.find<UsersController>();

    return Obx(() {
      if (userController.users.isEmpty) {
        return const Center(child: Text('No hay usuarios disponibles'));
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
                    _buildWideScreenContent(userController.users, context)
                  else
                    _buildNarrowScreenContent(userController.users, context),
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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildHeaderCell('ID'),
          _buildHeaderCell('Nombre'),
          _buildHeaderCell('Correo'),
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
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildWideScreenContent(List<User> users, BuildContext context) {
    return Column(
      children: List.generate(users.length, (index) {
        final usuario = users[index];
        return _buildUserRow(usuario, index + 1, context);
      }),
    );
  }

  Widget _buildUserRow(User usuario, int index, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildContentCell(index.toString(), context),
          _buildContentCell(usuario.nombre ?? 'No disponible', context),
          _buildContentCell(usuario.correo ?? 'No disponible', context),
          _buildContentCell(usuario.role ?? 'No disponible', context),
          _buildActionButtons(context, usuario),
        ],
      ),
    );
  }

  Widget _buildContentCell(String content, BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8),
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

Widget _buildActionButtons(BuildContext context, User usuario) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          onPressed: () {
            _showEditDialog(context, usuario);
          },
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Cambia el valor si necesitas un borderRadius diferente
            ),
            backgroundColor: Colors.white, // Color de fondo del botón
            side: BorderSide(color: Colors.indigo), // Color del borde
            // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Padding interno del botón
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
          onPressed: () {
            _showViewProjectDialog(context, usuario);
          },
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Cambia el valor si necesitas un borderRadius diferente
            ),
            backgroundColor: Colors.white, // Color de fondo del botón
            side: BorderSide(color: Color.fromARGB(255, 39, 133, 176)), // Color del borde
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
          child: const Icon(Icons.work_history_outlined,
              color: Color.fromARGB(255, 39, 133, 176), size: 20),
        ),
      ],
    ),
  );
}

  Widget _buildNarrowScreenContent(List<dynamic> data, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: List.generate(data.length, (index) {
          final usuario = data[index]['usuario'];
          return _buildNarrowUserRow(usuario);
        }),
      ),
    );
  }

  Widget _buildNarrowUserRow(dynamic usuario) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildRow('N°', usuario['id'].toString()),
          _buildRow('Correo', usuario['correo'] ?? 'No disponible'),
          _buildRow('Nombre', usuario['nombre'] ?? 'No disponible'),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.indigo),
                  onPressed: () {
                    // Lógica de edición aquí
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
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
              child: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 5, child: Text(content)),
        ],
      ),
    );
  }

void _showEditDialog(BuildContext context, User usuario) {
  final UsersController userController = Get.find<UsersController>();

  // Asignar valores actuales del usuario
  userController.correoController.text = usuario.correo ?? '';
  userController.nombreController.text = usuario.nombre ?? '';
  userController.roleController.text = usuario.role ?? ''; 

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Encabezado del diálogo con border radius
                Container(
                  width: double.infinity, // Asegura que el encabezado ocupe todo el ancho
                  decoration: BoxDecoration(
                    color: Colors.indigo, // Color de fondo del encabezado
                    borderRadius: const BorderRadius.only(
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
                                'Editar Usuario',
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
                const SizedBox(height: 15), // Espaciado entre el encabezado y los inputs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: userController.nombreController,
                              decoration: InputDecoration(
                                labelText: 'Nombre Completo',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: userController.correoController,
                              decoration: InputDecoration(
                                labelText: 'Correo Electrónico',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
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
                            child: Obx(() => DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: 'Rol',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              items: userController.roles.map((role) {
                                return DropdownMenuItem<int>(
                                  value: role.id ?? 0,
                                  child: Text(role.name ?? ''),
                                );
                              }).toList(),
                              onChanged: (value) {
                                userController.roleController.text = value.toString();
                              },
                            )),
                          ),
                        ],
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
                          Navigator.of(context).pop();
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
                          // Aquí llamas al método para actualizar el usuario con los datos editados
                          userController.updateUsuario(usuario.id!);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
          ),
        ),
      );
    },
  );
}

void _showViewProjectDialog(BuildContext context, User usuario) {
  final UsersController userController = Get.find<UsersController>();

  // Listar proyectos globales para el select
  userController.listarProyectos();
  // Listar proyectos específicos del usuario
  userController.listarProyectosUsuarios(usuario.id ?? 0);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), // Bordes redondeados
            color: Colors.white, // Color de fondo del diálogo
          ),
          width: 700, // Ajusta el ancho del diálogo
          child: Column(
            mainAxisSize: MainAxisSize.min, // Se ajusta el tamaño del diálogo
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                width: double.infinity, // Asegura que el Container ocupe todo el ancho
                decoration: BoxDecoration(
                  color: Colors.indigo, // Fondo indigo
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)), // Bordes superiores redondeados
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espacio entre los elementos
                  children: [
                    Expanded(
                      child: Text(
                        'Proyectos de ${usuario.nombre}',
                        style: TextStyle(
                          color: Colors.white, // Color del texto blanco
                          fontSize: 20, // Tamaño de fuente más grande
                          fontWeight: FontWeight.bold, // Negrita
                        ),
                        textAlign: TextAlign.center, // Centra el texto
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white), // Ícono de cerrar
                      onPressed: () {
                        Navigator.of(context).pop(); // Cierra el diálogo
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16), // Espacio entre el encabezado y el contenido
              Obx(() {
                return SingleChildScrollView(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 600, // Ajusta el ancho del diálogo
                      maxHeight: 300, // Ajusta la altura del diálogo
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Obx(
                                () => DropdownButtonFormField<int>(
                                  decoration: InputDecoration(
                                    labelText: 'Seleccione un proyecto',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  items: userController.proyectos.map((proyecto) {
                                    return DropdownMenuItem<int>(
                                      value: proyecto.id ?? 0, // Envía el ID del proyecto
                                      child: Text(proyecto.nombre ?? ''),
                                    );
                                  }).toList(),
                                  onChanged: (int? newValue) {
                                    userController.proyecto_idController.text = newValue.toString();
                                    // Almacenar el ID del proyecto seleccionado
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 10), // Espacio entre el dropdown y el botón
                            Container(
                              height: 50, // Ajusta la altura del botón
                              child: OutlinedButton(
                                onPressed: () {
                                  userController.asignarProyecto(usuario.id ?? 0);
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.indigo, // Fondo azul
                                  side: const BorderSide(color: Colors.indigo), // Borde azul
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10), // Radio de bordes redondeados
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.save, color: Colors.white), // Ícono de guardar
                                    SizedBox(width: 8), // Espacio entre el ícono y el texto
                                    Text(
                                      'Guardar', // Texto dentro del botón
                                      style: TextStyle(color: Colors.white), // Texto de color blanco
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20), // Espacio entre el dropdown y la tabla
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey), // Borde gris alrededor de la tabla
                            borderRadius: BorderRadius.circular(4), // Bordes redondeados
                          ),
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('NOMBRE', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('DESCRIPCIÓN', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('ACCIONES', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                            rows: List<DataRow>.generate(
                              userController.proyectosUser.length,
                              (index) {
                                final proyecto = userController.proyectosUser[index];
                                return DataRow(cells: [
                                  DataCell(Text((index + 1).toString())), // Asigna el índice más 1 para ID
                                  DataCell(Text(proyecto.nombre ?? 'No disponible')),
                                  DataCell(Text(proyecto.descripcion ?? 'No disponible')),
                                  DataCell(
                                    OutlinedButton(
                                      onPressed: () {
                                        // Acción para eliminar el proyecto
                                        userController.deleteProyectoAsignado(proyecto.id ?? 0, usuario.id ?? 0);
                                        print("Eliminar proyecto con ID: ${proyecto.id}");
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Colors.red), // Borde rojo
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10), // Radio de bordes redondeados
                                        ),
                                      ).copyWith(
                                        foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(MaterialState.hovered)) {
                                              return Colors.red.shade700; // Rojo más intenso al pasar el cursor
                                            }
                                            return Colors.red; // Rojo normal
                                          },
                                        ),
                                      ),
                                      child: const Icon(Icons.delete, color: Colors.red),
                                    ),
                                  ),
                                ]);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16), // Espacio en la parte inferior
            ],
          ),
        ),
      );
    },
  );
}




// void _showDeleteConfirmationDialog(BuildContext context, usuario) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Confirmar eliminación'),
//         content: Text(
//           '¿Estás seguro de que deseas eliminar el usuario "${usuario.nombres_apellidos}"?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text(
//               'Cancelar',
//               style: TextStyle(color: Colors.indigo),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               final userController = Get.find<UsersController>();

//               // Convertimos el ID del proyecto a entero si es un String
//               int id = int.tryParse(usuario.id.toString()) ?? 0;

//               userController.deleteUsuario(id);
//               Navigator.of(context).pop();
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: Text('Eliminar'),
//           ),
//         ],
//       );
//     },
//   );
// }
}

class Proyecto {
  final int id;
  final String nombre;
  final String descripcion;
  final String estado;

  Proyecto(
      {required this.id,
      required this.nombre,
      required this.descripcion,
      required this.estado});
}
