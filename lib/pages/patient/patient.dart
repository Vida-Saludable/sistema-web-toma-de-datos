import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/constants/controllers.dart';
import 'package:flutter_web_dashboard/pages/patient/widgets/patient_table.dart';
import 'package:flutter_web_dashboard/pages/patient/widgets/top_page_patient.dart';
import 'package:flutter_web_dashboard/widgets/pagination_buttons.dart';
import 'package:get/get.dart';

class PatientPage extends StatelessWidget {
  const PatientPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: Column(
          children: [
            AppBar(
              title: Obx(
                () => Text(
                  menuController.activeItem.value,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            Expanded(
              child: Column(
                children: [
                  TopPagePatient(),
                  Expanded(
                    child: PatientTable(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: PaginationButtons(
                        currentPage: 1,
                        totalPages: 5,
                        onPageChanged: (int Page) {}
                      ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
