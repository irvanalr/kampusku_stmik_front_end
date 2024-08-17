import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kampusku/models/data_mahasiswa_model.dart';
import 'package:kampusku/utils/routes/route_paths.dart';
import 'package:kampusku/utils/theme/light_and_dark.dart';
import 'package:kampusku/viewmodels/data_mahasiswa_view_model.dart';
import 'package:logger/logger.dart';

class DataMahasiswa extends StatefulWidget {
  const DataMahasiswa({super.key});

  @override
  State<DataMahasiswa> createState() => _DataMahasiswaState();
}

class _DataMahasiswaState extends State<DataMahasiswa> {
  final DataMahasiswaViewModel dataMahasiswaViewModel = DataMahasiswaViewModel();
  final logger = Logger();

  Future<List<String>> listDataMahasiswa() async {
    try {
      final result = await dataMahasiswaViewModel.listDataMahasiswa();
      final Map<String, dynamic> responseBody = result['responseBody'];
      final int statusCode = result['statusCode'];

      if (statusCode == 200) {
        final List<Data> data = (responseBody['data'] as List).map((data) {
          return Data(
            name: data['nama'],
          );
        }).toList();

        dataMahasiswaViewModel.dataMahasiswaModel.timeStamp = responseBody['timestamp'];
        dataMahasiswaViewModel.dataMahasiswaModel.status = responseBody['status'];
        dataMahasiswaViewModel.dataMahasiswaModel.message = responseBody['message'];
        dataMahasiswaViewModel.dataMahasiswaModel.data = data;

        return data.map((data) => data.name).toList();
      } else {
        dataMahasiswaViewModel.dataMahasiswaModel.timeStamp = responseBody['timestamp'];
        dataMahasiswaViewModel.dataMahasiswaModel.status = responseBody['status'];
        dataMahasiswaViewModel.dataMahasiswaModel.message = responseBody['message'];
        if (dataMahasiswaViewModel.dataMahasiswaModel.message ==
            "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!") {
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
                    dataMahasiswaViewModel.dataMahasiswaModel.message,
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
        // Return an empty list if status code is not 200 or there's an error
        return [];
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
                          color: LightAndDarkMode.primaryColor(context)
                      )
                  ),
                ),
              ),
            ],
          );
        },
      );
      // Return an empty list in case of an exception
      return [];
    }
  }

  void _showDeleteConfirmation(String mahasiswa) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Perhatian",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: LightAndDarkMode.textColor1(context),
              ),
            ),
          ),
          content: RichText(
            text: TextSpan(
              text: "Apakah anda ingin menghapus data ",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: LightAndDarkMode.textColor1(context),
                ),
              ),
              children: <TextSpan>[
                TextSpan(
                  text: mahasiswa,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: " ?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Tidak",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: LightAndDarkMode.textColor1(context),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "Ya",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: LightAndDarkMode.textColor1(context),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // final List<String> _mahasiswaList = [
  //   'Irvan Al Rasyid',
  //   'Adi Nugroho',
  //   'Rina Andriani',
  //   'Budi Santoso',
  //   'Siti Nurhaliza',
  //   'Teguh Prasetyo',
  //   'Jane Sartika',
  //   'Rizky Hidayat',
  //   'Fitriani Rahayu',
  //   'Agung Muhammad'
  // ];

  // Future<List<String>> _fetchData() async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   return _mahasiswaList;
  // }
  //
  // Future<void> _refreshData() async {
  //   await Future.delayed(const Duration(seconds: 2));
  //
  //   setState(() {
  //     _mahasiswaList.add('Mahasiswa Baru');
  //   });
  // }

  void _navigateToUpdateMahasiswa(String nama) {
    Navigator.pushNamed(
      context,
      RoutePaths.updateMahasiswa,
      arguments: {'nama': nama},
    );
  }

  void _navigateToInformasiDataMahasiswa(String nama) {
    Navigator.pushNamed(
      context,
      RoutePaths.informasiDataMahasiswa,
      arguments: {'nama': nama},
    );
  }

  @override
  void initState() {
    super.initState();
    listDataMahasiswa();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: listDataMahasiswa,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Data Mahasiswa',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
                color: LightAndDarkMode.textColor1(context),
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<List<String>>(
          future: Future.delayed(Duration(milliseconds: 1500), () => listDataMahasiswa()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Data kosong')
              );
            } else if (snapshot.hasData) {

              final mahasiswaList = snapshot.data ?? [];

              if (mahasiswaList.isEmpty) {
                return const Center(child: Text('Data kosong'));
              }

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ListBody(
                      children: snapshot.data!.map((mahasiswa) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text(
                                      mahasiswa,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: LightAndDarkMode.textColor1(context),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.info, color: Colors.green),
                                        onPressed: () => _navigateToInformasiDataMahasiswa(mahasiswa),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Colors.blueAccent),
                                        onPressed: () => _navigateToUpdateMahasiswa(mahasiswa),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _showDeleteConfirmation(mahasiswa),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(color: LightAndDarkMode.primaryColor(context)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            } else {
              return const Center(child: Text('Tidak ada data mahasiswa.'));
            }
          },
        ),
      ),
    );
  }
}
