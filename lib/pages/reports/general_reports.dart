import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/pages/reports/widgets/top_report_page.dart';
import 'package:flutter_web_dashboard/pages/reports/widgets/report_general_table.dart';
import 'package:flutter_web_dashboard/widgets/pagination_buttons.dart';

class GeneralReportsPage extends StatelessWidget {
  const GeneralReportsPage({Key? key}) : super(key: key);

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
              title: const Text(
                "Reportes general",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo),
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Column(
                children: [
                  TopReportPage(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: ReportsTable(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: PaginationButtons(
                        currentPage: 1,
                        totalPages: 5,
                        onPageChanged: (int Page) {}),
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
