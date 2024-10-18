import 'package:flutter/material.dart';
import '/helpers/user_info.dart';
import '/ui/login_page.dart';
import '/ui/CatatanKehamilan_page.dart'; // Ganti dengan halaman catatan kehamilan

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = const CircularProgressIndicator(); 

  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    var token = await UserInfo().getToken(); 
    if (token != null) {
      setState(() {
        page = const CatatanKehamilanPage(); 
      });
    } else {
      setState(() {
        page = const LoginPage(); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Kehamilan', 
      debugShowCheckedModeBanner: false,
      home: page, 
    );
  }
}
