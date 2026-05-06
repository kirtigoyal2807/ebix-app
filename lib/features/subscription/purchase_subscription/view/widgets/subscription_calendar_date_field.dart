import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pilates_app/config/theme/app_colors.dart';
import 'package:pilates_app/config/theme/app_radius.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/config/theme/app_text_styles.dart';
import 'package:pilates_app/widgets/app_text.dart';

/// Same interaction as [PauseSubscriptionView] date rows: tap opens
/// [showDatePicker], formatted date passed to [onDateSelected].
class SubscriptionCalendarDateField extends StatelessWidget {
  const SubscriptionCalendarDateField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.onDateSelected,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onDateSelected;

  static final DateFormat _displayFormat = DateFormat('dd-MM-yyyy');

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime initialDateFromText(String raw) {
    final t = raw.trim();
    if (t.isEmpty) {
      return _dateOnly(DateTime.now());
    }
    final iso = DateTime.tryParse(t);
    if (iso != null) {
      return _dateOnly(iso);
    }
    try {
      return _dateOnly(_displayFormat.parseStrict(t));
    } catch (_) {
      try {
        return _dateOnly(DateFormat('yyyy-MM-dd').parseStrict(t));
      } catch (_) {
        return _dateOnly(DateTime.now());
      }
    }
  }

  Future<void> _openPicker(BuildContext context) async {
    final initial = initialDateFromText(controller.text);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null || !context.mounted) {
      return;
    }
    final formatted = _displayFormat.format(_dateOnly(picked));
    controller.text = formatted;
    onDateSelected(formatted);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label, style: AppTextStyles.textFieldHeading),
        const SizedBox(height: AppSpacing.sm),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            final hasValue = value.text.trim().isNotEmpty;
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _openPicker(context),
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.homeBackground : Colors.white,
                    border: Border.all(
                      color: isDark ? AppColors.greyText : AppColors.buttonBorder,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppText(
                          hasValue ? value.text.trim() : hint,
                          style: (ctx) => AppTextStyles.textField(ctx).copyWith(
                            color: hasValue
                                ? (isDark
                                    ? AppColors.lightText
                                    : AppColors.darkText)
                                : AppColors.lightGrey,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.darkGreyText,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
