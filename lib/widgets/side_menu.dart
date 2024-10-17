import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/constants/controllers.dart';
import 'package:flutter_web_dashboard/helpers/reponsiveness.dart';
import 'package:flutter_web_dashboard/routing/routes.dart';
import 'package:flutter_web_dashboard/widgets/custom_expansion_tile.dart';
import 'package:flutter_web_dashboard/widgets/custom_text.dart';
import 'package:flutter_web_dashboard/widgets/side_menu_item.dart';
import 'package:get/get.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String activeReport = "";
  bool _isHoveringGeneral = false;
  bool _isHoveringHabits = false;

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 765;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1200;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: isSmallScreen(context)
              ? EdgeInsets.only(top: 0)
              : EdgeInsets.only(top: 80),
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.only(
              topRight: isSmallScreen(context)
                  ? Radius.circular(0)
                  : Radius.circular(70),
            ),
          ),
          child: ListView(
            children: [
              _buildHeader(),
              Padding(
                padding: isSmallScreen(context)
                    ? EdgeInsets.symmetric(vertical: 90)
                    : EdgeInsets.symmetric(vertical: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: sideMenuItemRoutes.map((item) {
                    if (item.name != "Reportes") {
                      return SideMenuItem(
                        itemName: item.name,
                        onTap: () {
                          setState(() {
                            activeReport = '';
                          });
                          if (item.route == authenticationPageRoute) {
                            Get.offAllNamed(authenticationPageRoute);
                            menuController
                                .changeActiveItemTo(overviewPageDisplayName);
                          }
                          if (!menuController.isActive(item.name)) {
                            menuController.changeActiveItemTo(item.name);
                            if (ResponsiveWidget.isSmallScreen(context)) {
                              Get.back();
                            }
                            navigationController.navigateTo(item.route);
                          }
                        },
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: _buildReportsExpansionTile(),
                      );
                    }
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        _buildCircularLogo(),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        CustomText(
          text: "Vida saludable",
          size: isLargeScreen(context) ? 20 : 14,
          weight: FontWeight.bold,
          color: Colors.white,
        ),
        CustomText(
          text: "Salud natural en 8 pasos",
          size: isLargeScreen(context) ? 20 : 10,
          color: Colors.white,
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildReportsExpansionTile() {
    return CustomExpansionTile(
      title: const Text(
        'Reportes',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      leading: const Icon(Icons.assessment_outlined, color: Colors.white),
      trailing: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
      backgroundColor: const Color.fromARGB(255, 68, 90, 215),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
      children: [
        _buildReportTile(
          title: 'Reporte General',
          icon: Icons.apps_outlined,
          onTap: () {
            setState(() {
              activeReport = 'Reporte General';
            });
            menuController.changeActiveItemTo("Reportes");
            navigationController.navigateTo("/reports");
          },
          isHovering: _isHoveringGeneral,
          onHover: (value) {
            setState(() {
              _isHoveringGeneral = value;
            });
          },
        ),
        _buildReportTile(
          title: 'Reporte por hábitos',
          icon: Icons.check_circle_outline,
          onTap: () {
            setState(() {
              activeReport = 'Reporte por hábitos';
            });
            menuController.changeActiveItemTo("Reportes");
            navigationController.navigateTo("/reportshabit");
          },
          isHovering: _isHoveringHabits,
          onHover: (value) {
            setState(() {
              _isHoveringHabits = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildReportTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required bool isHovering,
    required Function(bool) onHover,
  }) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isHovering
                ? Colors.white.withOpacity(0.2)
                : activeReport == title
                    ? Colors.white.withOpacity(0.1)
                    : null,
            border: activeReport == title
                ? Border(left: BorderSide(color: Colors.white, width: 3))
                : null,
          ),
          child: isLargeScreen(context)
              ? Row(
                  children: [
                    Icon(icon, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(title, style: const TextStyle(color: Colors.white)),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildCircularLogo() {
    return Positioned(
      top: ResponsiveWidget.isSmallScreen(context) ? 80 : 50,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.indigo,
              width: 2,
            ),
            image: const DecorationImage(
              image: AssetImage("assets/icons/logo.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
