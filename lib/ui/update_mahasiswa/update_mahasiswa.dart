import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kampusku/models/update_mahasiswa_model.dart';
import 'package:kampusku/utils/routes/route_paths.dart';
import 'package:kampusku/utils/theme/light_and_dark.dart';
import 'package:kampusku/viewmodels/update_mahasiswa_view_model.dart';
import 'package:logger/logger.dart';

class UpdateMahasiswa extends StatefulWidget {
  final String nama;

  const UpdateMahasiswa({
    super.key,
    required this.nama
  });

  @override
  State<UpdateMahasiswa> createState() => _UpdateMahasiswaState();
}

class _UpdateMahasiswaState extends State<UpdateMahasiswa> {
  final UpdateMahasiswaViewModel updateMahasiswaViewModel = UpdateMahasiswaViewModel();
  final logger = Logger();

  // Controllers
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _npmController = TextEditingController();

  // FocusNodes
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _dobFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  FocusNode _npmFocusNode = FocusNode();
  FocusNode _genderFocusNodeMale = FocusNode();
  FocusNode _genderFocusNodeFemale = FocusNode();
  FocusNode _saveButtonFocusNode = FocusNode();

  DateTime _selectedDate = DateTime.now();
  String _gender = 'Laki-laki';

  bool _isLoading = true;
  bool _isError = false;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1998),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }

  bool _isFormValid() {
    return _nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _dobController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _npmController.text.isNotEmpty;
  }

  void fetchData() async {
    try {
      final result = await updateMahasiswaViewModel.getDataMahasiswa();
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
        updateMahasiswaViewModel.updateMahasiswaModel.timeStamp = responseBody['timestamp'];
        updateMahasiswaViewModel.updateMahasiswaModel.status = responseBody['status'];
        updateMahasiswaViewModel.updateMahasiswaModel.message = responseBody['message'];
        updateMahasiswaViewModel.updateMahasiswaModel.data = [data];
        _nameController.text = updateMahasiswaViewModel.updateMahasiswaModel.data[0].nama;
        _phoneController.text = updateMahasiswaViewModel.updateMahasiswaModel.data[0].nomer_handphone;
        _dobController.text = updateMahasiswaViewModel.updateMahasiswaModel.data[0].tanggal_lahir;
        _gender = updateMahasiswaViewModel.updateMahasiswaModel.data[0].jenis_kelamin;
        _addressController.text = updateMahasiswaViewModel.updateMahasiswaModel.data[0].alamat;
        _npmController.text = updateMahasiswaViewModel.updateMahasiswaModel.data[0].npm;

        await Future.delayed(Duration(milliseconds: 1500));
        setState(() {
          _isLoading = false;
        });
      } else {
        await Future.delayed(Duration(milliseconds: 1500));
        setState(() {
          _isLoading = false;
          _isError = true;
        });
        updateMahasiswaViewModel.updateMahasiswaModel.timeStamp = responseBody['timestamp'];
        updateMahasiswaViewModel.updateMahasiswaModel.status = responseBody['status'];
        updateMahasiswaViewModel.updateMahasiswaModel.message = responseBody['message'];

        if (updateMahasiswaViewModel.updateMahasiswaModel.message == "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!") {
          if (context.mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    "INFORMASI",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  content: Text(
                    updateMahasiswaViewModel.updateMahasiswaModel.message,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
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
        } else {
          throw Exception('Error selain 403 dengan message Username Atau Password salah silahkan coba lagi !!!');
        }
      }
    } catch (error) {
      await Future.delayed(Duration(milliseconds: 1500));
      setState(() {
        _isLoading = false;
        _isError = true;
      });
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

  void sendingFentchData() async {
    try {
      final result = await updateMahasiswaViewModel.updateDataMahasiswa(
          _nameController.text,
          _phoneController.text,
          _dobController.text,
          _gender,
          _addressController.text,
          _npmController.text
      );
      Map<String, dynamic> responseBody = result['responseBody'];
      int statusCode = result['statusCode'];

      if (statusCode == 200) {
        // Mengupdate model dengan data dari responseBody
        updateMahasiswaViewModel.updateMahasiswaModel.timeStamp = responseBody['timestamp'];
        updateMahasiswaViewModel.updateMahasiswaModel.status = responseBody['status'];
        updateMahasiswaViewModel.updateMahasiswaModel.message = responseBody['message'];

        Navigator.pushReplacementNamed(context, RoutePaths.dashboard);
      } else {
        updateMahasiswaViewModel.updateMahasiswaModel.timeStamp = responseBody['timestamp'];
        updateMahasiswaViewModel.updateMahasiswaModel.status = responseBody['status'];
        updateMahasiswaViewModel.updateMahasiswaModel.message = responseBody['message'];

        if (
            updateMahasiswaViewModel.updateMahasiswaModel.message == "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!" ||
            updateMahasiswaViewModel.updateMahasiswaModel.message == "Nama tidak boleh berisikan kurang dari 3 kata !!!" ||
            updateMahasiswaViewModel.updateMahasiswaModel.message == "Nomer Handphone minimal harus terdiri dari 12 angka !!!" ||
            updateMahasiswaViewModel.updateMahasiswaModel.message == "Format Tanggal Lahir harus tahun-bulan-tanggal !!!" ||
            updateMahasiswaViewModel.updateMahasiswaModel.message == "Jenis Kelamin di tolak, Masukan kata 'Laki-laki' atau 'Perempuan' !!!" ||
            updateMahasiswaViewModel.updateMahasiswaModel.message == "Alamat minimal harus terdiri dari 5 kata !!!" ||
            updateMahasiswaViewModel.updateMahasiswaModel.message == "NPM minimal harus terdiri dari 8 karakter !!!" ||
            updateMahasiswaViewModel.updateMahasiswaModel.message == "Nama tidak boleh mengandung karakter backtick atau tanda dollar!" ||
            updateMahasiswaViewModel.updateMahasiswaModel.message == "Nomer Handphone tidak boleh mengandung karakter backtick atau tanda dollar!" ||
            updateMahasiswaViewModel.updateMahasiswaModel.message == "Tanggal Lahir tidak boleh mengandung karakter backtick atau tanda dollar!" ||
            updateMahasiswaViewModel.updateMahasiswaModel.message == "Jenis Kelamin tidak boleh mengandung karakter backtick atau tanda dollar!" ||
            updateMahasiswaViewModel.updateMahasiswaModel.message == "Alamat tidak boleh mengandung karakter backtick atau tanda dollar!" ||
            updateMahasiswaViewModel.updateMahasiswaModel.message == "NPM tidak boleh mengandung karakter backtick atau tanda dollar!"
        ) {
          if (context.mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    "INFORMASI",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  content: Text(
                    updateMahasiswaViewModel.updateMahasiswaModel.message,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
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


  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Apakah Anda yakin ingin menyimpan data ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                sendingFentchData();
              },
              child: Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    updateMahasiswaViewModel.updateMahasiswaModel.namaKirim = widget.nama;
    fetchData();
  }

  @override
  void dispose() {
    // Dispose FocusNodes
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _dobFocusNode.dispose();
    _addressFocusNode.dispose();
    _npmFocusNode.dispose();
    _genderFocusNodeMale.dispose();
    _genderFocusNodeFemale.dispose();
    _saveButtonFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Update Mahasiswa',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 24,
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
          body: _isLoading
            ? Center(child: CircularProgressIndicator())
              : _isError
            ? Center(child: Text('Data kosong !!!'),)
              : GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                currentFocus.unfocus();
              }
            },
            child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                        child: _buildTextField(
                          label: 'Nama',
                          icon: Icons.person,
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          inputType: TextInputType.text,
                          onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneFocusNode),
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: LightAndDarkMode.textColor1(context),
                            ),
                          ),
                        ),
                      ),
                      _buildTextField(
                        label: 'No.telp',
                        icon: Icons.phone,
                        controller: _phoneController,
                        focusNode: _phoneFocusNode,
                        inputType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onEditingComplete: () => FocusScope.of(context).requestFocus(_dobFocusNode),
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: LightAndDarkMode.textColor1(context),
                          ),
                        ),
                      ),
                      _buildTextField(
                        label: 'Tanggal Lahir',
                        icon: Icons.calendar_today,
                        controller: _dobController,
                        focusNode: _dobFocusNode,
                        inputType: TextInputType.text,
                        onTap: () => _selectDate(context),
                        readOnly: true,
                        onEditingComplete: () => FocusScope.of(context).requestFocus(_genderFocusNodeMale),
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: LightAndDarkMode.textColor1(context),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(Icons.transgender),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 5),
                                      title: Text(
                                        'Laki-laki',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            color: LightAndDarkMode.textColor1(context),
                                          ),
                                        ),
                                      ),
                                      leading: Radio<String>(
                                        value: 'Laki-laki',
                                        groupValue: _gender,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _gender = value!;
                                          });
                                        },
                                      ),
                                      focusNode: _genderFocusNodeMale,
                                      onFocusChange: (hasFocus) {
                                        if (!hasFocus) {
                                          FocusScope.of(context).requestFocus(_genderFocusNodeFemale);
                                        }
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 5),
                                      title: Text(
                                        'Perempuan',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            color: LightAndDarkMode.textColor1(context),
                                          ),
                                        ),
                                      ),
                                      leading: Radio<String>(
                                        value: 'Perempuan',
                                        groupValue: _gender,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _gender = value!;
                                          });
                                        },
                                      ),
                                      focusNode: _genderFocusNodeFemale,
                                      onFocusChange: (hasFocus) {
                                        if (!hasFocus) {
                                          FocusScope.of(context).requestFocus(_saveButtonFocusNode);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildTextField(
                        label: 'Alamat',
                        icon: Icons.home,
                        controller: _addressController,
                        focusNode: _addressFocusNode,
                        inputType: TextInputType.text,
                        onEditingComplete: () => FocusScope.of(context).requestFocus(_npmFocusNode),
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: LightAndDarkMode.textColor1(context),
                          ),
                        ),
                      ),
                      _buildTextField(
                        label: 'NPM',
                        icon: Icons.confirmation_number,
                        controller: _npmController,
                        focusNode: _npmFocusNode,
                        inputType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onEditingComplete: () => FocusScope.of(context).requestFocus(_saveButtonFocusNode),
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: LightAndDarkMode.textColor1(context),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: _isFormValid()
                              ? LightAndDarkMode.primaryColor(context)
                              : Colors.grey,
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onPressed: _isFormValid() ? _showConfirmDialog : null,
                          child: Text(
                            'Simpan',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _isFormValid() ? LightAndDarkMode.textColor2(context) : Colors.blueGrey,
                              ),
                            ),
                          ),
                          focusNode: _saveButtonFocusNode,
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ),
        ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required FocusNode focusNode,
    required TextInputType inputType,
    required style,
    List<TextInputFormatter>? inputFormatters,
    VoidCallback? onTap,
    bool readOnly = false,
    VoidCallback? onEditingComplete,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: inputType,
        inputFormatters: inputFormatters,
        onTap: onTap,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
        ),
        onEditingComplete: onEditingComplete,
        style: style,
        cursorColor: LightAndDarkMode.textColor1(context),
      ),
    );
  }
}
