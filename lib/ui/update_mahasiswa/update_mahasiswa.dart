import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kampusku/utils/theme/light_and_dark.dart';

class UpdateMahasiswa extends StatefulWidget {
  const UpdateMahasiswa({super.key});

  @override
  State<UpdateMahasiswa> createState() => _UpdateMahasiswaState();
}

class _UpdateMahasiswaState extends State<UpdateMahasiswa> {
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
        _dobController.text = DateFormat('dd/MM/yyyy').format(_selectedDate);
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

  void _resetForm() {
    _nameController.clear();
    _phoneController.clear();
    _dobController.clear();
    _addressController.clear();
    _npmController.clear();
    setState(() {
      _selectedDate = DateTime.now();
      _gender = 'Laki-laki';
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
                _resetForm();
              },
              child: Text('Ya'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tidak'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    focusNode: _nameFocusNode,
                    inputType: TextInputType.text,
                    onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneFocusNode),
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
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
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
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
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
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
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
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
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
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
      ),
    );
  }
}
