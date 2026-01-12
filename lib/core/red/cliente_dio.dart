import 'package:dio/dio.dart';
import 'interceptors/interceptor_auth.dart';
import 'exceptions/excepciones_red.dart';

/// 🌐 CLIENTE HTTP (El Mensajero)
///
/// Esta clase encapsula "Dio", que es como un navegador web invisible.
/// Su trabajo es enviar cartas (Requests) al servidor y recibir respuestas.
class DioClient {
  late final Dio _dio;

  // Base URL: La dirección de la "oficina central" del backend.
  static const String _baseUrl = 'https://api.mirestaurante.com/v1';

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        // ⏱️ TIMEOUTS: Importantes para no dejar la app colgada si el internet es lento.
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
      ),
    );

    // 🕵️ INTERCEPTORES: Son como "espías" o "middleware".
    // Pueden leer/modificar cada carta antes de que salga o cuando llega.
    // Aquí agregamos uno para inyectar el Token de seguridad automáticamente.
    _dio.interceptors.addAll([
      AuthInterceptor(),
      // LogInterceptor(requestBody: true, responseBody: true), // Útil para debug
    ]);
  }

  Dio get dio => _dio;

  // --- Métodos Helper para evitar usar dio directamente en repositorios ---

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Future<dynamic> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Future<dynamic> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }

  Future<dynamic> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response.data;
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
}
