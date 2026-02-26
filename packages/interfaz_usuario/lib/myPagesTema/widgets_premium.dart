import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'a_tema.dart';

// =============================================================================
// 1. GRADIENTE BUTTON (Reactivando colores dinámicos)
// =============================================================================
class BotonGradiente extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final double width;
  final double height;
  final Gradient? gradient;

  const BotonGradiente({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 54,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    // Escucha el color primario del tema dinámico actual
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    // Genera un gradiente suave basado en el primary del Theme (si no mandan uno fijo)
    final activeGradient = gradient ?? LinearGradient(
      colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    
    final isEnabled = onPressed != null && !isLoading;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: isEnabled ? activeGradient : null,
        color: isEnabled ? null : theme.disabledColor,
        borderRadius: BorderRadius.circular(AppTokens.radioMedio),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(AppTokens.radioMedio),
          splashColor: Colors.white.withValues(alpha: 0.2),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: Colors.white, size: 22),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            fontFamily: 'Inter'
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// 2. CAMPO DE TEXTO (Adaptable a Modos Claro/Oscuro dinámicos)
// =============================================================================
class CampoTextoPersonalizado extends StatefulWidget {
  final String label;
  final IconData prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final bool readOnly;
  final VoidCallback? onTap;
  final IconData? suffixIcon;
  final int maxLines;
  final String? hint;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;

  const CampoTextoPersonalizado({
    super.key,
    required this.label,
    required this.prefixIcon,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.textInputAction,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.maxLines = 1,
    this.hint,
    this.inputFormatters,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChanged,
  });

  @override
  State<CampoTextoPersonalizado> createState() => _CampoTextoPersonalizadoState();
}

class _CampoTextoPersonalizadoState extends State<CampoTextoPersonalizado> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: widget.isPassword ? _obscureText : false,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      onChanged: widget.onChanged,
      validator: widget.validator,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      maxLines: widget.maxLines,
      style: theme.textTheme.bodyLarge,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: Icon(
            widget.prefixIcon,
            color: isDark ? Colors.white70 : theme.primaryColor.withValues(alpha: 0.6)
        ),
        alignLabelWithHint: widget.maxLines > 1,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: theme.hintColor,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : (widget.suffixIcon != null ? Icon(widget.suffixIcon, color: theme.hintColor) : null),
      ),
    );
  }
}

// =============================================================================
// 3. TARJETA PREMIUM (Reacciona al color primario y superficie de a_tema.dart)
// =============================================================================
class TarjetaPremium extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final bool esBordeBrillante;

  const TarjetaPremium({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.esBordeBrillante = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = backgroundColor ?? theme.cardTheme.color;

    final borderColor = esBordeBrillante
        ? theme.primaryColor.withValues(alpha: 0.5) // Borde primario dinámico
        : (isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05));

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppTokens.radioGrande),
        border: Border.all(
          color: borderColor,
          width: esBordeBrillante ? 1.5 : 1,
        ),
        boxShadow: isDark ? [] : AppTokens.sombraSuave,
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(AppTokens.radioGrande),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: theme.primaryColor.withValues(alpha: 0.1),
          highlightColor: theme.primaryColor.withValues(alpha: 0.05),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppTokens.paddingEstandar),
            child: child,
          ),
        ),
      ),
    );
  }
}
