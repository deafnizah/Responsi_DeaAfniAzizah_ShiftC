import 'package:flutter/material.dart';
import '../bloc/CatatanKehamilan_bloc.dart'; // Pastikan path ini sesuai
import '../widget/warning_dialog.dart';
import '/model/CatatanKehamilan.dart'; // Pastikan model ini ada
import '/ui/CatatanKehamilan_form.dart'; // Pastikan path ini sesuai
import '/ui/CatatanKehamilan_page.dart'; // Pastikan path ini sesuai

class CatatanKehamilanDetail extends StatefulWidget {
  final CatatanKehamilan? catatanKehamilan;

  const CatatanKehamilanDetail({Key? key, this.catatanKehamilan}) : super(key: key);

  @override
  _CatatanKehamilanDetailState createState() => _CatatanKehamilanDetailState();
}

class _CatatanKehamilanDetailState extends State<CatatanKehamilanDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Catatan Kehamilan',
          style: TextStyle(fontFamily: 'Helvetica'),
        ),
        backgroundColor: Colors.yellow[700], // Warna kuning gelap
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailText("Nama Pasien", widget.catatanKehamilan!.patientName!),
            const SizedBox(height: 10),
            _detailText("Usia Kehamilan", "${widget.catatanKehamilan!.gestationalWeek} minggu"),
            const SizedBox(height: 10),
            _detailText("Berat Bayi", "${widget.catatanKehamilan!.babyWeight} gram"),
            const SizedBox(height: 30),
            Center(child: _tombolHapusEdit()),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan detail informasi
  Widget _detailText(String label, String value) {
    return RichText(
      text: TextSpan(
        text: "$label: ",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black, fontFamily: 'Helvetica'),
        children: <TextSpan>[
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  // Widget untuk tombol Edit dan Delete
  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tombol Edit
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.yellow[700], // Warna kuning untuk tombol
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
          child: const Text(
            "EDIT",
            style: TextStyle(color: Colors.white, fontFamily: 'Helvetica'),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CatatanKehamilanForm(
                  catatanKehamilan: widget.catatanKehamilan!,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 20),
        // Tombol Hapus
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.red[700], // Warna merah untuk tombol hapus
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
          child: const Text(
            "DELETE",
            style: TextStyle(color: Colors.white, fontFamily: 'Helvetica'),
          ),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi hapus
  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text(
        "Yakin ingin menghapus data ini?",
        style: TextStyle(fontFamily: 'Helvetica'),
      ),
      actions: [
        // Tombol Hapus
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.red[700],
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text("Ya", style: TextStyle(color: Colors.white, fontFamily: 'Helvetica')),
          onPressed: () {
            CatatanKehamilanBloc.deleteCatatanKehamilan(id: widget.catatanKehamilan!.id!).then(
              (value) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const CatatanKehamilanPage(),
                ));
              },
              onError: (error) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => const WarningDialog(
                    description: "Hapus gagal, silahkan coba lagi",
                  ),
                );
              },
            );
          },
        ),
        // Tombol Batal
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.grey[600],
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text("Batal", style: TextStyle(color: Colors.white, fontFamily: 'Helvetica')),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
    showDialog(builder: (context) => alertDialog, context: context);
  }
}
