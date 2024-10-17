import 'package:flutter/material.dart';

class ResponsiveSearchFilterExport extends StatefulWidget {
  const ResponsiveSearchFilterExport({Key? key}) : super(key: key);

  @override
  _ResponsiveSearchFilterExportState createState() =>
      _ResponsiveSearchFilterExportState();
}

class _ResponsiveSearchFilterExportState
    extends State<ResponsiveSearchFilterExport> {
  String _tipoDeDato = 'agua';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 750;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              SizedBox(
                width: isDesktop
                    ? (constraints.maxWidth * 0.25)
                    : constraints.maxWidth,
                child: _buildSearchField(),
              ),
              SizedBox(
                width: isDesktop
                    ? (constraints.maxWidth * 0.25)
                    : constraints.maxWidth,
                child: _buildDropdown(),
              ),
              SizedBox(
                width: isDesktop
                    ? (constraints.maxWidth * 0.25)
                    : constraints.maxWidth,
                child: _buildExportButton(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: _boxDecoration(),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Buscar...",
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: _boxDecoration(),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _tipoDeDato,
          onChanged: (String? nuevoTipo) {
            setState(() {
              _tipoDeDato = nuevoTipo!;
            });
          },
          items: [
            'agua',
            'aire',
            'alimentacion',
            'ejercicio',
            'esperanza',
            'sol',
            'descanso'
          ].map<DropdownMenuItem<String>>((String valor) {
            return DropdownMenuItem<String>(
              value: valor,
              child: Text(valor[0].toUpperCase() + valor.substring(1)),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildExportButton() {
    return Container(
      width: double.infinity,
      decoration: _boxDecoration(),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.file_download, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Exportar',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
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
}
