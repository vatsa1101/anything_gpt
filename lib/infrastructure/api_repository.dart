import 'package:dio/dio.dart';
import '../domain/logger.dart';

class ApiRepository {
  final String url;
  late BaseOptions options;
  late Dio dio;
  ApiRepository({
    required this.url,
  }) {
    options = BaseOptions(
      // receiveTimeout: const Duration(seconds: 20),
      // connectTimeout: const Duration(seconds: 20),
      baseUrl: url,
      receiveDataWhenStatusError: true,
      contentType: "application/json",
      headers: {"accept-version": '1.0.0'},
    );
    dio = Dio(options);
  }

  Future getResponse(String prompt) async {
    try {
      logger.i("Making request to get response");
      final response = await dio.post(
        "$url/process_text",
        queryParameters: {
          "text": prompt,
        },
      );
      logger.i(response.data);
      return response.data;
    } on DioError {
      rethrow;
    }
  }
}
