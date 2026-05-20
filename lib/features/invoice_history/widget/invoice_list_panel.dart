import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pilates_app/config/theme/app_spacing.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/invoice_history/cubit/invoice_history_cubit.dart';
import 'package:pilates_app/features/invoice_history/cubit/invoice_history_state.dart';
import 'package:pilates_app/features/invoice_history/data/models/invoice_resource.dart';
import 'package:pilates_app/features/invoice_history/widget/empty_data_view.dart';
import 'package:pilates_app/features/invoice_history/widget/invoice_history_card.dart';
import 'package:pilates_app/widgets/app_loading_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class InvoiceListPanel extends StatelessWidget {
  const InvoiceListPanel({super.key});

  static _InvoiceEmptyState _emptyStateForCategory(
    BuildContext context,
    InvoiceCategory category,
    bool isDark,
  ) {
    final l10n = context.l10n;
    switch (category) {
      case InvoiceCategory.all:
        return _InvoiceEmptyState(
          title: l10n.noInvoicesYet,
          subtitle: l10n.invoiceHistorySubtitle,
          assetPath: isDark
              ? 'assets/images/svg/invoice_history/ic_dark_no_invoice.svg'
              : 'assets/images/svg/invoice_history/ic_no_invoice.svg',
        );
      case InvoiceCategory.subscriptions:
        return _InvoiceEmptyState(
          title: l10n.noSubscriptionsYet,
          subtitle: l10n.noSubscriptionsSubtitle,
          assetPath: isDark
              ? 'assets/images/svg/invoice_history/ic_dark_no_subscription.svg'
              : 'assets/images/svg/invoice_history/ic_no_subscription.svg',
        );
      case InvoiceCategory.classes:
        return _InvoiceEmptyState(
          title: l10n.noClassesYet,
          subtitle: l10n.classInvoiceSubtitle,
          assetPath: isDark
              ? 'assets/images/svg/invoice_history/ic_dark_no_class.svg'
              : 'assets/images/svg/invoice_history/ic_no_class.svg',
        );
      case InvoiceCategory.refunds:
        return _InvoiceEmptyState(
          title: l10n.noRefundsYet,
          subtitle: l10n.noRefundsSubtitle,
          assetPath: isDark
              ? 'assets/images/svg/invoice_history/ic_dark_no_refund.svg'
              : 'assets/images/svg/invoice_history/ic_no_refund.svg',
        );
    }
  }

  static void _showUnavailable(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.invoicePdfNotAvailable)),
    );
  }

  static Future<Uri?> _resolveUri(BuildContext context, String? url) async {
    if (url == null || url.trim().isEmpty) {
      _showUnavailable(context);
      return null;
    }
    final uri = Uri.tryParse(url.trim());
    if (uri == null) {
      _showUnavailable(context);
      return null;
    }
    return uri;
  }

  static Future<bool> _launchWithFallback(
    Uri uri, {
    required List<LaunchMode> modes,
  }) async {
    for (final mode in modes) {
      try {
        if (await launchUrl(uri, mode: mode)) {
          return true;
        }
      } catch (_) {
        // Try next mode (e.g. in-app not supported on this OS version).
        continue;
      }
    }
    return false;
  }

  /// View: prefer in-app browser, then system default, then external browser.
  static Future<void> openInvoiceView(BuildContext context, String? url) async {
    final uri = await _resolveUri(context, url);
    if (uri == null || !context.mounted) return;
    final ok = await _launchWithFallback(
      uri,
      modes: const [
        LaunchMode.inAppBrowserView,
        LaunchMode.platformDefault,
        LaunchMode.externalApplication,
      ],
    );
    if (context.mounted && !ok) {
      _showUnavailable(context);
    }
  }

  /// Download: system browser / viewer so the user can save or share the file.
  static Future<void> openInvoiceDownload(
    BuildContext context,
    String? url,
  ) async {
    final uri = await _resolveUri(context, url);
    if (uri == null || !context.mounted) return;
    final ok = await _launchWithFallback(
      uri,
      modes: const [LaunchMode.externalApplication, LaunchMode.platformDefault],
    );
    if (context.mounted && !ok) {
      _showUnavailable(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<InvoiceHistoryCubit, InvoiceHistoryState>(
      builder: (context, state) {
        if (state.loadStatus == InvoicesLoadStatus.loading &&
            state.invoices.isEmpty) {
          return const AppLoadingIndicator();
        }

        if (state.loadStatus == InvoicesLoadStatus.failure &&
            state.invoices.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                state.errorMessage ?? context.l10n.branchesCouldNotLoad,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (state.invoices.isEmpty) {
          final empty = _emptyStateForCategory(
            context,
            state.selectedInvoiceCategory,
            isDark,
          );
          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: EmptyDataView(
                title: empty.title,
                subTitle: empty.subtitle,
                image: empty.assetPath,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<InvoiceHistoryCubit>().refresh(),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            itemCount: state.invoices.length,
            itemBuilder: (context, index) {
              final inv = state.invoices[index];
              final monthLabel = DateFormat.yMMMM(
                languageCode,
              ).format(inv.issuedAt.toLocal());
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == state.invoices.length - 1
                      ? 0
                      : AppSpacing.md,
                ),
                child: InvoiceHistoryCard(
                  month: monthLabel,
                  title: inv.title,
                  subTitle: context.l10n.invoiceNumber(inv.invoiceNumber),
                  date: DateFormat.yMMMd(
                    languageCode,
                  ).format(inv.issuedAt.toLocal()),
                  amountValue: inv.amount,
                  currencyCode: inv.currency,
                  refund: inv.isRefund,
                  onView: () => openInvoiceView(context, inv.pdfUrl),
                  onDownload: () => openInvoiceDownload(context, inv.pdfUrl),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _InvoiceEmptyState {
  const _InvoiceEmptyState({
    required this.title,
    required this.subtitle,
    required this.assetPath,
  });

  final String title;
  final String subtitle;
  final String assetPath;
}
