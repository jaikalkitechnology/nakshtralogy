import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/premium_ui.dart';
import '../../../shared/responsive.dart';
import '../invoice_files.dart';
import '../invoice_repository.dart';

typedef _InvoicesCubit = DataCubit<List<Invoice>>;

/// GST invoices for this user's paid consultations — list + PDF download.
class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<_InvoicesCubit>(
      create: (_) =>
          DataCubit(() => getIt<InvoiceRepository>().myInvoices())..load(),
      child: const _InvoicesView(),
    );
  }
}

class _InvoicesView extends StatelessWidget {
  const _InvoicesView();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.invoicesTitle)),
      body: SafeArea(
        child: CenteredMaxWidth(
          maxWidth: Responsive.readableMaxWidth,
          child: BlocBuilder<_InvoicesCubit, DataState<List<Invoice>>>(
            builder: (context, state) {
              final items = state.dataOrNull;
              return RefreshIndicator(
                onRefresh: () => context.read<_InvoicesCubit>().refresh(),
                color: AppColors.saffron,
                child: _body(context, l, state, items),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    AppLocalizations l,
    DataState<List<Invoice>> state,
    List<Invoice>? items,
  ) {
    if (items == null) {
      final err = state.errorMessage;
      if (err != null) {
        return _scrollMessage(
          icon: Icons.error_outline,
          tone: TileTone.saffron,
          text: err,
          color: AppColors.danger,
        );
      }
      return const Center(
        child: CircularProgressIndicator(color: AppColors.saffron),
      );
    }
    if (items.isEmpty) {
      return _scrollMessage(
        icon: Icons.receipt_long_outlined,
        tone: TileTone.gold,
        text: l.invoicesEmpty,
        color: AppColors.ivoryDim,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      itemCount: items.length + 1,
      itemBuilder: (_, i) {
        if (i == 0) {
          return SectionLabel(
            l.invoicesTitle,
            trailing: StatusChip('${items.length}', tone: ChipTone.warn),
          );
        }
        return _InvoiceRow(invoice: items[i - 1]);
      },
    );
  }

  Widget _scrollMessage({
    required IconData icon,
    required TileTone tone,
    required String text,
    required Color color,
  }) =>
      ListView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        children: [
          const SizedBox(height: 140),
          Center(child: IconTile(icon, tone: tone, size: 68)),
          const SizedBox(height: 18),
          Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyles.body(color: color),
            ),
          ),
        ],
      );
}

class _InvoiceRow extends StatefulWidget {
  const _InvoiceRow({required this.invoice});
  final Invoice invoice;

  @override
  State<_InvoiceRow> createState() => _InvoiceRowState();
}

class _InvoiceRowState extends State<_InvoiceRow> {
  bool _busy = false;

  String _dateLabel() {
    final d = widget.invoice.createdAt?.toLocal();
    if (d == null) return '';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}';
  }

  Future<void> _download() async {
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await InvoiceFiles.downloadAndOpen(widget.invoice.id);
    } catch (e) {
      if (!mounted) return;
      final msg = e is ApiException ? e.message : l.invoicesDownloadFailed;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final inv = widget.invoice;
    final date = _dateLabel();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const IconTile(Icons.receipt_long, tone: TileTone.gold),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        inv.invoiceNumber,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.mono(
                            size: 14, weight: FontWeight.w700),
                      ),
                      if (date.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          date,
                          style: AppTextStyles.label(
                              size: 11.5, color: AppColors.ivoryFaint),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${inv.totalAmount.toStringAsFixed(2)}',
                      style: AppTextStyles.mono(
                        size: 16,
                        weight: FontWeight.w800,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${l.invoicesTax} ₹${inv.taxAmount.toStringAsFixed(2)}',
                      style: AppTextStyles.mono(
                          size: 11, color: AppColors.ivoryFaint),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(height: 1, color: AppColors.borderSoft),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '${l.invoicesTotal} ₹${inv.totalAmount.toStringAsFixed(2)}',
                  style: AppTextStyles.label(
                      size: 12, color: AppColors.ivoryDim),
                ),
                const Spacer(),
                _busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.saffron),
                      )
                    : OutlinedButton.icon(
                        onPressed: _download,
                        icon: const Icon(Icons.download_rounded, size: 16),
                        label: Text(l.invoicesDownload),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.gold,
                          side: BorderSide(
                              color: AppColors.gold.withValues(alpha: 0.4)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
