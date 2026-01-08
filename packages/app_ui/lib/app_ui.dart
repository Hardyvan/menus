/// Biblioteca principal del paquete `app_ui`.
///
/// Expone todos los widgets, temas y layout helpers que se pueden
/// reutilizar en esta y otras aplicaciones.
library app_ui;

// Exportamos los colores y tema
export 'src/theme/app_theme.dart';
export 'src/theme/app_colors.dart';
export 'src/theme/theme_config.dart';
export 'src/theme/app_palettes.dart';

// Exportamos widgets reutilizables
export 'src/widgets/app_button.dart';
export 'src/widgets/app_card.dart';
export 'src/widgets/app_text_input.dart';
export 'src/widgets/section_header.dart';
export 'src/widgets/category_avatar.dart';
export 'src/widgets/app_bottom_nav.dart';
export 'src/widgets/theme_selector_modal.dart';
export 'src/widgets/admin_drawer.dart';
export 'src/widgets/stat_card.dart';
export 'src/widgets/app_data_table.dart';
export 'src/widgets/stat_card.dart';
export 'src/widgets/app_data_table.dart';
export 'src/widgets/stat_card.dart';
export 'src/widgets/app_data_table.dart';

// Exportamos utilidades de diseño (Breakpoints)
export 'src/layout/breakpoints.dart';
export 'src/layout/responsive_layout_builder.dart';
