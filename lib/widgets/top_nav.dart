import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/constants/style.dart';
import 'package:flutter_web_dashboard/helpers/reponsiveness.dart';

import 'custom_text.dart';

PreferredSizeWidget topNavigationBar(
    BuildContext context, GlobalKey<ScaffoldState> key) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: Container(
      child: AppBar(
        backgroundColor: Colors.transparent, // Color blanco para el AppBar
        leading: IconButton(
            icon: const Icon(Icons.menu,
                color: Colors.black), // Icono de menú en color negro
            onPressed: () {
              if (ResponsiveWidget.isSmallScreen(context)) {
                key.currentState?.openDrawer();
              }
            }),
        title: Row(
          children: [
            Expanded(child: Container()),
            IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.black, // Icono de ajustes en color negro
                ),
                onPressed: () {}),
            Stack(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.black.withOpacity(
                          .7), // Icono de notificaciones en negro con opacidad
                    ),
                    onPressed: () {}),
                Positioned(
                  top: 7,
                  right: 7,
                  child: Container(
                    width: 12,
                    height: 12,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: light, width: 2)),
                  ),
                )
              ],
            ),
            Container(
              width: 1,
              height: 22,
              color: lightGrey,
            ),
            const SizedBox(
              width: 24,
            ),
            const CustomText(
              text: "Santos Enoque",
              color: Colors.black87,
            ),
            const SizedBox(
              width: 16,
            ),
            Container(
              decoration: BoxDecoration(
                  color: active.withOpacity(.5),
                  borderRadius: BorderRadius.circular(30)),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.all(2),
                child: const CircleAvatar(
                  backgroundColor: lightGrey,
                  child: Icon(
                    Icons.person_outline,
                    color: dark,
                  ),
                ),
              ),
            )
          ],
        ),
        iconTheme:
            const IconThemeData(color: Colors.black), // Iconos en color negro
        elevation: 0,
      ),
    ),
  );
}
