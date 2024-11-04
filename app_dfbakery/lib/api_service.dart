import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://10.0.2.2:3000/users'; //sesuaikan dengan ip device kita (ip ini untuk emulator android)

  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> users = jsonDecode(response.body);
        for (var user in users) {
          if (user is Map<String, dynamic> &&
              user['email'] == email &&
              user['password'] == password) {
            print('Login berhasil untuk email: $email');
            return user;
          }
        }
        print('Login gagal, email atau password salah: $email');
      } else {
        print('Error status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saat login: $e');
    }
    return null;
  }

  // Fungsi untuk registrasi
  static Future<String?> register(
      String name, String email, String password, String phone) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
        }),
      );

      print('Respons setelah registrasi: ${response.body}');

      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        if (responseData is Map<String, dynamic>) {
          return responseData['id'];
        }
      } else {
        print('Registrasi gagal dengan status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saat registrasi: $e');
    }
    return null;
  }

  // Fungsi untuk memverifikasi email
  static Future<bool> verifyEmail(String email) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?email=$email'));

      if (response.statusCode == 200) {
        var decodedBody = jsonDecode(response.body);
        if (decodedBody is List<dynamic>) {
          return decodedBody.isNotEmpty;
        } else {
          print('Format respons tidak valid');
        }
      } else {
        print('Error status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saat memverifikasi email: $e');
    }
    return false;
  }

  // Fungsi untuk mengganti password
  static Future<bool> changePassword(String email, String newPassword) async {
    try {
      final userResponse = await http.get(Uri.parse('$baseUrl?email=$email'));

      if (userResponse.statusCode == 200) {
        var users = jsonDecode(userResponse.body);
        if (users is List<dynamic> &&
            users.isNotEmpty &&
            users[0] is Map<String, dynamic>) {
          String userId = users[0]['id'];

          final response = await http.patch(
            Uri.parse('$baseUrl/$userId'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'password': newPassword}),
          );

          if (response.statusCode == 200) {
            return true;
          } else {
            print('Gagal mengubah password: ${response.body}');
          }
        } else {
          print('Pengguna tidak ditemukan dengan email: $email');
        }
      } else {
        print('Error status code: ${userResponse.statusCode}');
      }
    } catch (e) {
      print('Error saat mengganti password: $e');
    }
    return false;
  }

  // Fungsi untuk mengirim email reset password
  static Future<bool> sendResetPasswordEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error saat mengirim email reset password: $e');
    }
    return false;
  }
}
