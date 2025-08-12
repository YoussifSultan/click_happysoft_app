import 'package:click_happysoft_app/login_page/classes/salesman.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SalesmanSqlManager {
  static Future<Salesman?> checkLogin(String email, String password) async {
    final url = Uri.parse('https://restapi-production-e4e5.up.railway.app/get');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'aP_cPLGZW69DTVH96mvDL1qJ5f2PfPY9SlpWox7rkCw'
      },
      body: jsonEncode({
        'query':
            '''Select * from railway.salesman where email = '$email' and salesman.password ='$password\'''',
      }),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      if (data.isEmpty) {
        return null; // No salesman found with the given credentials
      }

      return Salesman.fromJson(data.first);
    } else {
      return Future.error('Failed to load data');
    }
  }
}
