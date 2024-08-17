import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kampusku/utils/theme/light_and_dark.dart';
import 'package:kampusku/viewmodels/input_data_view_model.dart';
import 'package:logger/logger.dart';

class InputData extends StatefulWidget {
  const InputData({super.key});

  @override
  State<InputData> createState() => _InputDataState();
}

class _InputDataState extends State<InputData> {
  final InputDataViewModel inputDataViewModel = InputDataViewModel();
  final logger = Logger();
  // Controllers
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _npmController = TextEditingController();

  // FocusNodes
  FocusNode _namaFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _dobFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  FocusNode _npmFocusNode = FocusNode();
  FocusNode _genderFocusNodeMale = FocusNode();
  FocusNode _genderFocusNodeFemale = FocusNode();
  FocusNode _saveButtonFocusNode = FocusNode();

  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    super.dispose();
    // Dispose FocusNodes
    _namaFocusNode.dispose();
    _phoneFocusNode.dispose();
    _dobFocusNode.dispose();
    _addressFocusNode.dispose();
    _npmFocusNode.dispose();
    _genderFocusNodeMale.dispose();
    _genderFocusNodeFemale.dispose();
    _saveButtonFocusNode.dispose();
  }

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
        inputDataViewModel.updateTanggalLahir(_dobController.text);
        setState(() {});
      });
    }
  }

  void _resetForm() {
    _nameController.clear();
    _phoneController.clear();
    _dobController.clear();
    _addressController.clear();
    _npmController.clear();
    inputDataViewModel.inputDataModel.jenis_kelamin = 'Laki-laki';
    inputDataViewModel.inputDataModel.isButtonEnabled = false;
    setState(() {
      _selectedDate = DateTime.now();
    });
    Future.delayed(Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_namaFocusNode);
      FocusScope.of(context).unfocus();
    });
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
                inputDataViewModel.inputDataMahasiswa().then((result) async {
                  Map<String, dynamic> responseBody = result['responseBody'];
                  int statusCode = result['statusCode'];

                  if (statusCode == 200) {
                    inputDataViewModel.inputDataModel.timeStamp = responseBody['timestamp'];
                    inputDataViewModel.inputDataModel.status = responseBody['status'];
                    inputDataViewModel.inputDataModel.message = responseBody['message'];

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
                            inputDataViewModel.inputDataModel.message,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () async {
                                // Menampilkan CircularProgressIndicator
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                );

                                // Memberikan waktu tunggu 1500 milidetik
                                await Future.delayed(Duration(milliseconds: 1500));
                                Navigator.of(context).pop();

                                Navigator.of(context).pop();
                                _resetForm();
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
                  } else {
                    inputDataViewModel.inputDataModel.timeStamp = responseBody['timestamp'];
                    inputDataViewModel.inputDataModel.status = responseBody['status'];
                    inputDataViewModel.inputDataModel.message = responseBody['message'];

                    if(
                    inputDataViewModel.inputDataModel.message == "SERVER MENGALAMI GANGGUAN, SILAHKAN COBA LAGI NANTI !!!" ||
                    inputDataViewModel.inputDataModel.message == "Nama tidak boleh berisikan kurang dari 3 kata !!!" ||
                    inputDataViewModel.inputDataModel.message == "Nomer Handphone minimal harus terdiri dari 12 angka !!!" ||
                    inputDataViewModel.inputDataModel.message == "Format Tanggal Lahir harus tahun-bulan-tanggal !!!" ||
                    inputDataViewModel.inputDataModel.message == "Jenis Kelamin di tolak, Masukan kata 'Laki-laki' atau 'Perempuan' !!!" ||
                    inputDataViewModel.inputDataModel.message == "Alamat minimal harus terdiri dari 5 kata !!!" ||
                    inputDataViewModel.inputDataModel.message == "NPM minimal harus terdiri dari 8 karakter !!!" ||
                    inputDataViewModel.inputDataModel.message == "Nama tidak boleh mengandung karakter backtick atau tanda dollar!" ||
                    inputDataViewModel.inputDataModel.message == "Nomer Handphone tidak boleh mengandung karakter backtick atau tanda dollar!" ||
                    inputDataViewModel.inputDataModel.message == "Tanggal Lahir tidak boleh mengandung karakter backtick atau tanda dollar!" ||
                    inputDataViewModel.inputDataModel.message == "Jenis Kelamin tidak boleh mengandung karakter backtick atau tanda dollar!" ||
                    inputDataViewModel.inputDataModel.message == "Alamat tidak boleh mengandung karakter backtick atau tanda dollar!" ||
                    inputDataViewModel.inputDataModel.message == "NPM tidak boleh mengandung karakter backtick atau tanda dollar!"
                    ) {
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
                                inputDataViewModel.inputDataModel.message,
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
                }).catchError((error) {
                  logger.e(error);
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        key: const Key('AlertGetApiKey'),
                        title: const Center(
                          child:Text(
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
                });
                Navigator.of(context).pop();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Input Data',
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
      body: GestureDetector(
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
                    focusNode: _namaFocusNode,
                    inputType: TextInputType.text,
                    onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneFocusNode),
                    onChanged: (value) => {
                      inputDataViewModel.updateNama(value),
                      setState(() {})
                    },
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
                  label: 'No.handphone',
                  icon: Icons.phone,
                  controller: _phoneController,
                  focusNode: _phoneFocusNode,
                  inputType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onEditingComplete: () => FocusScope.of(context).requestFocus(_dobFocusNode),
                  onChanged: (value) => {
                    inputDataViewModel.updateNomerHandPhone(value),
                    setState(() {})
                  },
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
                                  groupValue: inputDataViewModel.inputDataModel.jenis_kelamin,
                                  onChanged: (String? value) {
                                    inputDataViewModel.updateJenisKelamin(value!);
                                    setState(() {});
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
                                  groupValue: inputDataViewModel.inputDataModel.jenis_kelamin,
                                  onChanged: (String? value) {
                                    inputDataViewModel.updateJenisKelamin(value!);
                                    setState(() {});
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
                  onChanged: (value) => {
                    inputDataViewModel.updateAlamat(value),
                    setState(() {})
                  },
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
                  onChanged: (value) => {
                    inputDataViewModel.updateNpm(value),
                    setState(() {})
                  },
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
                    color: inputDataViewModel.inputDataModel.isButtonEnabled
                        ? LightAndDarkMode.primaryColor(context)
                        : Colors.grey,
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: inputDataViewModel.inputDataModel.isButtonEnabled ? _showConfirmDialog : null,
                    child: Text(
                      'Simpan',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: inputDataViewModel.inputDataModel.isButtonEnabled ? LightAndDarkMode.textColor2(context) : Colors.blueGrey,
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
    ValueChanged? onChanged,
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
        onChanged: onChanged,
        style: style,
        cursorColor: Colors.black,
      ),
    );
  }
}
