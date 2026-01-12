import 'package:flutter/material.dart';

/// Extension de tema para colores específicos del dominio Restaurante.
/// 
/// Permite definir colores semánticos que no encajan en el ColorScheme estándar
/// (ej. Nivel de picante, estados de pedidos de cocina).
class ColoresRestaurante extends ThemeExtension<ColoresRestaurante> {
  final Color? estadoPendiente;
  final Color? estadoCocinando;
  final Color? estadoListo;
  final Color? estadoEntregado;
  final Color? indicadorPicante;
  final Color? indicadorVegano;

  const ColoresRestaurante({
    this.estadoPendiente,
    this.estadoCocinando,
    this.estadoListo,
    this.estadoEntregado,
    this.indicadorPicante,
    this.indicadorVegano,
  });

  @override
  ColoresRestaurante copyWith({
    Color? estadoPendiente,
    Color? estadoCocinando,
    Color? estadoListo,
    Color? estadoEntregado,
    Color? indicadorPicante,
    Color? indicadorVegano,
  }) {
    return ColoresRestaurante(
      estadoPendiente: estadoPendiente ?? this.estadoPendiente,
      estadoCocinando: estadoCocinando ?? this.estadoCocinando,
      estadoListo: estadoListo ?? this.estadoListo,
      estadoEntregado: estadoEntregado ?? this.estadoEntregado,
      indicadorPicante: indicadorPicante ?? this.indicadorPicante,
      indicadorVegano: indicadorVegano ?? this.indicadorVegano,
    );
  }

  @override
  ColoresRestaurante lerp(ThemeExtension<ColoresRestaurante>? other, double t) {
    if (other is! ColoresRestaurante) {
      return this;
    }
    return ColoresRestaurante(
      estadoPendiente: Color.lerp(estadoPendiente, other.estadoPendiente, t),
      estadoCocinando: Color.lerp(estadoCocinando, other.estadoCocinando, t),
      estadoListo: Color.lerp(estadoListo, other.estadoListo, t),
      estadoEntregado: Color.lerp(estadoEntregado, other.estadoEntregado, t),
      indicadorPicante: Color.lerp(indicadorPicante, other.indicadorPicante, t),
      indicadorVegano: Color.lerp(indicadorVegano, other.indicadorVegano, t),
    );
  }
}
