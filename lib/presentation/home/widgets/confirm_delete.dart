import 'package:flutter/material.dart';
import 'package:message_box/l10n/app_localizations.dart';

Future<bool> showConfirmDeleteDialog(BuildContext context) async {
  final res = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.delete),
      content: Text(AppLocalizations.of(context)!.confirmDelete),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(AppLocalizations.of(context)!.delete),
        ),
      ],
    ),
  );
  return res ?? false;
}
