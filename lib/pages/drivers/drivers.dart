import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/constants/controllers.dart';
import 'package:flutter_web_dashboard/pages/drivers/widgets/drivers_table.dart';
import 'package:flutter_web_dashboard/pages/drivers/widgets/top_page.dart';
import 'package:flutter_web_dashboard/widgets/pagination_buttons.dart';
import 'package:get/get.dart';

class DriversPage extends StatelessWidget {
  const DriversPage({Key? key}) : super(key: key);

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
                  TopPage(),
                  Expanded(
                    child: DriversTable(),
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
