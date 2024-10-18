import 'dart:convert';
import 'package:http/http.dart' as http; // Import http package
import 'package:responsi_kesehatan/helpers/api.dart';
import 'package:responsi_kesehatan/helpers/api_url.dart';
import 'package:responsi_kesehatan/model/registrasi.dart';

class RegistrasiBloc {
  static Future<Registrasi> registrasi(
      {required String nama, required String email, required String password}) async {
    String apiUrl = ApiUrl.registrasi; // Endpoint registrasi
    var body = json.encode({
      "nama": nama, // Menggunakan nama, email, dan password sesuai model
      "email": email,
      "password": password
    }); // Encode to JSON

    try {
      // Buat permintaan API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json', // Set header content type
        },
        body: body, // Pass the encoded JSON string here
      );

      // Cek apakah respons berhasil
      if (response.statusCode == 200) {
        var jsonObj = json.decode(response.body);
        return Registrasi.fromJson(jsonObj); // Parsing json ke model Registrasi
      } else {
        // Tangani error berdasarkan status code
        var errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      // Tangani error jaringan atau error parsing
      throw Exception('Failed to register: $e');
    }
  }
}
