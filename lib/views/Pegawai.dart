import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logintest/main.dart';
import 'package:logintest/views/registrasi.dart';

class MyList extends StatefulWidget {
  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  // ignore: close_sinks
  StreamController<List<ListPegawai>> _pegawaiController =
  new StreamController<List<ListPegawai>>.broadcast();

  @override
  void initState() {
    super.initState();
    loadPegawai();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Register()));
        },
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<List<ListPegawai>>(
          stream: _pegawaiController.stream,
          builder: (context, snapshot) {
            print(snapshot);
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: 100,
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              return MyListPopulate(listPegawai: snapshot.data);
            }
          },
        ),
      ),
    );
  }

  loadPegawai() async {
    await fetchPegawai().then((result) {
      _pegawaiController.sink.add(result);
    });
  }

  Future<List<ListPegawai>> fetchPegawai() async {
    final response =
    await http.post("http://android.sweetroommedan.com/apisample/tampil.php");
    print(response.statusCode);
    if (response.statusCode == 200) {
      return compute(parsePegawai, response.body);
    } else {
      throw Exception('Failed to load');
    }
  }

  static List<ListPegawai> parsePegawai(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<ListPegawai>((json) => ListPegawai.fromJson(json))
        .toList();
  }
}

class ListPegawai {
  String userId;
  String namaLengkap;
  String alamatLengkap;
  DateTime tanggalLahir;
  String noTelp;

  ListPegawai({
    this.userId,
    this.namaLengkap,
    this.alamatLengkap,
    this.tanggalLahir,
    this.noTelp,
  });

  factory ListPegawai.fromJson(Map<String, dynamic> json) => new ListPegawai(
    userId: json["userId"],
    namaLengkap: json["namaLengkap"],
    alamatLengkap: json["alamatLengkap"],
    tanggalLahir: DateTime.parse(json["tanggalLahir"]),
    noTelp: json["noTelp"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "namaLengkap": namaLengkap,
    "alamatLengkap": alamatLengkap,
    "tanggalLahir":
    "${tanggalLahir.year.toString().padLeft(4, '0')}-${tanggalLahir.month.toString().padLeft(2, '0')}-${tanggalLahir.day.toString().padLeft(2, '0')}",
    "noTelp": noTelp,
  };
}

// ignore: must_be_immutable
class MyListPopulate extends StatefulWidget {
  List<ListPegawai> listPegawai;

  MyListPopulate({Key key, this.listPegawai}) : super(key: key);

  @override
  _MyListPopulateState createState() => _MyListPopulateState();
}
class _MyListPopulateState extends State<MyListPopulate> {
  @override
  void initState() {
    super.initState();
  }

  @override

  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: widget.listPegawai.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            return showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Action'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Delete'),
                      onPressed: () {
                        deleteData(widget.listPegawai[index].userId);
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('Edit'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditPage(dataedit:widget.listPegawai[index])),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Card(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.50,
              child: ListTile(
                title: Text(
                  widget.listPegawai[index].namaLengkap,
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: Text(
                  widget.listPegawai[index].alamatLengkap,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  deleteData(String userId) async {
    try {
      final response = await http
          .post("http://android.sweetroommedan.com/apisample/delete.php", body: {
        "userId": userId,
      });

      if (response.statusCode < 200 || response.statusCode > 300) {
        print(response.statusCode);
        throw new Exception('Failed to insert data');
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text("Berhasil"),
              );
            });
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
    setState(() {
      widget.listPegawai
          .removeWhere((listpegawai) => listpegawai.userId == userId);
    });
  }
}

// ignore: must_be_immutable
class EditPage extends StatefulWidget {
  dynamic dataedit;
  EditPage({Key key, this.title,this.dataedit}) : super(key: key);
  final String title;

  @override
  _EditPageState createState() => _EditPageState();
}
class _EditPageState extends State<EditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController namaLengkapController = new TextEditingController();
  TextEditingController alamatController = new TextEditingController();
  TextEditingController tanggalLahirController = new TextEditingController();
  TextEditingController notelpController = new TextEditingController();

  String _format = 'yyyy-MMMM-dd';
  DateTime _dateTime;
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;

  @override
  void initState() {
    namaLengkapController.text = widget.dataedit.namaLengkap;
    alamatController.text = widget.dataedit.alamatLengkap;
    notelpController.text = widget.dataedit.namaLengkap;
    tanggalLahirController.text = DateFormat('yyyy-MM-dd').format(widget.dataedit.tanggalLahir);
    _dateTime =widget.dataedit.tanggalLahir;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Data"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Divider(
                  height: 50.0,
                  color: Colors.white,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                  const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: new TextFormField(
                          controller: namaLengkapController,
                          textInputAction: TextInputAction.next,
                          decoration: new InputDecoration(
                              labelText: "Nama Lengkap",
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              fillColor: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 14.0,
                  color: Colors.white,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                  const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: new TextFormField(
                          controller: notelpController,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v) {},
                          decoration: new InputDecoration(
                              labelText: "No Telp",
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              fillColor: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 14.0,
                  color: Colors.white,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                  const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _showDatePicker();
                          },
                          child: IgnorePointer(
                            child: TextFormField(
                              controller: tanggalLahirController,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (v) {},
                              decoration: new InputDecoration(
                                  labelText: "Tanggal Lahir",
                                  filled: true,
                                  hintStyle:
                                  new TextStyle(color: Colors.grey[800]),
                                  fillColor: Colors.white70),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 14.0,
                  color: Colors.white,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                  const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: new TextFormField(
                          controller: alamatController,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (v) {},
                          decoration: new InputDecoration(
                              labelText: "Alamat",
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.grey[800]),
                              fillColor: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
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
                            prosesUbah();
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
                                    "Ubah Data",
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
              ],
            ),
          ),
        ),
      ),
    );
  }

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
          tanggalLahirController.text =
              DateFormat('yyyy-MM-dd').format(_dateTime);
        });
      },
    );
  }

  prosesUbah() async {
    String _namaInput = namaLengkapController.text;
    String _noTelp = notelpController.text;
    String _alamat = alamatController.text;
    String _tanggalLahir = tanggalLahirController.text;
    try {
      final response = await http
          .post("http://android.sweetroommedan.com/apisample/update.php/", body: {
        "userId":widget.dataedit.userId,
        "namaLengkap": _namaInput,
        "notelp": _noTelp,
        "alamatLengkap": _alamat,
        "tanggallahir": _tanggalLahir
      });

      if (response.statusCode < 200 || response.statusCode > 300) {
        print(response.statusCode);
        throw new Exception('Failed to insert data');
      } else {
        showDialog(
            barrierDismissible: true,
            context: context,

            builder: (BuildContext context) {
              return AlertDialog(
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                  ),
                ],
                content: Text("Berhasil"),
              );
            });
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

