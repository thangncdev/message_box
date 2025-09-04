// Export providers from app_provider.dart and message_provider.dart
// These are the main providers that should be used throughout the app
export 'package:message_box/presentation/providers/app_provider.dart';
export 'package:message_box/presentation/providers/message_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_box/core/app_router.dart';

// Router provider
final routerProvider = appRouterProvider;

// Widget mode setting provider: 'random' | 'latest'
final widgetModeProvider = StateProvider<String>((ref) => 'latest');
