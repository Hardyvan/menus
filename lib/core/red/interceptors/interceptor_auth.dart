import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

/// Interceptor para manejar tokens de autenticación automáticamente.
class AuthInterceptor extends Interceptor {
  // TODO: Inyectar SecureStorage o similar para obtener el token real.
  // final SecureStorage _storage; 
  
  AuthInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Simulación: Obtener token guardado
    const token = 'MOCK_TOKEN_12345'; // Esto vendría de SecureStorage
    
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    debugPrint('--> ${options.method} ${options.uri}');
    
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('<-- ${response.statusCode} ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri}');
    
    // Aquí podríamos detectar 401 y cerrar sesión globalmente
    // if (err.response?.statusCode == 401) { ... logout ... }

    super.onError(err, handler);
  }
}
