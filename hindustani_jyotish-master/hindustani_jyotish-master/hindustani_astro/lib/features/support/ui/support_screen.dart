import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/responsive.dart';
import '../support_repository.dart';

/// Help & Support: a localized FAQ tab (admin-managed, expandable) + a
/// "My tickets" tab (raise a ticket, open a thread to reply). Both feeds are
/// backed by [SupportRepository]; the ticket endpoints resolve the caller's
/// role from the token.
class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen>
    with SingleTickerProviderStateMixin {
  final _repo = getIt<SupportRepository>();
  late final TabController _tabs = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.supportTitle),
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: l.supportFaqTab),
            Tab(text: l.supportTicketsTab),
          ],
        ),
      ),
      body: SafeArea(
        child: CenteredMaxWidth(
          maxWidth: 720,
          child: TabBarView(
            controller: _tabs,
            children: [
              _FaqTab(repo: _repo),
              _TicketsTab(repo: _repo),
            ],
          ),
        ),
      ),
    );
  }
}

// ── FAQ tab ──────────────────────────────────────────────────────────
class _FaqTab extends StatefulWidget {
  const _FaqTab({required this.repo});
  final SupportRepository repo;

  @override
  State<_FaqTab> createState() => _FaqTabState();
}

class _FaqTabState extends State<_FaqTab> {
  late Future<List<FaqItem>> _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final lang = Localizations.localeOf(context).languageCode;
    _future = widget.repo.faqs(lang: lang);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return FutureBuilder<List<FaqItem>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.saffron),
          );
        }
        if (snap.hasError) {
          return _Message(text: l.commonErrorGeneric);
        }
        final items = snap.data ?? const [];
        if (items.isEmpty) {
          return _Message(text: l.supportFaqEmpty);
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          itemCount: items.length,
          itemBuilder: (context, i) {
            final f = items[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.surface1,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderSoft),
              ),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  iconColor: AppColors.copperLight,
                  collapsedIconColor: AppColors.ivoryFaint,
                  title: Text(f.question,
                      style: AppTextStyles.body(size: 14)),
                  subtitle: (f.category?.isNotEmpty ?? false)
                      ? Text(f.category!,
                          style: AppTextStyles.label(
                              size: 11, color: AppColors.ivoryDim))
                      : null,
                  childrenPadding:
                      const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  expandedAlignment: Alignment.centerLeft,
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(f.answer,
                        style: AppTextStyles.body(
                            size: 13, color: AppColors.ivoryDim)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ── Tickets tab ──────────────────────────────────────────────────────
class _TicketsTab extends StatefulWidget {
  const _TicketsTab({required this.repo});
  final SupportRepository repo;

  @override
  State<_TicketsTab> createState() => _TicketsTabState();
}

class _TicketsTabState extends State<_TicketsTab> {
  late Future<List<SupportTicket>> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _future = widget.repo.myTickets();
  }

  Future<void> _refresh() async {
    setState(_reload);
    await _future;
  }

  Future<void> _raise() async {
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.indigoDeep,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _RaiseTicketSheet(repo: widget.repo),
    );
    if (created == true && mounted) setState(_reload);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.saffron,
        foregroundColor: AppColors.indigoDeep,
        onPressed: _raise,
        icon: const Icon(Icons.add),
        label: Text(l.supportRaiseTicket),
      ),
      body: RefreshIndicator(
        color: AppColors.saffron,
        onRefresh: _refresh,
        child: FutureBuilder<List<SupportTicket>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.saffron),
              );
            }
            final items = snap.data ?? const [];
            if (items.isEmpty) {
              return _Message(text: l.supportTicketsEmpty);
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              itemCount: items.length,
              itemBuilder: (context, i) =>
                  _TicketTile(ticket: items[i], onReturn: _refresh),
            );
          },
        ),
      ),
    );
  }
}

class _TicketTile extends StatelessWidget {
  const _TicketTile({required this.ticket, required this.onReturn});
  final SupportTicket ticket;
  final Future<void> Function() onReturn;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: ListTile(
        title: Text(ticket.subject,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body(size: 14)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: _StatusChip(status: ticket.status),
        ),
        trailing: Icon(Icons.chevron_right, color: AppColors.ivoryFaint),
        onTap: () async {
          await context.push('/support/tickets/${ticket.id}');
          await onReturn();
        },
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final (label, color) = switch (status) {
      'closed' => (l.supportStatusClosed, AppColors.ivoryDim),
      'pending' => (l.supportStatusPending, AppColors.saffronBright),
      _ => (l.supportStatusOpen, AppColors.copperLight),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label,
          style: AppTextStyles.label(size: 11, color: color)),
    );
  }
}

class _RaiseTicketSheet extends StatefulWidget {
  const _RaiseTicketSheet({required this.repo});
  final SupportRepository repo;

  @override
  State<_RaiseTicketSheet> createState() => _RaiseTicketSheetState();
}

class _RaiseTicketSheetState extends State<_RaiseTicketSheet> {
  final _subject = TextEditingController();
  final _body = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _subject.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (_subject.text.trim().length < 2 || _body.text.trim().isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(l.supportFillFields)));
      return;
    }
    setState(() => _submitting = true);
    try {
      await widget.repo
          .createTicket(subject: _subject.text.trim(), body: _body.text.trim());
      if (!mounted) return;
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      setState(() => _submitting = false);
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.commonErrorGeneric)));
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.supportRaiseTicket, style: AppTextStyles.heading(size: 16)),
          const SizedBox(height: 16),
          TextField(
            controller: _subject,
            style: AppTextStyles.body(size: 14),
            decoration: InputDecoration(labelText: l.supportSubject),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _body,
            style: AppTextStyles.body(size: 14),
            minLines: 3,
            maxLines: 6,
            decoration: InputDecoration(labelText: l.supportMessage),
          ),
          const SizedBox(height: 16),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.saffron,
              foregroundColor: AppColors.indigoDeep,
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l.supportSubmit),
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
          child: Text(text,
              textAlign: TextAlign.center,
              style: AppTextStyles.body(size: 14, color: AppColors.ivoryDim)),
        ),
      ],
    );
  }
}
