// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/proyecto_controllers.dart';
import '../../../models/proyecto_models.dart';

class ClientsTable extends StatelessWidget {
  const ClientsTable({Key? key}) : super(key: key);

  void _showEditDialog(BuildContext context, proyecto) {
    final ProyectoController proyectoController =
        Get.find<ProyectoController>();

    proyectoController.nombreController.text = proyecto.nombre ?? '';
    proyectoController.descripcionController.text = proyecto.descripcion ?? '';
    proyectoController.startDateController.text = proyecto.fecha_inicio != null
        ? DateFormat('yyyy-MM-dd').format(proyecto.fecha_inicio!)
        : '';
    proyectoController.endDateController.text = proyecto.fecha_fin != null
        ? DateFormat('yyyy-MM-dd').format(proyecto.fecha_fin!)
        : '';

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
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Editar Proyecto',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: proyectoController.nombreController,
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: proyectoController.startDateController,
                          decoration: InputDecoration(
                            labelText: 'Fecha de Inicio',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                          keyboardType: TextInputType.datetime,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            await proyectoController.selectDate(
                              context,
                              proyectoController.startDateController,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: proyectoController.endDateController,
                          decoration: InputDecoration(
                            labelText: 'Fecha Final',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                          keyboardType: TextInputType.datetime,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            await proyectoController.selectDate(
                              context,
                              proyectoController.endDateController,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: proyectoController.descripcionController,
                          decoration: InputDecoration(
                            labelText: 'Descripción',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          maxLines: 3,
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
                            proyectoController.updateProyecto(
                                int.parse(proyecto.id.toString()));
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
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, proyecto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text(
            '¿Estás seguro de que deseas eliminar el proyecto "${proyecto.nombre}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.indigo),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final proyectoController = Get.find<ProyectoController>();

                // Convertimos el ID del proyecto a entero si es un String
                int id = int.tryParse(proyecto.id.toString()) ?? 0;

                proyectoController.deleteProyecto(id);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProyectoController proyectoController =
        Get.find<ProyectoController>();

    return Obx(() {
      if (proyectoController.proyectos.isEmpty) {
        return const Center(child: Text('No hay proyectos disponibles'));
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 600;

          return Container(
            // padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 30),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: isWideScreen
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        _buildWideScreenContent(
                            proyectoController.proyectos, context),
                      ],
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 8),
                          _buildNarrowScreenContent(
                              proyectoController.proyectos, context),
                        ],
                      ),
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
            color: Colors.grey.withOpacity(0),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('N°',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text('Nombre',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text('Descripción',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text('Fecha Inicio',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text('Fecha Final',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Text('Estado',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text('Acción',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildWideScreenContent(
      List<Proyecto> proyectos, BuildContext context) {
    return Column(
      children: List.generate(
        proyectos.length,
        (index) {
          final proyecto = proyectos[index];
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
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text((index + 1).toString()),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(proyecto.nombre ?? ''),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(proyecto.descripcion ?? ''),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(proyecto.fecha_inicio != null
                        ? DateFormat('dd/MM/yyyy')
                            .format(proyecto.fecha_inicio!)
                        : ''),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(proyecto.fecha_fin != null
                        ? DateFormat('dd/MM/yyyy').format(proyecto.fecha_fin!)
                        : ''),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Text(proyecto.estado == 1 ? 'Activo' : 'Inactivo'),
                      Switch(
                        value: proyecto.estado == 1,
                        onChanged: (bool value) {
                          final proyectoController =
                              Get.find<ProyectoController>();
                          proyectoController.updateProyectoEstado(
                            proyecto.id?.toString(),
                            value ? 1 : 0,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton(
                        onPressed: () => _showEditDialog(context, proyecto),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: const BorderSide(color: Colors.indigo),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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
                        child: const Icon(
                          Icons.edit,
                          color: Colors.indigo,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNarrowScreenContent(
      List<Proyecto> proyectos, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          proyectos.length,
          (index) {
            final proyecto = proyectos[index];
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
                  _buildRow('N°', (index + 1).toString()),
                  _buildRow('Nombre', proyecto.nombre ?? ''),
                  _buildRow('Descripción', proyecto.descripcion ?? ''),
                  _buildRow(
                      'Fecha Inicio',
                      proyecto.fecha_inicio != null
                          ? DateFormat('dd/MM/yyyy')
                              .format(proyecto.fecha_inicio!)
                          : ''),
                  _buildRow(
                      'Fecha Final',
                      proyecto.fecha_fin != null
                          ? DateFormat('dd/MM/yyyy').format(proyecto.fecha_fin!)
                          : ''),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.indigo),
                          onPressed: () =>
                              _showEditDialog(context, proyecto.id),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showDeleteConfirmationDialog(
                              context, proyecto.id),
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
  }

  Widget _buildRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(flex: 5, child: Text(content)),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import '../../../controllers/proyecto_controllers.dart';
// import '../../../models/proyecto_models.dart';

// class ClientsTable extends StatelessWidget {
//   const ClientsTable({Key? key}) : super(key: key);

//   void _showEditDialog(BuildContext context, proyecto) {
//     final ProyectoController proyectoController =
//         Get.find<ProyectoController>();

//     proyectoController.nombreController.text = proyecto.nombre ?? '';
//     proyectoController.descripcionController.text = proyecto.descripcion ?? '';
//     proyectoController.startDateController.text = proyecto.fecha_inicio != null
//         ? DateFormat('yyyy-MM-dd').format(proyecto.fecha_inicio!)
//         : '';
//     proyectoController.endDateController.text = proyecto.fecha_fin != null
//         ? DateFormat('yyyy-MM-dd').format(proyecto.fecha_fin!)
//         : '';

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//               maxWidth: MediaQuery.of(context).size.width * 0.5,
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Text(
//                       'Editar Proyecto',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: Column(
//                       children: [
//                         TextField(
//                           controller: proyectoController.nombreController,
//                           decoration: InputDecoration(
//                             labelText: 'Nombre',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         TextField(
//                           controller: proyectoController.startDateController,
//                           decoration: InputDecoration(
//                             labelText: 'Fecha de Inicio',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             suffixIcon: Icon(Icons.calendar_today),
//                           ),
//                           keyboardType: TextInputType.datetime,
//                           onTap: () async {
//                             FocusScope.of(context).requestFocus(FocusNode());
//                             await proyectoController.selectDate(
//                               context,
//                               proyectoController.startDateController,
//                             );
//                           },
//                         ),
//                         SizedBox(height: 16),
//                         TextField(
//                           controller: proyectoController.endDateController,
//                           decoration: InputDecoration(
//                             labelText: 'Fecha Final',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             suffixIcon: Icon(Icons.calendar_today),
//                           ),
//                           keyboardType: TextInputType.datetime,
//                           onTap: () async {
//                             FocusScope.of(context).requestFocus(FocusNode());
//                             await proyectoController.selectDate(
//                               context,
//                               proyectoController.endDateController,
//                             );
//                           },
//                         ),
//                         SizedBox(height: 16),
//                         TextField(
//                           controller: proyectoController.descripcionController,
//                           decoration: InputDecoration(
//                             labelText: 'Descripción',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           maxLines: 3,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           style: TextButton.styleFrom(
//                             foregroundColor: Colors.white,
//                             backgroundColor: Colors.red,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             textStyle: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           child: Text('Cancelar'),
//                         ),
//                         SizedBox(width: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             proyectoController.updateProyecto(
//                                 int.parse(proyecto.id.toString()));
//                             Navigator.of(context).pop();
//                           },
//                           style: ElevatedButton.styleFrom(
//                             foregroundColor: Colors.white,
//                             backgroundColor: Colors.indigo,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 12,
//                             ),
//                             textStyle: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             elevation: 5,
//                             shadowColor: Colors.indigo.withOpacity(0.2),
//                           ),
//                           child: Text('Guardar'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _showDeleteConfirmationDialog(BuildContext context, proyecto) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Confirmar eliminación'),
//           content: Text(
//             '¿Estás seguro de que deseas eliminar el proyecto "${proyecto.nombre}"?',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text(
//                 'Cancelar',
//                 style: TextStyle(color: Colors.indigo),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 final proyectoController = Get.find<ProyectoController>();

//                 // Convertimos el ID del proyecto a entero si es un String
//                 int id = int.tryParse(proyecto.id.toString()) ?? 0;

//                 proyectoController.deleteProyecto(id);
//                 Navigator.of(context).pop();
//               },
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//               child: Text('Eliminar'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ProyectoController proyectoController =
//         Get.find<ProyectoController>();

//     return Obx(() {
//       if (proyectoController.proyectos.isEmpty) {
//         return Center(child: Text('No hay proyectos disponibles'));
//       }

//       return LayoutBuilder(
//         builder: (context, constraints) {
//           final isWideScreen = constraints.maxWidth > 600;

//           return Container(
//             // padding: const EdgeInsets.all(16),
//             margin: const EdgeInsets.only(bottom: 30),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: isWideScreen
//                   ? Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         _buildHeader(),
//                         _buildWideScreenContent(
//                             proyectoController.proyectos, context),
//                       ],
//                     )
//                   : SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildHeader(),
//                           const SizedBox(height: 8),
//                           _buildNarrowScreenContent(
//                               proyectoController.proyectos, context),
//                         ],
//                       ),
//                     ),
//             ),
//           );
//         },
//       );
//     });
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 3),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0),
//             spreadRadius: 2,
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(8),
//             child: Text('N°',
//                 style: TextStyle(
//                     color: Colors.black, fontWeight: FontWeight.bold)),
//           ),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.all(8),
//               child: Text('Nombre',
//                   style: TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.bold)),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.all(8),
//               child: Text('Descripción',
//                   style: TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.bold)),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.all(8),
//               child: Text('Fecha Inicio',
//                   style: TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.bold)),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.all(8),
//               child: Text('Fecha Final',
//                   style: TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.bold)),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 0),
//             child: Text('Estado',
//                 style: TextStyle(
//                     color: Colors.black, fontWeight: FontWeight.bold)),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 30),
//             child: Text('Acción',
//                 style: TextStyle(
//                     color: Colors.black, fontWeight: FontWeight.bold)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWideScreenContent(
//       List<Proyecto> proyectos, BuildContext context) {
//     return Column(
//       children: List.generate(
//         proyectos.length,
//         (index) {
//           final proyecto = proyectos[index];
//           return Container(
//             margin: EdgeInsets.symmetric(vertical: 0.5),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.2),
//                   spreadRadius: 2,
//                   blurRadius: 4,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(8),
//                   child: Text((index + 1).toString()),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.all(8),
//                     child: Text(proyecto.nombre ?? ''),
//                   ),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.all(8),
//                     child: Text(proyecto.descripcion ?? ''),
//                   ),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.all(8),
//                     child: Text(proyecto.fecha_inicio != null
//                         ? DateFormat('dd/MM/yyyy')
//                             .format(proyecto.fecha_inicio!)
//                         : ''),
//                   ),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.all(8),
//                     child: Text(proyecto.fecha_fin != null
//                         ? DateFormat('dd/MM/yyyy').format(proyecto.fecha_fin!)
//                         : ''),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(8),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // Text(proyecto.estado == 1 ? 'Activo' : 'Inactivo'),
//                       Switch(
//                         value: proyecto.estado == 1,
//                         onChanged: (bool value) {
//                           final proyectoController =
//                               Get.find<ProyectoController>();
//                           proyectoController.updateProyectoEstado(
//                             proyecto.id?.toString(),
//                             value ? 1 : 0,
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(8),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       OutlinedButton(
//                         onPressed: () => _showEditDialog(context, proyecto),
//                         style: OutlinedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           side: BorderSide(color: Colors.indigo),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                         ).copyWith(
//                           overlayColor:
//                               MaterialStateProperty.resolveWith<Color?>(
//                             (Set<MaterialState> states) {
//                               if (states.contains(MaterialState.hovered)) {
//                                 return Colors.indigo.withOpacity(0.1);
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                         child: Icon(
//                           Icons.edit,
//                           color: Colors.indigo,
//                           size: 20,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       // OutlinedButton(
//                       //   onPressed: () =>
//                       //       _showDeleteConfirmationDialog(context, proyecto),
//                       //   style: OutlinedButton.styleFrom(
//                       //     backgroundColor: Colors.transparent,
//                       //     side: BorderSide(color: Colors.red),
//                       //     shape: RoundedRectangleBorder(
//                       //       borderRadius: BorderRadius.circular(4),
//                       //     ),
//                       //   ).copyWith(
//                       //     overlayColor:
//                       //         MaterialStateProperty.resolveWith<Color?>(
//                       //       (Set<MaterialState> states) {
//                       //         if (states.contains(MaterialState.hovered)) {
//                       //           return Colors.red.withOpacity(0.1);
//                       //         }
//                       //         return null;
//                       //       },
//                       //     ),
//                       //   ),
//                       //   child: Icon(
//                       //     Icons.delete,
//                       //     color: Colors.red,
//                       //     size: 20,
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildNarrowScreenContent(
//       List<Proyecto> proyectos, BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: List.generate(
//           proyectos.length,
//           (index) {
//             final proyecto = proyectos[index];
//             return Container(
//               margin: EdgeInsets.symmetric(vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     spreadRadius: 2,
//                     blurRadius: 4,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   _buildRow('N°', (index + 1).toString()),
//                   _buildRow('Nombre', proyecto.nombre ?? ''),
//                   _buildRow('Descripción', proyecto.descripcion ?? ''),
//                   _buildRow(
//                       'Fecha Inicio',
//                       proyecto.fecha_inicio != null
//                           ? DateFormat('dd/MM/yyyy')
//                               .format(proyecto.fecha_inicio!)
//                           : ''),
//                   _buildRow(
//                       'Fecha Final',
//                       proyecto.fecha_fin != null
//                           ? DateFormat('dd/MM/yyyy').format(proyecto.fecha_fin!)
//                           : ''),
//                   Padding(
//                     padding: EdgeInsets.all(8),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.edit, color: Colors.indigo),
//                           onPressed: () =>
//                               _showEditDialog(context, proyecto.id),
//                         ),
//                         const SizedBox(width: 8),
//                         IconButton(
//                           icon: Icon(Icons.delete, color: Colors.red),
//                           onPressed: () => _showDeleteConfirmationDialog(
//                               context, proyecto.id),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildRow(String title, String content) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//           ),
//           Expanded(flex: 5, child: Text(content)),
//         ],
//       ),
//     );
//   }
// }
