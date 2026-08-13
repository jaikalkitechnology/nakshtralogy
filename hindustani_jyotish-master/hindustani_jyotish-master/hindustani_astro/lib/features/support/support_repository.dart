import 'package:hj_core/hj_core.dart';

/// One admin-managed FAQ entry, already localized by the backend for the
/// requested language (`GET /public/faqs/user?lang=`).
class FaqItem {
  FaqItem({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
  });

  final String id;
  final String? category;
  final String question;
  final String answer;

  factory FaqItem.fromJson(Map<String, dynamic> j) => FaqItem(
        id: j['id'] as String,
        category: j['category'] as String?,
        question: (j['question'] ?? '') as String,
        answer: (j['answer'] ?? '') as String,
      );
}

/// One message in a support ticket thread.
class TicketMessage {
  TicketMessage({
    required this.id,
    required this.sender,
    required this.body,
    this.createdAt,
  });

  final String id;
  final String sender; // user | astrologer | admin
  final String body;
  final DateTime? createdAt;

  bool get isMine => sender != 'admin';

  factory TicketMessage.fromJson(Map<String, dynamic> j) => TicketMessage(
        id: j['id'] as String,
        sender: (j['sender'] ?? 'user') as String,
        body: (j['body'] ?? '') as String,
        createdAt: j['created_at'] != null
            ? DateTime.tryParse(j['created_at'] as String)
            : null,
      );
}

/// A support ticket, optionally with its full message thread.
class SupportTicket {
  SupportTicket({
    required this.id,
    required this.subject,
    required this.status,
    this.updatedAt,
    this.messages = const [],
  });

  final String id;
  final String subject;
  final String status; // open | pending | closed
  final DateTime? updatedAt;
  final List<TicketMessage> messages;

  factory SupportTicket.fromJson(Map<String, dynamic> j) => SupportTicket(
        id: j['id'] as String,
        subject: (j['subject'] ?? '') as String,
        status: (j['status'] ?? 'open') as String,
        updatedAt: j['updated_at'] != null
            ? DateTime.tryParse(j['updated_at'] as String)
            : null,
        messages: ((j['messages'] as List?) ?? const [])
            .map((e) => TicketMessage.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

/// Help & Support data: public FAQ (per app, localized) + the caller's own
/// support tickets. The caller's role is resolved from the token, so the same
/// repository shape serves both apps — the astro app requests the astro FAQ feed.
class SupportRepository {
  SupportRepository(this._api, {this.app = 'astro'});
  final ApiClient _api;
  final String app;

  Future<List<FaqItem>> faqs({String lang = 'en'}) async {
    final res = await _api.get('/public/faqs/$app', query: {'lang': lang});
    final items = (res as Map<String, dynamic>)['items'] as List? ?? const [];
    return items
        .map((e) => FaqItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<SupportTicket>> myTickets() async {
    final res = await _api.get('/support/tickets');
    final items = (res as Map<String, dynamic>)['items'] as List? ?? const [];
    return items
        .map((e) => SupportTicket.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<SupportTicket> ticket(String id) async {
    final res = await _api.get('/support/tickets/$id');
    return SupportTicket.fromJson(res as Map<String, dynamic>);
  }

  Future<SupportTicket> createTicket({
    required String subject,
    required String body,
  }) async {
    final res = await _api.post(
      '/support/tickets',
      body: {'subject': subject, 'body': body},
    );
    return SupportTicket.fromJson(res as Map<String, dynamic>);
  }

  Future<void> reply(String ticketId, String body) =>
      _api.post('/support/tickets/$ticketId/reply', body: {'body': body});
}
