import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kampusku/ui/informasi_data_mahasiswa/informasi_data_mahasiswa.dart';
import 'package:kampusku/ui/update_mahasiswa/update_mahasiswa.dart';
import 'package:kampusku/utils/theme/light_and_dark.dart';

class DataMahasiswa extends StatefulWidget {
  const DataMahasiswa({super.key});

  @override
  State<DataMahasiswa> createState() => _DataMahasiswaState();
}

class _DataMahasiswaState extends State<DataMahasiswa> {
  final List<String> _mahasiswaList = [
    'Irvan Al Rasyid',
    'Adi Nugroho',
    'Rina Andriani',
    'Budi Santoso',
    'Siti Nurhaliza',
    'Teguh Prasetyo',
    'Jane Sartika',
    'Rizky Hidayat',
    'Fitriani Rahayu',
    'Agung Muhammad'
  ];

  Future<List<String>> _fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    return _mahasiswaList;
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _mahasiswaList.add('Mahasiswa Baru');
    });
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
                Navigator.of(context).pop(); // Tutup dialog tanpa melakukan aksi tambahan untuk saat ini
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToUpdateMahasiswa() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UpdateMahasiswa()),
    );
  }

  void _navigateToInformasiDataMahasiswa() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InformasiDataMahasiswa()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
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
          future: _fetchData(), // Mengambil data mahasiswa
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
            } else if (snapshot.hasData) {
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
                                        onPressed: _navigateToInformasiDataMahasiswa,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Colors.blueAccent),
                                        onPressed: _navigateToUpdateMahasiswa,
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
