import 'package:provider/provider.dart';
import 'package:menus/funcionalidades/configuracion/presentation/proveedor_tema.dart';
import '../application/proveedor_autenticacion.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:interfaz_usuario/interfaz_usuario.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pantalla de Inicio de Sesión Profesional.
///
/// Incluye fondo dinámico, efecto glassmorphism, selector de temas en vivo
/// y función de "Recordar Credenciales".
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false; // Estado para "Guardar contraseña"

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  /// Carga credenciales guardadas si existen
  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    final savedPassword = prefs.getString('saved_password'); // ⚠️ Solo para MVP/Demo
    final remember = prefs.getBool('remember_me') ?? false;

    if (remember && savedEmail != null && mounted) {
      setState(() {
        _emailController.text = savedEmail;
        if (savedPassword != null) _passwordController.text = savedPassword;
        _rememberMe = true;
      });
    }
  }

  /// Guarda o limpia credenciales según el checkbox
  Future<void> _handleRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('saved_email', _emailController.text);
      await prefs.setString('saved_password', _passwordController.text); // ⚠️ Inseguro para Prod
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
      await prefs.remove('remember_me');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    if (!mounted) return;
    // Validamos el formulario antes de cualquier cosa
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Usamos el AuthProvider
      await context.read<AuthProvider>().login(
        _emailController.text, 
        _passwordController.text
      );

      // Guardar credenciales si "Recordar" está activo
      await _handleRememberMe();

      // 🛡️ SECURITY CHECK: ¿Sigue vivo el widget?
      if (!mounted) return;

      // Éxito: Navegamos al dashboard
      context.go('/');
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      // 🚨 MANEJO DE ERRORES ELEGANTE
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Text(cleanErrorMessage(e)),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Helper para limpiar el mensaje de error
  String cleanErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }
    return 'Ocurrió un error inesperado';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    // Detectamos si el teclado está abierto
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      // 🛡️ UX PREVENTIVA: Bloqueamos toda interacción mientras carga
      body: AbsorbPointer(
        absorbing: _isLoading,
        child: Stack(
          children: [
            // 1. Fondo Gradiente Animado
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.surface,
                    isDark
                        ? Colors.black
                        : colorScheme.primaryContainer.withValues(alpha: 0.3),
                    colorScheme.primary.withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),

            // 2. Contenido Principal
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo / Ícono Animado
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isKeyboardOpen ? 0.0 : 1.0,
                      child: Visibility(
                        visible: !isKeyboardOpen,
                        child: Hero(
                          tag: 'app_logo',
                          child: Semantics(
                            label: 'Logo de la aplicación',
                            image: true,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    colorScheme.primary.withValues(alpha: 0.1),
                                border: Border.all(
                                    color: colorScheme.primary
                                        .withValues(alpha: 0.2)),
                              ),
                              child: Icon(
                                Icons.restaurant_menu_rounded,
                                size: 64,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isKeyboardOpen ? 16 : 40),

                    // Tarjeta Glassmorphism
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 420),
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: (isDark ? Colors.black : Colors.white)
                                .withValues(alpha: isDark ? 0.6 : 0.7),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: (isDark ? Colors.white : Colors.white)
                                  .withValues(alpha: 0.2),
                              width: 0.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Bienvenido',
                                  style:
                                      theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Ingresa para gestionar tu restaurante',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 32),

                                // 📧 EMAIL / USUARIO INPUT
                                Semantics(
                                  label: 'Campo de usuario o correo',
                                  textField: true,
                                  child: AppTextInput(
                                    label: 'Usuario o Correo',
                                    controller: _emailController,
                                    keyboardType: TextInputType.text, // Permitir texto libre
                                    prefixIcon: Icons.person_outline,
                                    textInputAction: TextInputAction.next,
                                    autofillHints: const [AutofillHints.email, AutofillHints.username],
                                    // 🛡️ VALIDACIÓN RELAJADA
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Requerido';
                                      }
                                      // Permitimos 'admin' o emails válidos
                                      bool isSimpleUser = !v.contains('@');
                                      if (isSimpleUser) return null; // Es un usuario simple (admin, mozo)

                                      // Si tiene @, validamos formato email
                                      final emailRegex = RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                      if (!emailRegex.hasMatch(v)) {
                                        return 'Formato de correo inválido';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // 🔒 PASSWORD INPUT
                                Semantics(
                                  label: 'Campo de contraseña',
                                  textField: true,
                                  obscured: _obscurePassword,
                                  child: AppTextInput(
                                    label: 'Contraseña',
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    prefixIcon: Icons.lock_outline,
                                    textInputAction: TextInputAction.done,
                                    //onFieldSubmitted: (_) => _onLoginPressed(), // ENTER -> LOGIN
                                    autofillHints: const [
                                      AutofillHints.password
                                    ],
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.5),
                                      ),
                                      onPressed: () => setState(() =>
                                          _obscurePassword = !_obscurePassword),
                                    ),
                                    validator: (v) => v?.isEmpty ?? true
                                        ? 'Requerido'
                                        : null,
                                  ),
                                ),

                                // 💾 REMEMBER ME CHECKBOX
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _rememberMe,
                                      activeColor: theme.colorScheme.primary,
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () => setState(() => _rememberMe = !_rememberMe),
                                      child: Text(
                                        'Guardar contraseña',
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                // 🚀 ACTION BUTTON
                                Semantics(
                                  button: true,
                                  label: 'Iniciar sesión',
                                  enabled: !_isLoading,
                                  child: AppButton(
                                    text: 'INICIAR SESIÓN',
                                    onPressed:
                                        _isLoading ? null : _onLoginPressed,
                                    isLoading: _isLoading,
                                  ),
                                ),

                                const SizedBox(height: 16),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    '¿Olvidaste tu contraseña?',
                                    style: TextStyle(
                                        color: theme.colorScheme.primary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Botón Flotante
            Positioned(
              top: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Semantics(
                    button: true,
                    label: 'Cambiar tema de la aplicación',
                    child: FloatingActionButton.small(
                      heroTag: 'theme_switcher',
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.primary,
                      elevation: 2,
                      onPressed: () {
                        final themeProvider = context.read<ThemeProvider>();
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) => ThemeSelectorModal(
                            currentThemeId: themeProvider.currentConfig.id,
                            availableThemes: themeProvider.availablePalettes,
                            onThemeSelected: (config) {
                              themeProvider.setTheme(config);
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                      child: const Icon(Icons.palette_outlined),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
