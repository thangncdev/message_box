import 'package:flutter/material.dart';
import 'package:message_box/core/theme.dart';

/// Base AppBar widget that provides consistent theming across all screens
/// This ensures all AppBars use the same theme structure and styling
class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title of the AppBar
  final String title;

  /// Optional leading widget (usually back button)
  final Widget? leading;

  /// List of action widgets
  final List<Widget>? actions;

  /// Whether to automatically show back button
  final bool automaticallyImplyLeading;

  /// Custom title widget (overrides title if provided)
  final Widget? titleWidget;

  /// Background color (if null, uses theme)
  final Color? backgroundColor;

  /// Foreground color (if null, uses theme)
  final Color? foregroundColor;

  /// Elevation of the AppBar
  final double? elevation;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom bottom widget
  final PreferredSizeWidget? bottom;

  /// Whether to show gradient background
  final bool showGradientBackground;

  const BaseAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.titleWidget,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.centerTitle = true,
    this.bottom,
    this.showGradientBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<PastelPalette>()!;
    final theme = Theme.of(context);

    // Default colors from theme
    final defaultBackgroundColor = showGradientBackground
        ? Colors.transparent
        : theme.scaffoldBackgroundColor;
    final defaultForegroundColor =
        theme.appBarTheme.foregroundColor ?? const Color(0xFF3E3A52);

    return AppBar(
      title:
          titleWidget ??
          Text(
            title,
            style: TextStyle(
              color: foregroundColor ?? defaultForegroundColor,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
      leading: leading,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor ?? defaultBackgroundColor,
      foregroundColor: foregroundColor ?? defaultForegroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      bottom: bottom,
      flexibleSpace: showGradientBackground
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [palette.gradientStart, palette.gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            )
          : null,
      shape: showGradientBackground
          ? const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

/// Specialized AppBar for screens with gradient background
class GradientAppBar extends BaseAppBar {
  const GradientAppBar({
    super.key,
    required super.title,
    super.leading,
    super.actions,
    super.automaticallyImplyLeading = true,
    super.titleWidget,
    super.elevation = 0,
    super.centerTitle = true,
    super.bottom,
  }) : super(showGradientBackground: true, backgroundColor: Colors.transparent);
}

/// AppBar with custom styling for different screen types
class StyledAppBar extends BaseAppBar {
  final AppBarStyle style;

  const StyledAppBar({
    super.key,
    required super.title,
    super.leading,
    super.actions,
    super.automaticallyImplyLeading = true,
    super.titleWidget,
    super.elevation,
    super.centerTitle = true,
    super.bottom,
    this.style = AppBarStyle.standard,
  });

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<PastelPalette>()!;

    switch (style) {
      case AppBarStyle.standard:
        return super.build(context);

      case AppBarStyle.gradient:
        return GradientAppBar(
          title: title,
          leading: leading,
          actions: actions,
          automaticallyImplyLeading: automaticallyImplyLeading,
          titleWidget: titleWidget,
          elevation: elevation,
          centerTitle: centerTitle,
          bottom: bottom,
        );

      case AppBarStyle.card:
        return BaseAppBar(
          title: title,
          leading: leading,
          actions: actions,
          automaticallyImplyLeading: automaticallyImplyLeading,
          titleWidget: titleWidget,
          backgroundColor: palette.cardA,
          foregroundColor: palette.onCard,
          elevation: 2,
          centerTitle: centerTitle,
          bottom: bottom,
        );

      case AppBarStyle.transparent:
        return BaseAppBar(
          title: title,
          leading: leading,
          actions: actions,
          automaticallyImplyLeading: automaticallyImplyLeading,
          titleWidget: titleWidget,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: centerTitle,
          bottom: bottom,
        );
    }
  }
}

/// AppBar style enumeration
enum AppBarStyle { standard, gradient, card, transparent }
