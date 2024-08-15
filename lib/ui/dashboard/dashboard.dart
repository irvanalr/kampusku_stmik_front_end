// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:kampusku/utils/routes/route_paths.dart';
// import 'package:kampusku/utils/theme/light_and_dark.dart';
//
// class Dashboard extends StatefulWidget {
//   const Dashboard({super.key});
//
//   @override
//   State<Dashboard> createState() => _DashboardState();
// }
//
// class _DashboardState extends State<Dashboard> {
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvoked: (bool didPop) async {
//         if (didPop) return;
//         await ExitApp.handlePop(context);
//       },
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: LightAndDarkMode.primaryColor(context),
//             leading: Image.asset(
//               'assets/stmik.png',
//               scale: 4,
//             ),
//             title: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Stmik kampusku',
//                   style: GoogleFonts.poppins(
//                     textStyle: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.normal,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () {},
//                   icon: Icon(Icons.visibility, color: Colors.white,),
//                   label: Text('Lihat data', style: TextStyle(color: Colors.white)),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton.icon(
//                   onPressed: () {},
//                   icon: Icon(Icons.input, color: Colors.white),
//                   label: Text('Input data', style: TextStyle(color: Colors.white)),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton.icon(
//                   onPressed: () {},
//                   icon: Icon(Icons.info, color: Colors.white),
//                   label: Text('Informasi', style: TextStyle(color: Colors.white)),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         )
//     );
//   }
// }
//
// class ExitApp {
//   static DateTime? currentBackPressTime;
//
//   static Future<void> handlePop(BuildContext context) async {
//     DateTime now = DateTime.now();
//     if (currentBackPressTime == null ||
//         now.difference(currentBackPressTime!) > const Duration(seconds:
//         2))
//     {
//       currentBackPressTime = now;
//       Fluttertoast.showToast(
//         msg: 'Tekan sekali lagi untuk logout !!!',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//       );
//     } else {
//       Navigator.pushReplacementNamed(context, RoutePaths.login);
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kampusku/ui/data_mahasiswa/data_mahasiswa.dart';
import 'package:kampusku/ui/informasi/informasi.dart';
import 'package:kampusku/ui/input_data/input_data.dart';
import 'package:kampusku/utils/routes/route_paths.dart';
import 'package:kampusku/utils/theme/light_and_dark.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  // Method untuk mengubah index yang dipilih
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        await ExitApp.handlePop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: LightAndDarkMode.primaryColor(context),
          leading: Image.asset(
            'assets/stmik.png',
            scale: 4,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stmik kampusku',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: PageView(
          controller: _pageController,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: const <Widget>[
            DataMahasiswa(),
            InputData(),
            Informasi(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Data mahasiswa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.input),
              label: 'Input data',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'Informasi',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          backgroundColor: LightAndDarkMode.primaryColor(context),
          onTap: _onItemTapped,
          showSelectedLabels: true,
          showUnselectedLabels: false, // Menyembunyikan label yang tidak dipilih
        ),
      ),
    );
  }
}

class ExitApp {
  static DateTime? currentBackPressTime;

  static Future<void> handlePop(BuildContext context) async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: 'Tekan sekali lagi untuk logout !!!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      Navigator.pushReplacementNamed(context, RoutePaths.login);
    }
  }
}

