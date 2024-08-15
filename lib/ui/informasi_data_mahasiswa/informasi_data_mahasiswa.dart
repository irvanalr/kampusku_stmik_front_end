import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kampusku/utils/theme/light_and_dark.dart';

class InformasiDataMahasiswa extends StatelessWidget {
  const InformasiDataMahasiswa({super.key});

  @override
  Widget build(BuildContext context) {
    String nama = 'Irvan al rasyid';
    String notelp = '0812345678912';
    String tanggalLahir = '2000-06-08';
    String jenisKelamin = 'Laki-laki';
    String alamat = 'JL.ABC';
    String npm = '10822130';

    String namaSamaDengan = '= $nama';
    String notelpSamaDengan = '= $notelp';
    String tanggalSamadengan = '= $tanggalLahir';
    String jenisKelaminSamaDengan = '= $jenisKelamin';
    String alamatSamaDengan = '= $alamat';
    String npmSamaDengan = '= $npm';


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Informasi Data mahasiswa',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: LightAndDarkMode.primaryColor(context),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.account_circle_rounded,
                  size: 150,
                  color: LightAndDarkMode.informasiColor1(context),
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
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRow(context, 'Nama', namaSamaDengan),
                        _buildRow(context, 'No.telephone', notelpSamaDengan),
                        _buildRow(context, 'Tanggal lahir', tanggalSamadengan),
                        _buildRow(context, 'Jenis kelamin', jenisKelaminSamaDengan),
                        _buildRow(context, 'Alamat', alamatSamaDengan),
                        _buildRow(context, 'NPM', npmSamaDengan),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4, // 40% of screen width
            child: Text(
              '$label',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
