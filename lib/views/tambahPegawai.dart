import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logintest/modal/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TambahPegawai extends StatefulWidget {
  final VoidCallback reload;
  TambahPegawai(this.reload);
  @override
  _TambahPegawaiState createState() => _TambahPegawaiState();
}

class _TambahPegawaiState extends State<TambahPegawai> {
  String id,
      id_ktp,
      namaPegawai,
      tempat_lahir,
      tanggal_lahir,
      alamat,
      alamatdomisili,
      notelepon,
      agama,
      jabatan,
      tanggal_masuk,
      status,
      email,
      pass,
      pendaftar;

  final _key = new GlobalKey<FormState>();

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  submit() async {
    final response = await http.post(BaseUrl.tambahProduk, body: {
      "id_nama": namaPegawai,
      "id_tempat_lahir": tempat_lahir,
      "id_tanggal_lahir":tanggal_lahir,
      "id_no_telepon":notelepon,
      "id_alamat":alamat,
      "id_alamat_domisili":alamatdomisili,
      "id_agama":agama,
      "id_jabatan":jabatan,
      "id_tanggal_masuk":tanggal_masuk,
      "id_setatus":status,
      "id_email":email,
      "password":pass,
      "id_ktp": id_ktp
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      print(pesan);
      setState(() {
        widget.reload();
        Navigator.pop(context);
      });
    } else {
      print(print);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

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
              onSaved: (e) => pass = e,
              decoration: InputDecoration(labelText: 'NIK'),
            ),
            TextFormField(
              onSaved: (e) => namaPegawai = e,
              decoration: InputDecoration(labelText: 'Nama Pegawai'),
            ),
            TextFormField(
              onSaved: (e) => tempat_lahir = e,
              decoration: InputDecoration(labelText: 'Tempat Lahir'),
            ),
            TextFormField(
              onSaved: (e) => tanggal_lahir = e,
              decoration: InputDecoration(labelText: 'Tanggal Lahir'),
            ),
            TextFormField(
              onSaved: (e) => notelepon = e,
              decoration: InputDecoration(labelText: 'No Tlepon'),
            ),
            TextFormField(
              onSaved: (e) => alamat = e,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            TextFormField(
              onSaved: (e) => alamatdomisili = e,
              decoration: InputDecoration(labelText: 'Alamat Domisili'),
            ),
            TextFormField(
              onSaved: (e) => agama = e,
              decoration: InputDecoration(labelText: 'Agama'),
            ),
            TextFormField(
              onSaved: (e) => jabatan = e,
              decoration: InputDecoration(labelText: 'Jabatan'),
            ),
            TextFormField(
              onSaved: (e) => tanggal_masuk = e,
              decoration: InputDecoration(labelText: 'Tanggal Masuk'),
            ),
            TextFormField(
              onSaved: (e) => status = e,
              decoration: InputDecoration(labelText: 'Status'),
            ),
            TextFormField(
              onSaved: (e) => email = e,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              onSaved: (e) => pass = e,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextFormField(
              onSaved: (e) => pendaftar = e,
              decoration: InputDecoration(labelText: 'Pendaftar'),
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              child: Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}
