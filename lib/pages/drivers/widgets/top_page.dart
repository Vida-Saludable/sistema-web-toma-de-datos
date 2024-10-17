import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/controllers/user_controllers.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  String selectedProjectFilter = 'all';
  late final UsersController _userController;

  @override
  void initState() {
    super.initState();
    _userController = Get.put(UsersController());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 750;
        return Padding(
          padding: EdgeInsets.all(isDesktop ? 20 : 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDesktop)
                _buildDesktopLayout(constraints)
              else
                _buildMobileLayout(constraints),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout(BoxConstraints constraints) {
    return Row(
      children: [
        Expanded(child: _buildSearchBar()),
        SizedBox(width: constraints.maxWidth * 0.02),
        SizedBox(
            width: constraints.maxWidth * 0.2,
            child: _buildProjectFilterDropdown()),
        SizedBox(width: constraints.maxWidth * 0.02),
        _buildRegisterButton(),
      ],
    );
  }

  Widget _buildMobileLayout(BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSearchBar(),
        const SizedBox(height: 10),
        _buildProjectFilterDropdown(),
        const SizedBox(height: 10),
        _buildRegisterButton(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
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
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
    );
  }

  Widget _buildProjectFilterDropdown() {
    return Container(
      decoration: _boxDecoration(),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Filtro por Proyecto',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        value: selectedProjectFilter,
        items: const [
          DropdownMenuItem(value: 'all', child: Text('Todos')),
          DropdownMenuItem(value: 'police', child: Text('Policía')),
          DropdownMenuItem(value: 'students', child: Text('Estudiantes')),
        ],
        onChanged: (value) {
          setState(() {
            selectedProjectFilter = value!;
          });
        },
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () => _showRegisterDialog(context),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Registrar", style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          elevation: 5,
          shadowColor: Colors.indigo.withOpacity(0.5),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  void _showRegisterDialog(BuildContext context) {
    List<String> selectedProjectIds = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Registrar Usuario',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildFormField(
                        _userController.nombreController, 'Nombre completo'),
                    const SizedBox(height: 16),
                    _buildFormField(
                        _userController.correoController, 'Correo Electrónico',
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 16),
                    _buildFormField(
                        _userController.contraseniaController, 'Contraseña',
                        obscureText: true),
                    const SizedBox(height: 16),
                    _buildRoleDropdown(),
                    const SizedBox(height: 16),
                    _buildProjectMultiSelect(selectedProjectIds),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
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
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          child: const Text('Guardar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormField(TextEditingController controller, String label,
      {TextInputType? keyboardType, bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
    );
  }

  Widget _buildRoleDropdown() {
    return Obx(() => DropdownButtonFormField<int>(
          decoration: InputDecoration(
            labelText: 'Rol',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
        ));
  }

  Widget _buildProjectMultiSelect(List<String> selectedProjectIds) {
    return Obx(() => MultiSelectDialogField<int>(
          items: _userController.proyectos.map((proyecto) {
            return MultiSelectItem<int>(
              proyecto.id ?? 0,
              proyecto.nombre ?? '',
            );
          }).toList(),
          title: const Text("Seleccionar Proyectos"),
          buttonText: const Text("Proyectos"),
          onConfirm: (values) {
            selectedProjectIds = values.map((id) => id.toString()).toList();
            _userController.proyectos_idsController.text =
                selectedProjectIds.join(', ');
          },
        ));
  }
}
