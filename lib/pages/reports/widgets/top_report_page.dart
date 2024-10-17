import 'package:flutter/material.dart';

class TopReportPage extends StatefulWidget {
  const TopReportPage({Key? key}) : super(key: key);

  @override
  _TopReportPageState createState() => _TopReportPageState();
}

class _TopReportPageState extends State<TopReportPage> {
  DateTime? startDate;
  DateTime? endDate;
  String selectedDateFilter = 'today';
  String selectedProjectFilter = 'all';

  Future<void> _selectDate(DateTimeType dateType) async {
    DateTime initialDate = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        if (dateType == DateTimeType.start) {
          startDate = pickedDate;
          if (endDate != null && pickedDate.isAfter(endDate!)) {
            endDate = null;
          }
        } else if (dateType == DateTimeType.end) {
          endDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 750;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDesktop)
                _buildDesktopLayout(constraints)
              else
                _buildMobileLayout(constraints),
              const SizedBox(height: 20),
              if (selectedDateFilter == 'custom')
                _buildCustomDateFields(isDesktop),
              if (selectedDateFilter == 'custom' &&
                  startDate != null &&
                  endDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Rango de Fechas: ${startDate!.toLocal().toString().split(' ')[0]} - ${endDate!.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDesktopLayout(BoxConstraints constraints) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        SizedBox(
          width: (constraints.maxWidth - 60) / 4,
          child: _buildSearchField(),
        ),
        SizedBox(
          width: (constraints.maxWidth - 60) / 4,
          child: _buildDateFilterDropdown(),
        ),
        SizedBox(
          width: (constraints.maxWidth - 60) / 4,
          child: _buildProjectFilterDropdown(),
        ),
        SizedBox(
          width: (constraints.maxWidth - 60) / 4,
          child: _buildExportButton(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSearchField(),
        const SizedBox(height: 16),
        _buildDateFilterDropdown(),
        const SizedBox(height: 16),
        _buildProjectFilterDropdown(),
        const SizedBox(height: 16),
        _buildExportButton(),
      ],
    );
  }

  Widget _buildCustomDateFields(bool isDesktop) {
    if (isDesktop) {
      return Row(
        children: [
          Expanded(child: _buildStartDateField()),
          const SizedBox(width: 20),
          Expanded(child: _buildEndDateField()),
        ],
      );
    } else {
      return Column(
        children: [
          _buildStartDateField(),
          const SizedBox(height: 16),
          _buildEndDateField(),
        ],
      );
    }
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

  Widget _buildDateFilterDropdown() {
    return Container(
      decoration: _boxDecoration(),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Filtro por Fecha',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        value: selectedDateFilter,
        items: const [
          DropdownMenuItem(value: 'today', child: Text('Hoy')),
          DropdownMenuItem(value: 'custom', child: Text('Personalizado')),
        ],
        onChanged: (value) {
          setState(() {
            selectedDateFilter = value!;
            if (value == 'custom' && (startDate == null || endDate == null)) {
              _selectDate(DateTimeType.start);
            } else {
              startDate = null;
              endDate = null;
            }
          });
        },
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

  Widget _buildExportButton() {
    return Container(
      decoration: _boxDecoration(),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _exportReport(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.file_download, color: Colors.white),
            SizedBox(width: 8),
            Text('Exportar Reporte', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildStartDateField() {
    return Container(
      decoration: _boxDecoration(),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Fecha de Inicio',
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.indigo),
            onPressed: () => _selectDate(DateTimeType.start),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        controller: TextEditingController(
          text:
              startDate != null ? '${startDate!.toLocal()}'.split(' ')[0] : '',
        ),
      ),
    );
  }

  Widget _buildEndDateField() {
    return Container(
      decoration: _boxDecoration(),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Fecha de Fin',
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.indigo),
            onPressed: () => _selectDate(DateTimeType.end),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        controller: TextEditingController(
          text: endDate != null ? '${endDate!.toLocal()}'.split(' ')[0] : '',
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

  void _exportReport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reporte exportado exitosamente.')),
    );
  }
}

enum DateTimeType { start, end }
