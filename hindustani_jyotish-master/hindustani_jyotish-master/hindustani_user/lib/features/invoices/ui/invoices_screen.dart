import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
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
      if (err != null) return _scrollMessage(err, AppColors.danger);
      return const Center(
        child: CircularProgressIndicator(color: AppColors.saffron),
      );
    }
    if (items.isEmpty) {
      return _scrollMessage(l.invoicesEmpty, AppColors.ivoryFaint);
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: items.length,
      itemBuilder: (_, i) => _InvoiceRow(invoice: items[i]),
    );
  }

  Widget _scrollMessage(String text, Color color) => ListView(
        children: [
          const SizedBox(height: 160),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderMid),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.receipt_long, color: AppColors.saffron),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inv.invoiceNumber,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.mono(size: 13, weight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  '${l.invoicesTotal}: ₹${inv.totalAmount.toStringAsFixed(2)}'
                  '  ·  ${l.invoicesTax} ₹${inv.taxAmount.toStringAsFixed(2)}',
                  style:
                      AppTextStyles.mono(size: 12, color: AppColors.ivoryDim),
                ),
                if (_dateLabel().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    _dateLabel(),
                    style: AppTextStyles.label(
                        size: 11, color: AppColors.ivoryFaint),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          _busy
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.saffron),
                )
              : OutlinedButton.icon(
                  onPressed: _download,
                  icon: const Icon(Icons.download, size: 16),
                  label: Text(l.invoicesDownload),
                ),
        ],
      ),
    );
  }
}
