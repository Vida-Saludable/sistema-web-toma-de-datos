import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/helpers/reponsiveness.dart';
import 'package:flutter_web_dashboard/constants/controllers.dart';
import 'package:flutter_web_dashboard/pages/overview/widgets/available_drivers_table.dart';
import 'package:flutter_web_dashboard/pages/overview/widgets/overview_cards_large.dart';
import 'package:flutter_web_dashboard/pages/overview/widgets/overview_cards_medium.dart';
import 'package:flutter_web_dashboard/pages/overview/widgets/overview_cards_small.dart';
import 'package:flutter_web_dashboard/pages/overview/widgets/revenue_section_large.dart';
import 'package:flutter_web_dashboard/widgets/custom_text.dart';
import 'package:get/get.dart';

import 'widgets/revenue_section_small.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

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
                "Dashboard",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (ResponsiveWidget.isLargeScreen(context) ||
                        ResponsiveWidget.isMediumScreen(context))
                      if (ResponsiveWidget.isCustomSize(context))
                        const OverviewCardsMediumScreen()
                      else
                        const OverviewCardsLargeScreen()
                    else
                      const OverviewCardsSmallScreen(),
                    if (!ResponsiveWidget.isSmallScreen(context))
                      const RevenueSectionLarge()
                    else
                      const RevenueSectionSmall(),
                    const AvailableDriversTable(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
