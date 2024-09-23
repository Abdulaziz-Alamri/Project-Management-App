import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_management_app/networking/constants_api.dart';

mixin AdminApi on ConstantsApi {


  changeRole({
    required String userId,
    required String role,
  }) async {
    try {
      await dio.put(

        baseUrl + updateProfileEndpoint,
        data: {"id_user": userId, "role": role},
        options: Options(
          headers: {
            'Authorization': 'Bearer ${dotenv.env['admin_token']}',
          },
        ),
      );
    } on DioException catch (error) {
      throw FormatException(error.response?.data["data"]);
    } catch (error) {
      throw const FormatException("Error occurred while changing role");
    }
  }
}
