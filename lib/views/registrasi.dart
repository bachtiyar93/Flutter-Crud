import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart";
import 'package:intl/intl.dart';
import 'package:logintest/modal/api.dart';
import 'package:http/http.dart' as http;



//Class Register Layout Dimulai
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String
  username,
      nama,
      tempatlahir,
      tanggallahir,
      notelepon,
      alamat,
      alamatdomisili,
      agama,
      jabatan,
      setatus,
      tanggalmasuk,
      email,
      password,
      passwordconfirm;


//Tanggal Picker
  String _format = 'yyyy-MMMM-dd';
  DateTime _dateTime;
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  String _format2 = 'yyyy-MMMM-dd';
  DateTime _dateTime2;
  DateTimePickerLocale _locale2 = DateTimePickerLocale.en_us;

  void _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        confirm: Text('Ok', style: TextStyle(color: Colors.cyan)),
        cancel: Text('Close', style: TextStyle(color: Colors.red)),
      ),
      initialDateTime: _dateTime,
      dateFormat: _format,
      locale: _locale,
      onClose: () => print("----- onClose -----"),
      onCancel: () => print('onCancel'),
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
          tanggallahir = DateFormat('yyyy-MM-dd').format(_dateTime);
        });
      },
    );
  }
  void _showDatePicker2() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        confirm: Text('Ok', style: TextStyle(color: Colors.cyan)),
        cancel: Text('Close', style: TextStyle(color: Colors.red)),
      ),
      initialDateTime: _dateTime2,
      dateFormat: _format2,
      locale: _locale2,
      onClose: () => print("----- onClose -----"),
      onCancel: () => print('onCancel'),
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTime2 = dateTime;
        });
      },
      onConfirm: (dateTime2, List<int> index) {
        setState(() {
          _dateTime2 = dateTime2;
          tanggalmasuk = DateFormat('yyyy-MM-dd').format(_dateTime2);
        });
      },
    );
  }
  //Akhir Tanggal Picker
  final _key = new GlobalKey<FormState>();



  bool _secureText = true;
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }


  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    }
  }
// Ini untuk Proses Penyimpanan data diarahkan ke API Register
  save() async {
    final response = await http.post(BaseUrl.register,
        body: {
          "id_ktp": username,
          "id_nama": nama,
          "id_tempat_lahir": tempatlahir,
          "id_tanggal_lahir":tanggallahir,
          "id_no_telepon":notelepon,
          "id_alamat":alamat,
          "id_alamat_domisili":alamatdomisili,
          "id_agama":agama,
          "id_jabatan":jabatan,
          "id_tanggal_masuk":tanggalmasuk,
          "id_setatus":setatus,
          "id_email":email,
          "password":password,
        });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
      });
    } else {print(pesan);
    }
  }
  //String Dropdown
  List<String> _agama = ['Islam', 'Kristen', 'Buddha', 'Hindu','Konghuchu','Lainnya'];
  String _selectedAgama;
  List<String> _setatus =['Aktif Bekerja','Dropout','PHK'];
  String _selectedSetatus;
  List<String> _jabatan=['Marketing','Jahit','Potong','Packing','Checking','Pasang','Potong & Kurir','Admin'];
  String _selectedJabatan;
  // Option 2
//Form Pengisian Pendaftaran
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              validator: (e) {
                if (e.length <15) {
                  return "Please insert NIK berupa Angka 16 Digit";
                }
              },
              onSaved: (e) => username = e,
              decoration: InputDecoration(labelText: "NIK"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return "Masukan Nama Lengkap";
                }
              },
              onSaved: (e) => nama = e,
              decoration: InputDecoration(labelText: "Nama Lengkap"),
            ),
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return "Please insert Tempat Lahir";
                }
              },
              onSaved: (e) => tempatlahir = e,
              decoration: InputDecoration(labelText: "Tempat Lahir"),

            ),

            //Start Tanggal By Selected
            InkWell(
              onTap: () {
                _showDatePicker();
              },
              child: IgnorePointer(
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  onSaved: (e) => tanggallahir = (e),
                  decoration: new InputDecoration(
                      hintText: "Tanggal Lahir",
                      labelText: tanggallahir),
                ),
              ),
            ),
            //End Start Selected
            TextFormField(
              validator: (e) {
                if (e.length <11) {
                  return "No telepon berupa Angka 12 Digit diawali dengan 0";
                }
              },
              onSaved: (e) => notelepon = e,
              decoration:  InputDecoration(labelText: "No Telepon"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return "Masukan Alamat";
                }
              },
              onSaved: (e) => alamat = e,
              decoration: InputDecoration(labelText: "Alamat KTP"),
            ),
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return "Masukan alamat tinggal sekarang";
                }
              },
              onSaved: (e) => alamatdomisili = e,
              decoration: InputDecoration(labelText: "Alamat Domisili"),
            ),
            DropdownButton(
              hint: Text('Agama'), // Not necessary for Option 1
              value: _selectedAgama,
              onChanged: (newValue)
              {
                setState(() {
                  _selectedAgama = newValue;
                  agama = _selectedAgama;
                });
              } ,
              items: _agama.map((location) {
                return DropdownMenuItem(
                  child: new Text(location),
                  value: location,
                );
              }).toList(),
            ),
            DropdownButton(
              hint: Text('Jabatan'), // Not necessary for Option 1
              value: _selectedJabatan,
              onChanged: (newValue)
              {
                setState(() {
                  _selectedJabatan = newValue;
                  jabatan=_selectedJabatan;
                });
              } ,
              items: _jabatan.map((location) {
                return DropdownMenuItem(
                  child: new Text(location),
                  value: location,
                );
              }).toList(),
            ),
            DropdownButton(
              hint: Text('Setatus'), // Not necessary for Option 1
              value: _selectedSetatus,
              onChanged: (newValue)
              {
                setState(() {
                  _selectedSetatus = newValue;
                  setatus=_selectedSetatus;
                });
              } ,
              items: _setatus.map((location) {
                return DropdownMenuItem(
                  child: new Text(location),
                  value: location,
                );
              }).toList(),
            ),
            InkWell(
              onTap: () {
                _showDatePicker2();
              },
              child: IgnorePointer(
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  onChanged: (e) => tanggalmasuk = (e),
                  decoration: new InputDecoration(
                      hintText: "Tanggal Masuk Kerja",
                      labelText: tanggalmasuk),
                ),
              ),
            ),
            TextFormField(
              validator: (e) {
                if (!e.contains('@')) {
                  return "Email tidak sesuai";
                }
              },
              onSaved: (e) => email = e,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextFormField(
              obscureText: _secureText,
              onChanged: (e) => passwordconfirm = e,
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  onPressed: showHide,
                  icon: Icon(
                      _secureText ? Icons.visibility_off : Icons.visibility),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Center(
                  child: TextFormField(
                    validator: (e) {
                      if (e != passwordconfirm) {
                        return "Password does not match";
                      }
                    },
                    obscureText: _secureText,
                    onSaved: (e)=> password = e,
                    decoration: InputDecoration(
                      labelText: " Confirm Password",
                      suffixIcon: IconButton(
                        onPressed: showHide,
                        icon: Icon(
                            _secureText ? Icons.visibility_off : Icons.visibility),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //Divider Tombol Save
            Divider(
              height: 14.0,
              color: Colors.white,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin:
              const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
              alignment: Alignment.center,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new FlatButton(
                      color: Colors.red,
                      onPressed: () {
                        check();
                      },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      child: new Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 20.0,
                        ),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Expanded(
                              child: Text(
                                "Register",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Akhir Divider Tombol Save
          ],
        ),
      ),
    );
  }
}