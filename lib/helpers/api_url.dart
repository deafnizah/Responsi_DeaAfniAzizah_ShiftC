class ApiUrl {
  static const String baseUrl = 'http://responsi.webwizards.my.id/api'; // Base URL untuk API
  static const String registrasi = baseUrl + '/registrasi'; // Endpoint untuk registrasi
  static const String login = baseUrl + '/login'; // Endpoint untuk login
  static const String listCatatanKehamilan = baseUrl + '/kesehatan/catatan_kehamilan'; // Endpoint untuk daftar catatan kehamilan
  static const String createCatatanKehamilan = baseUrl + '/kesehatan/catatan_kehamilan'; // Endpoint untuk menambahkan catatan kehamilan

  static String updateCatatanKehamilan(int id) {
    return '$baseUrl/kesehatan/catatan_kehamilan/$id/update'; // Endpoint untuk memperbarui catatan kehamilan
  }

  static String showCatatanKehamilan(int id) {
    return '$baseUrl/kesehatan/catatan_kehamilan/$id'; // Endpoint untuk menampilkan catatan kehamilan
  }

  static String deleteCatatanKehamilan(int id) {
    return '$baseUrl/kesehatan/catatan_kehamilan/$id/delete'; // Endpoint untuk menghapus catatan kehamilan
  }
}
