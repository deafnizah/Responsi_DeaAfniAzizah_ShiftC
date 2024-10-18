import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsi_kesehatan/helpers/api.dart';
import 'package:responsi_kesehatan/helpers/api_url.dart';
import 'package:responsi_kesehatan/model/CatatanKehamilan.dart';

class CatatanKehamilanBloc {
  // Mendapatkan daftar catatan kehamilan
  static Future<List<CatatanKehamilan>> getCatatanKehamilan() async {
    String apiUrl = ApiUrl.listCatatanKehamilan; // Endpoint untuk mendapatkan daftar catatan kehamilan

    try {
      // Melakukan permintaan GET
      final response = await http.get(Uri.parse(apiUrl));

      // Cek apakah respons berhasil
      if (response.statusCode == 200) {
        var jsonObj = json.decode(response.body);
        List<dynamic> listCatatanKehamilan = (jsonObj as Map<String, dynamic>)['data'];
        
        // Parsing data ke dalam list CatatanKehamilan
        return listCatatanKehamilan.map((item) => CatatanKehamilan.fromJson(item)).toList();
      } else {
        // Tangani error berdasarkan status code
        var errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Failed to load catatan kehamilan');
      }
    } catch (e) {
      // Tangani error jaringan atau error parsing
      throw Exception('Failed to fetch catatan kehamilan: $e');
    }
  }

  // Menambahkan catatan kehamilan
  static Future<bool> addCatatanKehamilan({required CatatanKehamilan catatan}) async {
    String apiUrl = ApiUrl.createCatatanKehamilan; // Endpoint untuk menambahkan catatan kehamilan

    var body = json.encode({
      "patient_name": catatan.patientName,
      "gestational_week": catatan.gestationalWeek,
      "baby_weight": catatan.babyWeight
    }); // Encode to JSON

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json', // Set header content type
        },
        body: body, // Pass the encoded JSON string here
      );

      if (response.statusCode == 200) {
        var jsonObj = json.decode(response.body);
        return jsonObj['status']; // Mengembalikan status dari response
      } else {
        var errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Failed to add catatan kehamilan');
      }
    } catch (e) {
      throw Exception('Failed to add catatan kehamilan: $e');
    }
  }

  // Memperbarui catatan kehamilan
  static Future<bool> updateCatatanKehamilan({required CatatanKehamilan catatan}) async {
    String apiUrl = ApiUrl.updateCatatanKehamilan(catatan.id!); // Endpoint untuk memperbarui catatan

    var body = json.encode({
      "patient_name": catatan.patientName,
      "gestational_week": catatan.gestationalWeek,
      "baby_weight": catatan.babyWeight
    });

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        var jsonObj = json.decode(response.body);
        return jsonObj['status'];
      } else {
        var errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Failed to update catatan kehamilan');
      }
    } catch (e) {
      throw Exception('Failed to update catatan kehamilan: $e');
    }
  }

  // Menghapus catatan kehamilan
  static Future<bool> deleteCatatanKehamilan({required int id}) async {
    String apiUrl = ApiUrl.deleteCatatanKehamilan(id); // Endpoint untuk menghapus catatan

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var jsonObj = json.decode(response.body);
        return jsonObj['status']; // Mengembalikan status dari response
      } else {
        var errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Failed to delete catatan kehamilan');
      }
    } catch (e) {
      throw Exception('Failed to delete catatan kehamilan: $e');
    }
  }
}
