import 'package:flutter/material.dart';
import 'package:responsi_kesehatan/bloc/CatatanKehamilan_bloc.dart'; // Ganti dengan bloc yang sesuai
import 'package:responsi_kesehatan/model/CatatanKehamilan.dart'; // Ganti dengan model catatan kehamilan
import 'package:responsi_kesehatan/ui/CatatanKehamilan_page.dart'; // Ganti dengan halaman catatan kehamilan
import 'package:responsi_kesehatan/widget/warning_dialog.dart';

class CatatanKehamilanForm extends StatefulWidget {
  CatatanKehamilan? catatanKehamilan;

  CatatanKehamilanForm({Key? key, this.catatanKehamilan}) : super(key: key);

  @override
  _CatatanKehamilanFormState createState() => _CatatanKehamilanFormState();
}

class _CatatanKehamilanFormState extends State<CatatanKehamilanForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH CATATAN KEHAMILAN";
  String tombolSubmit = "SIMPAN";

  final _patientNameTextboxController = TextEditingController();
  final _gestationalWeekTextboxController = TextEditingController();
  final _babyWeightTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.catatanKehamilan != null) {
      setState(() {
        judul = "UBAH CATATAN KEHAMILAN";
        tombolSubmit = "UBAH";
        _patientNameTextboxController.text = widget.catatanKehamilan!.patientName!;
        _gestationalWeekTextboxController.text =
            widget.catatanKehamilan!.gestationalWeek.toString();
        _babyWeightTextboxController.text =
            widget.catatanKehamilan!.babyWeight.toString();
      });
    } else {
      judul = "TAMBAH CATATAN KEHAMILAN";
      tombolSubmit = "SIMPAN";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul, style: const TextStyle(fontFamily: 'Helvetica')),
        backgroundColor: Colors.yellow[700], // Warna kuning gelap
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _patientNameTextField(),
                _gestationalWeekTextField(),
                _babyWeightTextField(),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Membuat Textbox Nama Pasien
  Widget _patientNameTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Nama Pasien",
        labelStyle: TextStyle(fontFamily: 'Helvetica'),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.text,
      controller: _patientNameTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Nama Pasien harus diisi";
        }
        return null;
      },
    );
  }

  // Membuat Textbox Usia Kehamilan
  Widget _gestationalWeekTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Usia Kehamilan (minggu)",
        labelStyle: TextStyle(fontFamily: 'Helvetica'),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      controller: _gestationalWeekTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Usia Kehamilan harus diisi";
        }
        return null;
      },
    );
  }

  // Membuat Textbox Berat Bayi
  Widget _babyWeightTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Berat Bayi (gram)",
        labelStyle: TextStyle(fontFamily: 'Helvetica'),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      controller: _babyWeightTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Berat Bayi harus diisi";
        }
        return null;
      },
    );
  }

  // Membuat Tombol Simpan/Ubah
  Widget _buttonSubmit() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.yellow[700], // Warna kuning untuk tombol
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
        child: Text(
          tombolSubmit,
          style: const TextStyle(color: Colors.white, fontFamily: 'Helvetica'),
        ),
        onPressed: () {
          var validate = _formKey.currentState!.validate();
          if (validate) {
            if (!_isLoading) {
              if (widget.catatanKehamilan != null) {
                // Kondisi update catatan kehamilan
                ubah();
              } else {
                // Kondisi tambah catatan kehamilan
                simpan();
              }
            }
          }
        },
      ),
    );
  }

  // Fungsi untuk menyimpan catatan kehamilan baru
  simpan() {
    setState(() {
      _isLoading = true;
    });

    CatatanKehamilan createCatatanKehamilan = CatatanKehamilan(
      id: null,
      patientName: _patientNameTextboxController.text,
      gestationalWeek: int.parse(_gestationalWeekTextboxController.text),
      babyWeight: int.parse(_babyWeightTextboxController.text),
    );

    CatatanKehamilanBloc.addCatatanKehamilan(catatan: createCatatanKehamilan).then((value) {
      if (value) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const CatatanKehamilanPage())); // Ganti dengan halaman yang sesuai
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
            description: "Simpan gagal, silahkan coba lagi",
          ),
        );
      }
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "Simpan gagal, silahkan coba lagi",
        ),
      );
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  // Fungsi untuk memperbarui catatan kehamilan yang sudah ada
  ubah() {
    setState(() {
      _isLoading = true;
    });

    CatatanKehamilan updateCatatanKehamilan = CatatanKehamilan(
      id: widget.catatanKehamilan!.id!,
      patientName: _patientNameTextboxController.text,
      gestationalWeek: int.parse(_gestationalWeekTextboxController.text),
      babyWeight: int.parse(_babyWeightTextboxController.text),
    );

    CatatanKehamilanBloc.updateCatatanKehamilan(catatan: updateCatatanKehamilan).then((value) {
      if (value) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const CatatanKehamilanPage())); // Ganti dengan halaman yang sesuai
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
            description: "Permintaan ubah data gagal, silahkan coba lagi",
          ),
        );
      }
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "Permintaan ubah data gagal, silahkan coba lagi",
        ),
      );
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }
}
