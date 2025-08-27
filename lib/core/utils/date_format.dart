import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:message_box/l10n/app_localizations.dart';

String formatRelative(DateTime dateTime, BuildContext context) {
  final now = DateTime.now().toUtc();
  final diff = now.difference(dateTime.toUtc());
  if (diff.inSeconds < 60) return AppLocalizations.of(context)!.justNow;
  if (diff.inMinutes < 60)
    return '${diff.inMinutes} ${AppLocalizations.of(context)!.minutesAgo}';
  if (diff.inHours < 24)
    return '${diff.inHours} ${AppLocalizations.of(context)!.hoursAgo}';
  return DateFormat('yyyy-MM-dd HH:mm').format(dateTime.toLocal());
}
