import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/controllers/proyecto_controllers.dart';
import 'package:get/get.dart';

class TopPageClients extends StatefulWidget {
  const TopPageClients({Key? key}) : super(key: key);

  @override
  _TopPageClientsState createState() => _TopPageClientsState();
}

class _TopPageClientsState extends State<TopPageClients> {
  final ProyectoController _proyectoController = Get.put(ProyectoController());

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
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
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
              SizedBox(width: 50),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showRegisterDialog(context);
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text(
                    "Registrar",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    elevation: 5,
                    shadowColor: Colors.indigo.withOpacity(0.5),
                    textStyle: TextStyle(
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
                bool isWideScreen = constraints.maxWidth >
                    600; // Breakpoint para pantalla ancha

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Registrar Proyecto',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        isWideScreen
                            ? Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller:
                                          _proyectoController.nombreController,
                                      decoration: InputDecoration(
                                        labelText: 'Nombre',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: DropdownButtonFormField<Estado>(
                                      value: _proyectoController.estados.first,
                                      onChanged: (Estado? newValue) {
                                        _proyectoController
                                                .estadoController.text =
                                            newValue?.id.toString() ?? '';
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Estado',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      items: _proyectoController.estados
                                          .map<DropdownMenuItem<Estado>>(
                                              (Estado estado) {
                                        return DropdownMenuItem<Estado>(
                                          value: estado,
                                          child: Text(estado.nombre),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  TextField(
                                    controller:
                                        _proyectoController.nombreController,
                                    decoration: InputDecoration(
                                      labelText: 'Nombre',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  DropdownButtonFormField<Estado>(
                                    value: _proyectoController.estados.first,
                                    onChanged: (Estado? newValue) {
                                      _proyectoController.estadoController
                                          .text = newValue?.id.toString() ?? '';
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Estado',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    items: _proyectoController.estados
                                        .map<DropdownMenuItem<Estado>>(
                                            (Estado estado) {
                                      return DropdownMenuItem<Estado>(
                                        value: estado,
                                        child: Text(estado.nombre),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                        SizedBox(height: 16),
                        isWideScreen
                            ? Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _proyectoController
                                          .startDateController,
                                      decoration: InputDecoration(
                                        labelText: 'Fecha de Inicio',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        suffixIcon: Icon(Icons.calendar_today),
                                      ),
                                      onTap: () async {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        await _proyectoController.selectDate(
                                          context,
                                          _proyectoController
                                              .startDateController,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: TextField(
                                      controller:
                                          _proyectoController.endDateController,
                                      decoration: InputDecoration(
                                        labelText: 'Fecha Final',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        suffixIcon: Icon(Icons.calendar_today),
                                      ),
                                      onTap: () async {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        await _proyectoController.selectDate(
                                          context,
                                          _proyectoController.endDateController,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  TextField(
                                    controller:
                                        _proyectoController.startDateController,
                                    decoration: InputDecoration(
                                      labelText: 'Fecha de Inicio',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      suffixIcon: Icon(Icons.calendar_today),
                                    ),
                                    onTap: () async {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      await _proyectoController.selectDate(
                                        context,
                                        _proyectoController.startDateController,
                                      );
                                    },
                                  ),
                                  SizedBox(height: 16),
                                  TextField(
                                    controller:
                                        _proyectoController.endDateController,
                                    decoration: InputDecoration(
                                      labelText: 'Fecha Final',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      suffixIcon: Icon(Icons.calendar_today),
                                    ),
                                    onTap: () async {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      await _proyectoController.selectDate(
                                        context,
                                        _proyectoController.endDateController,
                                      );
                                    },
                                  ),
                                ],
                              ),
                        SizedBox(height: 16),
                        TextField(
                          controller: _proyectoController.descripcionController,
                          decoration: InputDecoration(
                            labelText: 'Descripción',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          maxLines: 3,
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              child: Text(
                                'Cancelar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Texto en blanco
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                _proyectoController.createProyecto();
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                elevation: 5,
                                shadowColor: Colors.indigo.withOpacity(0.2),
                              ),
                              child: Text(
                                'Guardar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Texto en blanco
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
