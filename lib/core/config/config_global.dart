/// Configuración Global de la Aplicación.
/// 
/// Aquí se definen constantes que se usan en todo el proyecto, como la versión,
/// nombre de la app, y configuraciones técnicas (timeouts).
/// 
/// NOTA DE SEGURIDAD:
/// NUNCA guardes contraseñas, claves privadas o datos sensibles aquí.
/// Esos datos deben ir en variables de entorno (.env) o venir de una base de datos segura.
class ConfigGlobal {
  // --- Metadatos de la App ---
  static const String nombreApp = 'Sistema de Restaurante 2.0';
  static const String version = '1.0.0+1'; // Major.Minor.Patch + BuildNumber
  
  // --- Configuración Técnica ---
  static const int timeoutConexion = 5000; // Milisegundos (5 seg)
  static const int timeoutRecepcion = 3000; // Milisegundos (3 seg)
  
  // --- Valores por Defecto ---
  static const String moneda = 'S/'; // Soles
  static const double impuestoDefecto = 0.18; // 18% IGV (Ejemplo)
  
  // --- Credenciales Base (SOLO PARA DESARROLLO/DEFAULT) ---
  // En producción, esto debe venir del Backend o Base de Datos.
  static const String adminEmailDefault = 'admin@restaurante.com';
  // static const String password = '...'; // ¡NO HACER ESTO! 
}
