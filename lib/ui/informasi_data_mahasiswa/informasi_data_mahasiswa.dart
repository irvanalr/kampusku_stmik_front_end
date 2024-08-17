import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kampusku/models/informasi_data_mahasiswa_model.dart';
import 'package:kampusku/utils/theme/light_and_dark.dart';
import 'package:kampusku/viewmodels/informasi_data_mahasiswa_view_model.dart';
import 'package:logger/logger.dart';

class InformasiDataMahasiswa extends StatefulWidget {
  final String nama;

  const InformasiDataMahasiswa({
    super.key,
    required this.nama,
  });

  @override
  State<InformasiDataMahasiswa> createState() => _InformasiDataMahasiswaState();

}

class _InformasiDataMahasiswaState extends State<InformasiDataMahasiswa> {
  final InformasiDataMahasiswaViewModel informasiDataMahasiswaViewModel = InformasiDataMahasiswaViewModel();
  final logger = Logger();

  Future<void> fetchData() async {
    try {
      final result = await informasiDataMahasiswaViewModel.informasiDataMahasiswa();
      Map<String, dynamic> responseBody = result['responseBody'];
      int statusCode = result['statusCode'];

      if (statusCode == 200) {
        // Parsing data dari responseBody
        final dataJson = responseBody['data'];
        final Data data = Data(
          nama: dataJson['nama'],
          nomer_handphone: dataJson['nomer_handphone'],
          tanggal_lahir: dataJson['tanggal_lahir'],
          jenis_kelamin: dataJson['jenis_kelamin'],
          alamat: dataJson['alamat'],
          npm: dataJson['npm'],
        );

        // Mengupdate model dengan data dari responseBody
        informasiDataMahasiswaViewModel.informasiDataMahasiswaModel.timeStamp = responseBody['timestamp'];
        informasiDataMahasiswaViewModel.informasiDataMahasiswaModel.status = responseBody['status'];
        informasiDataMahasiswaViewModel.informasiDataMahasiswaModel.message = responseBody['message'];
        informasiDataMahasiswaViewModel.informasiDataMahasiswaModel.data = [data];
      } else {
        informasiDataMahasiswaViewModel.informasiDataMahasiswaModel.timeStamp = responseBody['timestamp'];
        informasiDataMahasiswaViewModel.informasiDataMahasiswaModel.status = responseBody['status'];
        informasiDataMahasiswaViewModel.informasiDataMahasiswaModel.message = responseBody['message'];
        if(informasiDataMahasiswaViewModel.informasiDataMahasiswaModel.message == "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!") {
          if (context.mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    "INFROMASI",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    textAlign: TextAlign.center,
                  ),
                  content: Text(
                    informasiDataMahasiswaViewModel.informasiDataMahasiswaModel.message,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'OK',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: LightAndDarkMode.primaryColor(context)
                            )
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          throw Exception('Error selain 403 dengan message Username Atau Password salah silahkan coba lagi !!!');
        }
      }
    } catch (error) {
      logger.e(error);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            key: const Key('AlertGetApiKey'),
            title: const Center(
              child: Text(
                "Perhatian",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            content: const Text(
              'SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: LightAndDarkMode.primaryColor(context),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    informasiDataMahasiswaViewModel.informasiDataMahasiswaModel.namaKirim = widget.nama;
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult : (didPop, result) {
          if (!didPop) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
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
          body: FutureBuilder(
              future: Future.delayed(Duration(milliseconds: 1500), () => fetchData()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(),);
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Data kosong'),
                  );
                } else {
                  return SingleChildScrollView(
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
                              width: MediaQuery.of(context).size.width * 0.95,
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
                                    if (informasiDataMahasiswaViewModel.informasiDataMahasiswaModel.data.isNotEmpty)
                                      _buildRow(context, 'Nama', '= ${informasiDataMahasiswaViewModel.informasiDataMahasiswaModel.data[0].nama}'),
                                    if (informasiDataMahasiswaViewModel.informasiDataMahasiswaModel.data.isNotEmpty)
                                      _buildRow(context, 'No.handphone', '= ${informasiDataMahasiswaViewModel.informasiDataMahasiswaModel.data[0].nomer_handphone}'),
                                    if (informasiDataMahasiswaViewModel.informasiDataMahasiswaModel.data.isNotEmpty)
                                      _buildRow(context, 'Tanggal lahir', '= ${informasiDataMahasiswaViewModel.informasiDataMahasiswaModel.data[0].tanggal_lahir}'),
                                    if (informasiDataMahasiswaViewModel.informasiDataMahasiswaModel.data.isNotEmpty)
                                      _buildRow(context, 'Jenis kelamin', '= ${informasiDataMahasiswaViewModel.informasiDataMahasiswaModel.data[0].jenis_kelamin}'),
                                    if (informasiDataMahasiswaViewModel.informasiDataMahasiswaModel.data.isNotEmpty)
                                      _buildRow(context, 'Alamat', '= ${informasiDataMahasiswaViewModel.informasiDataMahasiswaModel.data[0].alamat}'),
                                    if (informasiDataMahasiswaViewModel.informasiDataMahasiswaModel.data.isNotEmpty)
                                      _buildRow(context, 'NPM', '= ${informasiDataMahasiswaViewModel.informasiDataMahasiswaModel.data[0].npm}'),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                  );
                }
              }
          ),
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
            width: MediaQuery.of(context).size.width * 0.4,
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
