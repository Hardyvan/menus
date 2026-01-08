import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';


import 'package:go_router/go_router.dart';
// import '../../home/home_screen.dart'; // Ya no se necesita import directo

/// Pantalla de Inicio de Sesión.
///
/// Implementa un diseño responsivo:
/// - Móvil: Formulario ocupa toda la pantalla.
/// - Tablet/Desktop: Formulario centrado en una tarjeta flotante.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Dinámico
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ResponsiveLayoutBuilder(
            // Diseño Móvil: Directo en pantalla
            mobile: const _LoginForm(),
            
            // Diseño Tablet/Desktop: Dentro de una tarjeta con ancho limitado
            tablet: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: const AppCard(
                  padding: EdgeInsets.all(32),
                  child: _LoginForm(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Formulario interno de Login.
/// Separado para ser reutilizado en ambos layouts.
class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>(); // Key para el formulario and validations
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _onLoginPressed() async {
    if (!_formKey.currentState!.validate()) {
      return; // Detener si hay errores
    }

    setState(() => _isLoading = true);
    
    // Simular delay de red
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isLoading = false);
      
      // Simulación de credenciales correctas (para demo)
      if (_emailController.text == 'error@demo.com') {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error simulado: Credenciales inválidas')),
        );
        return;
      }

      // Navegar al Home usando GoRouter
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login bypassed for testing'),
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo o Título
          Text(
            'Bienvenido',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary, // Dinámico
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Ingresa a tu cuenta para ordenar',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7), // Dinámico
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Campos
          AppTextInput(
            label: 'Correo Electrónico',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu usuario/correo';
              }
              // Validation relaxed for testing
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextInput(
            label: 'Contraseña',
            controller: _passwordController,
            obscureText: _obscurePassword,
            prefixIcon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: AppColors.textSecondary,
              ),
              onPressed: () {
                setState(() {
                  // _obscurePassword = !_obscurePassword;
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu contraseña';
              }
              // Validation relaxed for testing
              return null;
            },
          ),
          
          const SizedBox(height: 32),

          // Botón
          AppButton(
            text: 'Entrar',
            onPressed: _onLoginPressed,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
