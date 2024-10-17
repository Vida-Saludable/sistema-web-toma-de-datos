const rootRoute = "/";

const overviewPageDisplayName = "Dashboard";
const overviewPageRoute = "/overview";

const driversPageDisplayName = "Usuarios";
const driversPageRoute = "/drivers";

const patientPageDisplayName = "Pacientes";
const patientPageRoute = "/patient";

const clientsPageDisplayName = "Proyecto";
const clientsPageRoute = "/clients";

const reportsPageDisplayName = "Reportes";
const reportsPageRoute = "/reports";

const authenticationPageDisplayName = "Cerrar sesion";
const authenticationPageRoute = "/auth";

class MenuItem {
  final String name;
  final String route;

  MenuItem(this.name, this.route);
}

List<MenuItem> sideMenuItemRoutes = [
  MenuItem(overviewPageDisplayName, overviewPageRoute),
  MenuItem(driversPageDisplayName, driversPageRoute),
  MenuItem(patientPageDisplayName, patientPageRoute),
  MenuItem(clientsPageDisplayName, clientsPageRoute),
  MenuItem(reportsPageDisplayName, reportsPageRoute),
  MenuItem(authenticationPageDisplayName, authenticationPageRoute),
];
