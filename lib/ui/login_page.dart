import 'package:flutter/material.dart';
import 'package:responsi_kesehatan/bloc/login_bloc.dart'; // Ubah sesuai nama folder project
import 'package:responsi_kesehatan/helpers/user_info.dart'; // Ubah sesuai nama folder project
import 'package:responsi_kesehatan/ui/CatatanKehamilan_page.dart'; // Ganti dengan halaman tujuan setelah login
import 'package:responsi_kesehatan/ui/registrasi_page.dart'; // Ubah sesuai nama folder project
import 'package:responsi_kesehatan/widget/warning_dialog.dart'; // Ubah sesuai nama folder project

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(fontFamily: 'Helvetica')),
        backgroundColor: Colors.yellow[700], // Warna kuning gelap untuk app bar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _emailTextField(),
                _passwordTextField(),
                _buttonLogin(),
                const SizedBox(height: 30),
                _menuRegistrasi()
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Membuat Textbox email
  Widget _emailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: const TextStyle(fontFamily: 'Helvetica'),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        return null;
      },
    );
  }

  // Membuat Textbox password
  Widget _passwordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: const TextStyle(fontFamily: 'Helvetica'),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password harus diisi";
        }
        return null;
      },
    );
  }

  // Membuat Tombol Login
  Widget _buttonLogin() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow[700], // Warna kuning untuk tombol
        foregroundColor: Colors.white, // Warna teks putih
      ),
      child: const Text("Login", style: TextStyle(fontFamily: 'Helvetica')),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) _submit();
        }
      },
    );
  }

  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    LoginBloc.login(
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text
    ).then((value) async {
      if (value.code == 200) {
        await UserInfo().setToken(value.token.toString());
        await UserInfo().setUserID(int.parse(value.userID.toString()));
        
        // Navigasi ke halaman Catatan Kehamilan setelah login
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const CatatanKehamilanPage())); // Ganti dengan halaman tujuan
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
            description: "Login gagal, silahkan coba lagi",
          ));
      }
    }, onError: (error) {
      print(error);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const WarningDialog(
          description: "Login gagal, silahkan coba lagi",
        ));
    });

    setState(() {
      _isLoading = false;
    });
  }

  // Membuat menu untuk membuka halaman registrasi
  Widget _menuRegistrasi() {
    return Center(
      child: InkWell(
        child: const Text(
          "Registrasi",
          style: TextStyle(color: Colors.blue, fontFamily: 'Helvetica'),
        ),
        onTap: () {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RegistrasiPage()));
        },
      ),
    );
  }
}
