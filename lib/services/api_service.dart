import 'package:quickpay/constants/endpoints.dart';
import 'package:quickpay/data/models.dart';
import 'package:quickpay/services/network.dart';

class ApiService {
  static Future<Account> getAccount() async {
    final response = await BaseApi().get(ApiEndpoints.account);
    final accountResponse = ApiResponse.fromJson(
      response.data,
      (json) => Account.fromJson(json as Map<String, dynamic>),
    );    
    return accountResponse.data;
  }
}
