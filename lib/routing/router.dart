import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/pages/clients/clients.dart';
import 'package:flutter_web_dashboard/pages/drivers/drivers.dart';
import 'package:flutter_web_dashboard/pages/overview/overview.dart';
import 'package:flutter_web_dashboard/pages/patient/patient.dart';
import 'package:flutter_web_dashboard/pages/reports/general_reports.dart';
import 'package:flutter_web_dashboard/pages/reports/habit_reports.dart';
import 'package:flutter_web_dashboard/routing/routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case overviewPageRoute:
      return _getPageRoute(OverviewPage());
    case driversPageRoute:
      return _getPageRoute(const DriversPage());
    case patientPageRoute:
      return _getPageRoute(const PatientPage());
    case clientsPageRoute:
      return _getPageRoute(const ClientsPage());
    case "/reports":
      return _getPageRoute(const GeneralReportsPage());
    case "/reportshabit":
      return _getPageRoute(const HabitReportsPage());
    default:
      return _getPageRoute(OverviewPage());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
