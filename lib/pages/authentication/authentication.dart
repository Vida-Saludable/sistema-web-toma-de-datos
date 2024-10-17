import 'package:flutter/material.dart';
import 'package:flutter_web_dashboard/helpers/reponsiveness.dart';

class AuthenticationPage extends StatelessWidget {
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
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth <
              600; // Ajusta el valor según tus necesidades
          if (ResponsiveWidget.isLargeScreen(context))
            // ignore: curly_braces_in_flow_control_structures
            return Stack(
              children: [
                // Fondo y triángulo izquierdo
                if (!isSmallScreen)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: ClipPath(
                      clipper: LeftCustomClipper(),
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://png.pngtree.com/thumb_back/fw800/background/20230911/pngtree-lemon-tea-natural-remedies-for-colds-fever-coughing-etc-image_13158861.png',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height,
                            color: Colors.blue.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Triángulo derecho con formulario
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: ClipPath(
                    clipper: RightCustomClipper(),
                    child: Container(
                      width: !isLargeScreen(context)
                          ? MediaQuery.of(context).size.width
                          : MediaQuery.of(context).size.width * 0.55,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 60.0),
                      child: Padding(
                        padding: !isLargeScreen(context)
                            ? const EdgeInsets.all(20.0)
                            : const EdgeInsets.fromLTRB(200, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Spacer(),
                            // Logo y nombre
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/icons/logo.png",
                                  width: 100,
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  children: [
                                    Text(
                                      "Vida",
                                      style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontSize: 40,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const Text(
                                      "Saludable",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 40,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 40),
                            // Campos de entrada
                            Container(
                              width: isSmallScreen ? double.infinity : 400,
                              child: Column(
                                children: [
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Correo electrónico',
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                      suffixIcon: const Icon(Icons.email,
                                          color: Colors.grey),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        borderSide: const BorderSide(
                                            color: Colors.indigo, width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: 'Contraseña',
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                      suffixIcon: const Icon(Icons.lock,
                                          color: Colors.grey),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        borderSide: const BorderSide(
                                            color: Colors.indigo, width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      backgroundColor: Colors.indigo,
                                      minimumSize:
                                          const Size(double.infinity, 50),
                                    ),
                                    child: const Text('Iniciar sesión'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '¿Olvidaste tu contraseña?',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CustomPaint(
                    painter: TrianglePainter(),
                  ),
                ),

                // Nuevo triángulo rojo con bordes
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CustomPaint(
                    painter: TrianglePainter2(),
                  ),
                ),
              ],
            );
          else {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.grey[300],
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 60.0),
              child: Padding(
                padding: isSmallScreen
                    ? const EdgeInsets.all(10.0)
                    : const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/logo.png",
                      width: 120,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Vida Saludable",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Campos de entrada
                    Container(
                      width: 400,
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Correo electrónico',
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              suffixIcon:
                                  const Icon(Icons.email, color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                    color: Colors.indigo, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Contraseña',
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              suffixIcon:
                                  const Icon(Icons.lock, color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                    color: Colors.indigo, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              backgroundColor: Colors.indigo,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text('Iniciar sesión'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

// Clipper personalizado para el triángulo rojo
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 70
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.11, 20)
      ..lineTo(size.width / 2.38, size.width * -0.21)
      ..lineTo(size.width / 2.1, size.width * -0.158);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class TrianglePainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.indigo
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 70
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.77, size.width * -0.57)
      ..lineTo(size.width / 2.35, size.width * -0.267)
      ..lineTo(size.width / 3, size.width * -0.33);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

// Clipper personalizado para el lado izquierdo
class LeftCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double triangleWidth = size.width * 0.8;

    path.moveTo(0, 0);
    path.lineTo(size.width - triangleWidth, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - triangleWidth, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

// Clipper personalizado para el lado derecho
class RightCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double triangleWidth = size.width * 0.45;

    path.moveTo(size.width, 0);
    path.lineTo(triangleWidth, 0);
    path.lineTo(0, size.height / 2);
    path.lineTo(triangleWidth, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

// import 'package:flutter/material.dart';

// class AuthenticationPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Fondo y triángulo izquierdo

//           Positioned(
//             left: 0,
//             top: 0,
//             bottom: 0,
//             child: ClipPath(
//               clipper: LeftCustomClipper(), // Clipper para el lado izquierdo
//               child: Stack(
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width *
//                         0.4, // Ajusta el ancho del área
//                     height: MediaQuery.of(context).size.height,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: NetworkImage(
//                           'https://png.pngtree.com/thumb_back/fw800/background/20230911/pngtree-lemon-tea-natural-remedies-for-colds-fever-coughing-etc-image_13158861.png', // Sustituir por tu imagen
//                         ),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width * 0.4,
//                     height: MediaQuery.of(context).size.height,
//                     color: Colors.blue.withOpacity(0.5),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Triángulo derecho con formulario
//           Positioned(
//             right: 0,
//             top: 0,
//             bottom: 0,
//             child: ClipPath(
//               clipper: RightCustomClipper(), // Clipper para el lado derecho
//               child: Container(
//                   width: MediaQuery.of(context).size.width *
//                       0.55, // Ancho del área con el formulario
//                   height: MediaQuery.of(context).size.height,
//                   color: Colors.grey[300],
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 40.0, vertical: 60.0),
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(200, 0, 0, 0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         // Espacio superior
//                         Spacer(),
//                         // Logo y nombre
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               "assets/icons/logo.png",
//                               width: 100,
//                             ),
//                             SizedBox(height: 20),
//                             Column(
//                               children: [
//                                 Text(
//                                   "Vida",
//                                   style: TextStyle(
//                                     color: Colors.yellow[700],
//                                     fontSize: 40,
//                                     fontWeight: FontWeight.w900,
//                                   ),
//                                 ),
//                                 Text(
//                                   "Saludable",
//                                   style: TextStyle(
//                                     color: Colors.red,
//                                     fontSize: 40,
//                                     fontWeight: FontWeight.w900,
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                         SizedBox(height: 40),
//                         // Campos de entrada
//                         Container(
//                           width: 400,
//                           child: Column(
//                             children: [
//                               TextField(
//                                 decoration: InputDecoration(
//                                   hintText: 'Correo electrónico',
//                                   border: InputBorder.none,
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   contentPadding:
//                                       EdgeInsets.symmetric(horizontal: 20.0),
//                                   suffixIcon:
//                                       Icon(Icons.email, color: Colors.grey),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(30.0),
//                                     borderSide: BorderSide(
//                                         color: Colors.indigo, width: 2.0),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(30.0),
//                                     borderSide: BorderSide.none,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 20),
//                               TextField(
//                                 obscureText: true,
//                                 decoration: InputDecoration(
//                                   hintText: 'Contraseña',
//                                   border: InputBorder.none,
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   contentPadding:
//                                       EdgeInsets.symmetric(horizontal: 20.0),
//                                   suffixIcon:
//                                       Icon(Icons.lock, color: Colors.grey),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(30.0),
//                                     borderSide: BorderSide(
//                                         color: Colors.indigo, width: 2.0),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(30.0),
//                                     borderSide: BorderSide.none,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 20),
//                               ElevatedButton(
//                                 onPressed: () {},
//                                 style: ElevatedButton.styleFrom(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(30.0),
//                                   ),
//                                   backgroundColor: Colors.indigo,
//                                   minimumSize: Size(double.infinity,
//                                       50), // Ocupa todo el ancho
//                                 ),
//                                 child: Text('Iniciar sesión'),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           '¿Olvidaste tu contraseña?',
//                           style: TextStyle(color: Colors.grey[600]),
//                         ),
//                         Spacer(),
//                       ],
//                     ),
//                   )),
//             ),
//           ),

//           // Nuevo triángulo rojo con bordes
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: CustomPaint(
//               painter: TrianglePainter(),
//             ),
//           ),

//           // Nuevo triángulo rojo con bordes
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: CustomPaint(
//               painter: TrianglePainter2(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Clipper personalizado para el triángulo rojo
// class TrianglePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = size.width / 70
//       ..strokeCap = StrokeCap.round;

//     final path = Path()
//       ..moveTo(size.width * 0.11, 20)
//       ..lineTo(size.width / 2.38, size.width * -0.21)
//       ..lineTo(size.width / 2.1, size.width * -0.158);

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }

// class TrianglePainter2 extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.indigo
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = size.width / 70
//       ..strokeCap = StrokeCap.round;

//     final path = Path()
//       ..moveTo(size.width * 0.77, size.width * -0.57)
//       ..lineTo(size.width / 2.35, size.width * -0.267)
//       ..lineTo(size.width / 3, size.width * -0.33);

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }

// // Clipper personalizado para el lado izquierdo
// class LeftCustomClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     double triangleWidth =
//         size.width * 0.8; // Ancho de la extensión del triángulo hacia el centro

//     path.moveTo(0, 0); // Empieza en la esquina superior izquierda
//     path.lineTo(size.width - triangleWidth, 0); // Línea recta hacia la derecha
//     path.lineTo(size.width, size.height / 2); // Línea diagonal hacia el centro
//     path.lineTo(size.width - triangleWidth,
//         size.height); // Línea diagonal hacia el centro
//     path.lineTo(0, size.height); // Línea hacia la esquina inferior izquierda
//     path.close(); // Cierra el triángulo

//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }

// // Clipper personalizado para el lado derecho
// class RightCustomClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     double triangleWidth = size.width *
//         0.45; // Ancho de la extensión del triángulo hacia el centro

//     path.moveTo(size.width, 0); // Empieza en la esquina superior derecha
//     path.lineTo(triangleWidth, 0); // Línea recta hacia la izquierda
//     path.lineTo(0, size.height / 2); // Línea diagonal hacia el centro
//     path.lineTo(triangleWidth, size.height); // Línea diagonal hacia el centro
//     path.lineTo(
//         size.width, size.height); // Línea hacia la esquina inferior derecha
//     path.close(); // Cierra el triángulo

//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }
