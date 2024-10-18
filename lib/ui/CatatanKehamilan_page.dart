import 'package:flutter/material.dart';
import '../bloc/logout_bloc.dart'; // Pastikan path ini benar
import '../bloc/CatatanKehamilan_bloc.dart'; // Ganti dengan bloc yang sesuai
import '/model/CatatanKehamilan.dart'; // Ganti dengan model yang sesuai
import '/ui/CatatanKehamilan_detail.dart'; // Ganti dengan detail catatan kehamilan
import '/ui/CatatanKehamilan_form.dart'; // Ganti dengan form catatan kehamilan
import 'login_page.dart';

class CatatanKehamilanPage extends StatefulWidget {
  const CatatanKehamilanPage({Key? key}) : super(key: key);

  @override
  _CatatanKehamilanPageState createState() => _CatatanKehamilanPageState();
}

class _CatatanKehamilanPageState extends State<CatatanKehamilanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Catatan Kehamilan', style: TextStyle(fontFamily: 'Helvetica')),
        backgroundColor: Colors.yellow[700], // Warna kuning gelap untuk app bar
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CatatanKehamilanForm()));
              },
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout', style: TextStyle(fontFamily: 'Helvetica')),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                await LogoutBloc.logout().then((value) => {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  )
                });
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<CatatanKehamilan>>( // Menggunakan model CatatanKehamilan
        future: CatatanKehamilanBloc.getCatatanKehamilan(), // Ganti dengan method yang sesuai
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListCatatanKehamilan(list: snapshot.data) // Sesuaikan dengan class ListCatatanKehamilan
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

class ListCatatanKehamilan extends StatelessWidget {
  final List<CatatanKehamilan>? list; // Sesuaikan dengan model CatatanKehamilan

  const ListCatatanKehamilan({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list == null ? 0 : list!.length,
      itemBuilder: (context, i) {
        return ItemCatatanKehamilan(catatanKehamilan: list![i]); // Ganti dengan class ItemCatatanKehamilan
      },
    );
  }
}

class ItemCatatanKehamilan extends StatelessWidget {
  final CatatanKehamilan catatanKehamilan; // Sesuaikan dengan model CatatanKehamilan

  const ItemCatatanKehamilan({Key? key, required this.catatanKehamilan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CatatanKehamilanDetail(
              catatanKehamilan: catatanKehamilan, // Ganti dengan detail catatan kehamilan
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(catatanKehamilan.patientName!, style: const TextStyle(fontFamily: 'Helvetica')), // Menampilkan nama pasien
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Usia Kehamilan: ${catatanKehamilan.gestationalWeek} minggu', style: const TextStyle(fontFamily: 'Helvetica')), // Usia kehamilan
              Text('Berat Bayi: ${catatanKehamilan.babyWeight} gram', style: const TextStyle(fontFamily: 'Helvetica')), // Berat bayi
            ],
          ),
        ),
      ),
    );
  }
}
