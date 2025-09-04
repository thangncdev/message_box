import 'package:flutter/material.dart';
import 'package:message_box/core/theme.dart';

/// Base screen widget that provides consistent theming across all screens
/// This ensures all screens use the same theme structure and styling
class BaseScreen extends StatelessWidget {
  /// The main content of the screen
  final Widget child;

  /// Optional app bar
  final PreferredSizeWidget? appBar;

  /// Optional floating action button
  final Widget? floatingActionButton;

  /// Optional bottom navigation bar
  final Widget? bottomNavigationBar;

  /// Whether to extend body behind app bar
  final bool extendBodyBehindAppBar;

  /// Whether to extend body
  final bool extendBody;

  /// Custom background decoration (if null, uses theme gradient)
  final Decoration? backgroundDecoration;

  /// Padding for the content
  final EdgeInsetsGeometry? padding;

  /// Whether to wrap content in SafeArea
  final bool useSafeArea;

  /// Whether to show gradient background
  final bool showGradientBackground;

  const BaseScreen({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
    this.backgroundDecoration,
    this.padding,
    this.useSafeArea = true,
    this.showGradientBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<PastelPalette>()!;

    // Default gradient background decoration
    final defaultDecoration = showGradientBackground
        ? BoxDecoration(
            gradient: LinearGradient(
              colors: [palette.gradientStart, palette.gradientStart],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          )
        : null;

    final decoration = backgroundDecoration ?? defaultDecoration;

    return Scaffold(
      appBar: appBar,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: decoration != null
          ? Container(decoration: decoration, child: _buildContent(context))
          : _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    Widget content = child;

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    return content;
  }
}

/// Base screen with scrollable content
class BaseScrollableScreen extends StatelessWidget {
  /// The main content of the screen
  final List<Widget> children;

  /// Optional app bar
  final PreferredSizeWidget? appBar;

  /// Optional floating action button
  final Widget? floatingActionButton;

  /// Optional bottom navigation bar
  final Widget? bottomNavigationBar;

  /// Whether to extend body behind app bar
  final bool extendBodyBehindAppBar;

  /// Whether to extend body
  final bool extendBody;

  /// Custom background decoration (if null, uses theme gradient)
  final Decoration? backgroundDecoration;

  /// Padding for the content
  final EdgeInsetsGeometry? padding;

  /// Whether to wrap content in SafeArea
  final bool useSafeArea;

  /// Whether to show gradient background
  final bool showGradientBackground;

  /// Scroll controller for the list view
  final ScrollController? controller;

  /// Whether to show refresh indicator
  final bool showRefreshIndicator;

  /// Refresh callback
  final Future<void> Function()? onRefresh;

  const BaseScrollableScreen({
    super.key,
    required this.children,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
    this.backgroundDecoration,
    this.padding,
    this.useSafeArea = true,
    this.showGradientBackground = true,
    this.controller,
    this.showRefreshIndicator = false,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<PastelPalette>()!;

    // Default gradient background decoration
    final defaultDecoration = showGradientBackground
        ? BoxDecoration(
            gradient: LinearGradient(
              colors: [palette.gradientStart, palette.gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          )
        : null;

    final decoration = backgroundDecoration ?? defaultDecoration;

    Widget listView = ListView(
      controller: controller,
      padding: padding,
      children: children,
    );

    if (showRefreshIndicator && onRefresh != null) {
      listView = RefreshIndicator(onRefresh: onRefresh!, child: listView);
    }

    return Scaffold(
      appBar: appBar,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: decoration != null
          ? Container(
              decoration: decoration,
              child: useSafeArea ? SafeArea(child: listView) : listView,
            )
          : useSafeArea
          ? SafeArea(child: listView)
          : listView,
    );
  }
}
