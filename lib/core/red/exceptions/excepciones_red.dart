import 'package:dio/dio.dart';

/// 🛡️ MANEJADOR DE ERRORES DE RED
///
/// Este archivo es el "Traductor Universal".
/// Convierte los errores feos y técnicos (Exception, 404, 500) en mensajes
/// amigables que el usuario pueda entender.
///
/// Ejemplo: Si el servidor dice "500 Internal Server Error",
/// nosotros le mostramos al usuario: "Lo sentimos, tenemos problemas técnicos".
class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException({required this.message, this.statusCode});

  /// 🏭 FÁBRICA DE ERRORES (Factory Method)
  /// Recibe un error crudo de Dio (la librería HTTP) y devuelve nuestro error limpio.
  static NetworkException fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return NetworkException(message: 'Solicitud cancelada');
      case DioExceptionType.connectionTimeout:
        return NetworkException(message: 'Tiempo de conexión agotado. Revisa tu internet.');
      case DioExceptionType.receiveTimeout:
        return NetworkException(message: 'El servidor tardó mucho en responder');
      case DioExceptionType.sendTimeout:
        return NetworkException(message: 'No pudimos enviar tu solicitud a tiempo');
      case DioExceptionType.badResponse:
        // Aquí manejamos cuando el servidor nos responde, pero con error (4xx, 5xx).
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        
        String msg = 'Error en el servidor ($statusCode)';
        
        // Trata de extraer mensaje del backend si existe
        if (data is Map && data['message'] != null) {
          msg = data['message'];
        } else if (data is String) {
          msg = data; // A veces el backend manda texto plano
        }
        
        if (statusCode == 401) return NetworkException(message: 'No autorizado', statusCode: 401);
        if (statusCode == 403) return NetworkException(message: 'Acceso denegado', statusCode: 403);
        if (statusCode == 404) return NetworkException(message: 'Recurso no encontrado', statusCode: 404);
        if (statusCode == 500) return NetworkException(message: 'Error interno del servidor', statusCode: 500);

        return NetworkException(message: msg, statusCode: statusCode);
      
      case DioExceptionType.connectionError:
        return NetworkException(message: 'Sin conexión a internet');
        
      default:
        return NetworkException(message: 'Ocurrió un error inesperado');
    }
  }

  @override
  String toString() => message;
}
