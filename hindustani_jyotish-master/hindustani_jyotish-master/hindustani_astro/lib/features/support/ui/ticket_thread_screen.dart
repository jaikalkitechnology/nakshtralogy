import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/responsive.dart';
import '../support_repository.dart';

/// A single support ticket thread: the message history plus a reply box.
/// Replying on a closed ticket re-opens it (backend behaviour).
class TicketThreadScreen extends StatefulWidget {
  const TicketThreadScreen({super.key, required this.ticketId});
  final String ticketId;

  @override
  State<TicketThreadScreen> createState() => _TicketThreadScreenState();
}

class _TicketThreadScreenState extends State<TicketThreadScreen> {
  final _repo = getIt<SupportRepository>();
  final _reply = TextEditingController();
  SupportTicket? _ticket;
  bool _loading = true;
  bool _sending = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _reply.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final t = await _repo.ticket(widget.ticketId);
      if (!mounted) return;
      setState(() {
        _ticket = t;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e is ApiException ? e.message : '$e';
      });
    }
  }

  Future<void> _send() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final text = _reply.text.trim();
    if (text.isEmpty) return;
    setState(() => _sending = true);
    try {
      await _repo.reply(widget.ticketId, text);
      _reply.clear();
      await _load();
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.commonErrorGeneric)));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = _ticket;
    final closed = t?.status == 'closed';
    return Scaffold(
      appBar: AppBar(
        title: Text(t?.subject ?? l.supportTicket,
            maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: SafeArea(
        child: CenteredMaxWidth(
          maxWidth: 720,
          child: Column(
            children: [
              Expanded(child: _thread(l)),
              if (t != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _reply,
                          enabled: !_sending,
                          minLines: 1,
                          maxLines: 4,
                          style: AppTextStyles.body(size: 14),
                          decoration: InputDecoration(
                            hintText: closed
                                ? l.supportReopenHint
                                : l.supportReplyHint,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.saffron,
                          foregroundColor: AppColors.indigoDeep,
                        ),
                        onPressed: _sending ? null : _send,
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _thread(AppLocalizations l) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.saffron),
      );
    }
    if (_error != null || _ticket == null) {
      return Center(
        child: Text(_error ?? l.commonErrorGeneric,
            style: AppTextStyles.body(size: 14, color: AppColors.ivoryDim)),
      );
    }
    final msgs = _ticket!.messages;
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      itemCount: msgs.length,
      itemBuilder: (context, i) => _Bubble(message: msgs[i]),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});
  final TicketMessage message;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final mine = message.isMine;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: mine ? AppColors.copperGlow : AppColors.surface1,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Column(
          crossAxisAlignment:
              mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(mine ? l.supportSenderYou : l.supportSenderSupport,
                style: AppTextStyles.label(size: 10, color: AppColors.ivoryDim)),
            const SizedBox(height: 4),
            Text(message.body, style: AppTextStyles.body(size: 14)),
          ],
        ),
      ),
    );
  }
}
