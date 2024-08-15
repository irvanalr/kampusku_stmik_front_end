import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kampusku/utils/theme/light_and_dark.dart';

class Informasi extends StatelessWidget {
  const Informasi({super.key});

  @override
  Widget build(BuildContext context) {

    String bodyText = 'Aplikasi STMIK kampusku merupakan aplikasi yang digunakan untuk pendataan mahasiswa. Pengguna nantinya bisa menambahkan, update, dan hapus data mahasiswa.';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.info,
            size: 150,
            color: LightAndDarkMode.informasiColor1(context),
          ),
          Text(
              'INFORMASI',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: LightAndDarkMode.textColor1(context),
                ),
              )
          ),
          const SizedBox(height: 20,),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: LightAndDarkMode.informasiColor1(context),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    bodyText,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
