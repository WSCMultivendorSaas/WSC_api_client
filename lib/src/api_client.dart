import 'package:dio/dio.dart';

class ApiClient {
  late String baseUrl;
  late Dio dio;

  ApiClient._({required this.baseUrl}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        validateStatus: (_) => true,
        followRedirects: false,
        contentType: 'application/json',
        headers: {'accept': 'application/json'},
      ),
    );
  }

  static ApiClient? _instance;

  static ApiClient get instance {
    assert(_instance != null, 'Api client must be initialized first.');
    return _instance!;
  }

  static void initialize({required String baseUrl}) {
    _instance = ApiClient._(baseUrl: baseUrl);
  }

  Response _validate(Response res) {
    // if (res.statusCode == 500) {
    //   throw 'Server Error';
    // } else if (res.statusCode == 404) {
    //   throw 'Not Found';
    // } else if (res.statusCode == 422) {
    //   throw 'Validation Error';
    // } else if (res.data == null) {
    //   throw 'api returned null response';
    // }
    return res;
  }

  /// sends a [GET] request to the given [url]
  Future<Response> get(
    String url, {
    Map<String, dynamic> headers = const {},
    Map<String, dynamic> query = const {},
    bool attachToken = false,
    bool wantBytes = false,
  }) async {
    final res = await dio.get(
      url,
      queryParameters: {...query},
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-type': 'application/json',
          ...headers,
        },
        responseType: wantBytes ? ResponseType.bytes : null,
      ),
    );
    return _validate(res);
  }

  Future<Response> post(
    String path, {
    Map<String, dynamic> body = const {},
    Map<String, dynamic> headers = const {},
    Map<String, dynamic> query = const {},
    String? contentType = 'application/json',
    bool isFormData = false,
    bool attachToken = false,
  }) async {
    final res = await dio.post(
      path,
      data: isFormData ? FormData.fromMap(body) : body,
      queryParameters: query,
      options: Options(
        headers: {
          ...headers,
        },
        contentType: contentType,
      ),
    );
    return _validate(res);
  }

  Future<Response> put(
    String path, {
    dynamic body = const {},
    bool attachToken = true,
    Map<String, dynamic> headers = const {},
    Map<String, dynamic> query = const {},
  }) async {
    final res = await dio.put(
      path,
      data: body,
      queryParameters: {...query},
      options: Options(
        headers: {
          ...headers,
        },
      ),
    );
    return _validate(res);
  }

  Future<Response> delete(
    String path, {
    dynamic body = const {},
    Map<String, dynamic> headers = const {},
    Map<String, dynamic> query = const {},
  }) async {
    final res = await dio.delete(
      path,
      data: body,
      queryParameters: {...query},
      options: Options(
        headers: {
          ...headers,
        },
      ),
    );
    return _validate(res);
  }
}
