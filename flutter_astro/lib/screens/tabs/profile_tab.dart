import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/astro_profile/astro_profile_bloc.dart';
import '../../bloc/astro_profile/astro_profile_event.dart';
import '../../bloc/astro_profile/astro_profile_state.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});
  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AstroProfileBloc>().add(AstroProfileLoadRequested());
    });
  }

  void _showEditDialog(Map<String, dynamic> me) {
    final profile = (me['profile'] ?? me['astrologer_profile'] ?? {}) as Map<String, dynamic>;
    final nameCtrl = TextEditingController(text: me['name'] ?? '');
    final phoneCtrl = TextEditingController(text: me['phone'] ?? '');
    final displayCtrl = TextEditingController(text: profile['display_name'] ?? '');
    final bioCtrl = TextEditingController(text: profile['bio'] ?? '');
    final expCtrl = TextEditingController(text: '${profile['experience_years'] ?? ''}');
    final langCtrl = TextEditingController(text: (profile['languages'] as List?)?.join(', ') ?? '');
    final specCtrl = TextEditingController(text: (profile['specializations'] as List?)?.join(', ') ?? '');
    final qualCtrl = TextEditingController(text: profile['qualification'] ?? '');
    final imgCtrl = TextEditingController(text: profile['profile_image_url'] ?? '');
    final chatMinCtrl = TextEditingController(text: '${profile['rate_per_min_chat'] ?? ''}');
    final callMinCtrl = TextEditingController(text: '${profile['rate_per_min_call'] ?? ''}');
    final videoMinCtrl = TextEditingController(text: '${profile['rate_per_min_video'] ?? ''}');
    final chatSessCtrl = TextEditingController(text: '${profile['rate_per_session_chat'] ?? ''}');
    final callSessCtrl = TextEditingController(text: '${profile['rate_per_session_call'] ?? ''}');
    final videoSessCtrl = TextEditingController(text: '${profile['rate_per_session_video'] ?? ''}');
    final msgLimitCtrl = TextEditingController(text: '${profile['session_message_limit'] ?? 45}');
    final validityCtrl = TextEditingController(text: '${profile['session_validity_hours'] ?? 24}');
    final perMsgCtrl = TextEditingController(text: '${profile['rate_per_msg_chat'] ?? ''}');
    final superChatCtrl = TextEditingController(text: '${profile['super_chat_rate'] ?? 50}');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Edit Profile', style: TextStyle(color: AppColors.primary)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
            _field(nameCtrl, 'Full Name', Icons.person),
            _field(phoneCtrl, 'Phone', Icons.phone),
            _field(displayCtrl, 'Display Name', Icons.badge),
            _field(bioCtrl, 'Bio', Icons.description, maxLines: 3),
            _field(expCtrl, 'Experience (years)', Icons.work_history, isNum: true),
            _field(langCtrl, 'Languages (comma separated)', Icons.language),
            _field(specCtrl, 'Specializations (comma separated)', Icons.auto_awesome),
            _field(qualCtrl, 'Qualification', Icons.school),
            _field(imgCtrl, 'Profile Image URL', Icons.image),
            const Divider(color: AppColors.border, height: 28),
            const Align(alignment: Alignment.centerLeft, child: Text('Per-Minute Rates', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600))),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _field(chatMinCtrl, 'Chat ₹/min', Icons.chat, isNum: true)),
              const SizedBox(width: 8),
              Expanded(child: _field(callMinCtrl, 'Call ₹/min', Icons.phone, isNum: true)),
              const SizedBox(width: 8),
              Expanded(child: _field(videoMinCtrl, 'Video ₹/min', Icons.videocam, isNum: true)),
            ]),
            const SizedBox(height: 12),
            const Align(alignment: Alignment.centerLeft, child: Text('Per-Session Rates', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600))),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _field(chatSessCtrl, 'Chat ₹/sess', Icons.chat, isNum: true)),
              const SizedBox(width: 8),
              Expanded(child: _field(callSessCtrl, 'Call ₹/sess', Icons.phone, isNum: true)),
              const SizedBox(width: 8),
              Expanded(child: _field(videoSessCtrl, 'Video ₹/sess', Icons.videocam, isNum: true)),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _field(msgLimitCtrl, 'Msg Limit/Session', Icons.message, isNum: true)),
              const SizedBox(width: 8),
              Expanded(child: _field(validityCtrl, 'Validity (hrs)', Icons.timer, isNum: true)),
            ]),
            const Divider(color: AppColors.border, height: 28),
            const Align(alignment: Alignment.centerLeft, child: Text('Per-Message & Super Chat', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600))),
            const SizedBox(height: 4),
            const Text('Per-message charges each user message individually', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _field(perMsgCtrl, 'Chat ₹/message', Icons.message, isNum: true)),
              const SizedBox(width: 8),
              Expanded(child: _field(superChatCtrl, 'Super Chat min ₹', Icons.attach_money, isNum: true)),
            ]),
          ])),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
          BlocBuilder<AstroProfileBloc, AstroProfileState>(builder: (context, state) {
            return ElevatedButton(
              onPressed: state.saving ? null : () {
                final userFields = <String, dynamic>{};
                if (nameCtrl.text.trim().isNotEmpty) userFields['name'] = nameCtrl.text.trim();
                if (phoneCtrl.text.trim().isNotEmpty) userFields['phone'] = phoneCtrl.text.trim();

                final pf = <String, dynamic>{};
                if (displayCtrl.text.trim().isNotEmpty) pf['display_name'] = displayCtrl.text.trim();
                if (bioCtrl.text.trim().isNotEmpty) pf['bio'] = bioCtrl.text.trim();
                if (expCtrl.text.trim().isNotEmpty) pf['experience_years'] = int.tryParse(expCtrl.text.trim());
                if (langCtrl.text.trim().isNotEmpty) pf['languages'] = langCtrl.text.trim().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                if (specCtrl.text.trim().isNotEmpty) pf['specializations'] = specCtrl.text.trim().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                if (qualCtrl.text.trim().isNotEmpty) pf['qualification'] = qualCtrl.text.trim();
                if (imgCtrl.text.trim().isNotEmpty) pf['profile_image_url'] = imgCtrl.text.trim();
                if (chatMinCtrl.text.trim().isNotEmpty) pf['rate_per_min_chat'] = double.tryParse(chatMinCtrl.text.trim());
                if (callMinCtrl.text.trim().isNotEmpty) pf['rate_per_min_call'] = double.tryParse(callMinCtrl.text.trim());
                if (videoMinCtrl.text.trim().isNotEmpty) pf['rate_per_min_video'] = double.tryParse(videoMinCtrl.text.trim());
                if (chatSessCtrl.text.trim().isNotEmpty) pf['rate_per_session_chat'] = double.tryParse(chatSessCtrl.text.trim());
                if (callSessCtrl.text.trim().isNotEmpty) pf['rate_per_session_call'] = double.tryParse(callSessCtrl.text.trim());
                if (videoSessCtrl.text.trim().isNotEmpty) pf['rate_per_session_video'] = double.tryParse(videoSessCtrl.text.trim());
                if (msgLimitCtrl.text.trim().isNotEmpty) pf['session_message_limit'] = int.tryParse(msgLimitCtrl.text.trim());
                if (validityCtrl.text.trim().isNotEmpty) pf['session_validity_hours'] = int.tryParse(validityCtrl.text.trim());
                if (perMsgCtrl.text.trim().isNotEmpty) pf['rate_per_msg_chat'] = double.tryParse(perMsgCtrl.text.trim());
                if (superChatCtrl.text.trim().isNotEmpty) pf['super_chat_rate'] = double.tryParse(superChatCtrl.text.trim());

                context.read<AstroProfileBloc>().add(AstroProfileUpdateRequested(userFields: userFields, profileFields: pf));
                Navigator.pop(ctx);
              },
              child: state.saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save'),
            );
          }),
        ],
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon, {bool isNum = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        keyboardType: isNum ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 20), isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AstroProfileBloc, AstroProfileState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage!), backgroundColor: AppColors.success));
        }
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error!), backgroundColor: AppColors.error));
        }
      },
      builder: (context, state) {
        if (state.loading && state.me == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        final me = state.me ?? {};
        final profile = (me['profile'] ?? me['astrologer_profile'] ?? <String, dynamic>{}) as Map<String, dynamic>;
        final name = me['name'] ?? '';
        final email = me['email'] ?? '';
        final phone = me['phone'] ?? '';
        final displayName = profile['display_name'] ?? name;
        final bio = profile['bio'] ?? '';
        final exp = profile['experience_years'];
        final langs = (profile['languages'] as List?)?.join(', ') ?? '';
        final specs = (profile['specializations'] as List?)?.join(', ') ?? '';
        final qual = profile['qualification'] ?? '';
        final rating = profile['rating'] ?? 0.0;
        final totalReviews = profile['total_reviews'] ?? 0;
        final imgUrl = profile['profile_image_url'] ?? '';

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => context.read<AstroProfileBloc>().add(AstroProfileLoadRequested()),
          child: ListView(padding: const EdgeInsets.all(16), children: [
            // ── Profile Header ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: Column(children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  backgroundImage: imgUrl.isNotEmpty ? NetworkImage(imgUrl) : null,
                  child: imgUrl.isEmpty ? Text(name.isNotEmpty ? name[0].toUpperCase() : 'A', style: const TextStyle(fontSize: 32, color: AppColors.primary, fontWeight: FontWeight.bold)) : null,
                ),
                const SizedBox(height: 12),
                Text(displayName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                if (bio.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(bio, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13), textAlign: TextAlign.center),
                ],
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text('${(rating as num).toStringAsFixed(1)} ($totalReviews reviews)', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ]),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  onPressed: () => _showEditDialog(me),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(200, 42)),
                ),
              ]),
            ),
            const SizedBox(height: 16),

            // ── Details ──
            _DetailSection(items: [
              _DetailItem(icon: Icons.email, label: 'Email', value: email),
              _DetailItem(icon: Icons.phone, label: 'Phone', value: phone.isNotEmpty ? phone : 'Not set'),
              _DetailItem(icon: Icons.work_history, label: 'Experience', value: exp != null ? '$exp years' : 'Not set'),
              _DetailItem(icon: Icons.language, label: 'Languages', value: langs.isNotEmpty ? langs : 'Not set'),
              _DetailItem(icon: Icons.auto_awesome, label: 'Specializations', value: specs.isNotEmpty ? specs : 'Not set'),
              _DetailItem(icon: Icons.school, label: 'Qualification', value: qual.isNotEmpty ? qual : 'Not set'),
            ]),
            const SizedBox(height: 16),

            // ── Rates Card ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Rate Cards', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                const Text('Per-Minute', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(height: 6),
                Row(children: [
                  _RateChip(label: 'Chat', value: '₹${profile['rate_per_min_chat'] ?? 0}/min', color: AppColors.accent),
                  const SizedBox(width: 8),
                  _RateChip(label: 'Call', value: '₹${profile['rate_per_min_call'] ?? 0}/min', color: AppColors.success),
                  const SizedBox(width: 8),
                  _RateChip(label: 'Video', value: '₹${profile['rate_per_min_video'] ?? 0}/min', color: AppColors.primary),
                ]),
                const SizedBox(height: 12),
                const Text('Per-Session', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(height: 6),
                Row(children: [
                  _RateChip(label: 'Chat', value: '₹${profile['rate_per_session_chat'] ?? 0}', color: AppColors.accent),
                  const SizedBox(width: 8),
                  _RateChip(label: 'Call', value: '₹${profile['rate_per_session_call'] ?? 0}', color: AppColors.success),
                  const SizedBox(width: 8),
                  _RateChip(label: 'Video', value: '₹${profile['rate_per_session_video'] ?? 0}', color: AppColors.primary),
                ]),
                const SizedBox(height: 10),
                Text('Session: ${profile['session_message_limit'] ?? 45} msgs, ${profile['session_validity_hours'] ?? 24}hr validity',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                if ((profile['rate_per_msg_chat'] ?? 0) > 0 || (profile['super_chat_rate'] ?? 0) > 0) ...[
                  const SizedBox(height: 12),
                  const Text('Other Charges', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 6),
                  Row(children: [
                    if ((profile['rate_per_msg_chat'] ?? 0) > 0)
                      _RateChip(label: 'Per-Msg', value: '₹${profile['rate_per_msg_chat']}/msg', color: Colors.orange),
                    if ((profile['rate_per_msg_chat'] ?? 0) > 0) const SizedBox(width: 8),
                    _RateChip(label: 'Super Chat', value: '₹${profile['super_chat_rate'] ?? 50} min', color: Colors.amber),
                  ]),
                ],
              ]),
            ),
            const SizedBox(height: 20),

            // ── Logout ──
            OutlinedButton.icon(
              onPressed: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error)),
            ),
            const SizedBox(height: 20),
          ]),
        );
      },
    );
  }
}

class _DetailSection extends StatelessWidget {
  final List<_DetailItem> items;
  const _DetailSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(children: items.map((item) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Icon(item.icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Text('${item.label}:', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(width: 8),
          Expanded(child: Text(item.value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13), textAlign: TextAlign.end)),
        ]),
      )).toList()),
    );
  }
}

class _DetailItem {
  final IconData icon;
  final String label;
  final String value;
  const _DetailItem({required this.icon, required this.label, required this.value});
}

class _RateChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _RateChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withOpacity(0.3))),
        child: Column(children: [
          Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}
