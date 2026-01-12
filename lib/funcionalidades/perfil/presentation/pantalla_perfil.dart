import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:interfaz_usuario/interfaz_usuario.dart';
import '../../configuracion/presentation/proveedor_tema.dart';
import '../../autenticacion/application/proveedor_autenticacion.dart';
import '../../carrito/application/proveedor_carrito.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userTheme = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: theme.primaryColor),
            onPressed: () {
              // TODO: Settings
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 1. Avatar Section (Dynamic)
            if (user != null)
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.primaryContainer,
                            border: Border.all(color: theme.colorScheme.primary, width: 2),
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: 'https://ui-avatars.com/api/?name=${user.name.replaceAll(' ', '+')}&background=random&size=200',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const CircularProgressIndicator.adaptive(),
                              errorWidget: (context, url, error) => const Icon(Icons.person),
                            ),
                          ),
                        ),
                        // Botón de editar avatar (Visual)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: theme.colorScheme.surface, width: 2),
                            ),
                            child: Icon(Icons.edit, size: 16, color: theme.colorScheme.onPrimary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(user.name, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    Text(user.email, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 4),
                    Chip(
                      label: Text(user.roleName.toUpperCase(), style: const TextStyle(fontSize: 10)),
                       visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              )
            else
               const Center(child: CircularProgressIndicator()), // Debería tener usuario siempre si está logueado
            
            const SizedBox(height: 32),
            
            // 2. Theme Section (With Visual Feedback)
            SectionHeader(title: 'Apariencia', icon: Icons.palette),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                   _ProfileOption(
                     icon: Icons.color_lens,
                     iconColor: theme.colorScheme.secondary,
                     title: 'Tema de la Aplicación',
                     subtitle: userTheme.currentConfig.name,
                     trailing: Container(
                       width: 16, height: 16,
                       decoration: BoxDecoration(
                         color: theme.colorScheme.primary, // Color visual del tema
                         shape: BoxShape.circle,
                         border: Border.all(color: theme.dividerColor),
                       ),
                     ),
                     onTap: () => _showThemeSelector(context),
                   ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            
            // 3. Account Section (Secure Logout)
            SectionHeader(title: 'Cuenta', icon: Icons.person),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                   _ProfileOption(
                     icon: Icons.logout,
                     iconColor: Colors.red,
                     title: 'Cerrar Sesión',
                     subtitle: 'Salir de la aplicación',
                     textColor: Colors.red,
                     onTap: () => _handleLogout(context), // 🛡️ Secure Logout
                   ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            
            // 4. Version Check
            Text(
              'Versión 1.0.0 +2026',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final provider = context.read<ThemeProvider>();
        return ThemeSelectorModal(
          currentThemeId: provider.currentConfig.id,
          availableThemes: provider.availablePalettes,
          onThemeSelected: (config) {
            provider.setTheme(config);
            Navigator.pop(ctx);
          },
        );
      },
    );
  }

  // 🛡️ Implementación Segura de Logout
  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que deseas salir de la aplicación?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          AppButton(
            text: 'Salir',
            onPressed: () {
              // 1. Limpiar estado
              context.read<AuthProvider>().logout();
              context.read<CartProvider>().clearCart(); // Limpiar carrito también es buena práctica
              // 2. Navegar
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}

// 📦 Widget Reutilizable Interno
class _ProfileOption extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color? textColor;

  const _ProfileOption({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: textColor)),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) ...[
            trailing!,
            const SizedBox(width: 8),
          ],
          const Icon(Icons.chevron_right, size: 20),
        ],
      ),
      onTap: onTap,
    );
  }
}
