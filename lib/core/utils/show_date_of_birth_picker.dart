import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';

/// Shows [DateOfBirthConstraints]-compatible date selection: Material calendar
/// on Android (and non‑iOS), [CupertinoDatePicker] sheet on iOS.
Future<DateTime?> showDateOfBirthPicker(
  BuildContext context, {
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  final initial = DateTime(
    initialDate.year,
    initialDate.month,
    initialDate.day,
  );
  final first = DateTime(firstDate.year, firstDate.month, firstDate.day);
  final last = DateTime(lastDate.year, lastDate.month, lastDate.day);

  if (!Platform.isIOS) {
    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    );
  }

  final clampedInitial = initial.isBefore(first)
      ? first
      : (initial.isAfter(last) ? last : initial);

  return showCupertinoModalPopup<DateTime>(
    context: context,
    builder: (modalContext) {
      var picked = clampedInitial;
      final bottom = MediaQuery.paddingOf(modalContext).bottom;

      return Container(
        color: CupertinoColors.systemBackground.resolveFrom(modalContext),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      onPressed: () => Navigator.of(modalContext).pop(),
                      child: Text(modalContext.l10n.cancel),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      onPressed: () => Navigator.of(modalContext).pop(
                        DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                        ),
                      ),
                      child: Text(modalContext.l10n.dateOfBirthPickerDone),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 216,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: clampedInitial,
                  minimumDate: first,
                  maximumDate: last,
                  onDateTimeChanged: (DateTime value) {
                    picked = DateTime(
                      value.year,
                      value.month,
                      value.day,
                    );
                  },
                ),
              ),
              SizedBox(height: bottom),
            ],
          ),
        ),
      );
    },
  );
}
