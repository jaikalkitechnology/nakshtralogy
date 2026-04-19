import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../bloc/profile/profile_event.dart';
import '../../bloc/profile/profile_state.dart';
import '../../bloc/astrologer/astrologer_bloc.dart';
import '../../bloc/astrologer/astrologer_event.dart';
import '../../bloc/astrologer/astrologer_state.dart';
import '../../widgets/astrologer_profile_sheet.dart';
import '../communication/call_history_screen.dart';
import '../communication/chat_history_screen.dart';
import '../../widgets/language_selector.dart';

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
      context.read<ProfileBloc>().add(ProfileLoadRequested());
      context.read<AstrologerBloc>().add(AstrologerSavedLoadRequested());
    });
  }

  void _openEditDialog(Map<String, dynamic> me) {
    final nameCtrl = TextEditingController(text: me['name'] ?? '');
    final phoneCtrl = TextEditingController(text: me['phone'] ?? '');
    final dobCtrl = TextEditingController(text: me['dob'] ?? '');
    final tobCtrl = TextEditingController(text: me['tob'] ?? '');
    final placeCtrl = TextEditingController(text: me['birth_place'] ?? '');
    String gender = me['gender'] ?? '';

    showDialog(
      context: context,
      builder: (dctx) => BlocProvider.value(
        value: context.read<ProfileBloc>(),
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (ctx, state) {
            if (!state.saving && state.successMessage != null) {
              Navigator.pop(dctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.successMessage!), backgroundColor: AppColors.success),
              );
            }
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error!), backgroundColor: AppColors.error),
              );
            }
          },
          child: AlertDialog(
            backgroundColor: AppColors.card,
            title: Text(l.editProfile, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16)),
            content: SingleChildScrollView(
              child: StatefulBuilder(
                builder: (ctx, setSt) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(labelText: 'Full Name'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(labelText: 'Phone'),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: gender.isEmpty ? null : gender,
                      decoration: const InputDecoration(labelText: 'Gender'),
                      dropdownColor: AppColors.card,
                      style: const TextStyle(color: AppColors.textPrimary),
                      items: const [
                        DropdownMenuItem(value: 'male', child: Text('Male')),
                        DropdownMenuItem(value: 'female', child: Text('Female')),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (v) => setSt(() => gender = v ?? ''),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: dobCtrl,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(labelText: 'DOB (DD/MM/YYYY)'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: tobCtrl,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(labelText: 'TOB (HH:MM)'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: placeCtrl,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(labelText: 'Birth Place'),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(dctx), child: const Text('Cancel')),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (ctx, state) => ElevatedButton(
                  onPressed: state.saving
                      ? null
                      : () {
                          context.read<ProfileBloc>().add(ProfileUpdateRequested({
                                'name': nameCtrl.text,
                                'phone': phoneCtrl.text.isEmpty ? null : phoneCtrl.text,
                                'gender': gender.isEmpty ? null : gender,
                                'dob': dobCtrl.text.isEmpty ? null : dobCtrl.text,
                                'tob': tobCtrl.text.isEmpty ? null : tobCtrl.text,
                                'birth_place': placeCtrl.text.isEmpty ? null : placeCtrl.text,
                              }));
                        },
                  child: state.saving
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profState) {
        final me = profState.me;
        if (profState.loading && me == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            context.read<ProfileBloc>().add(ProfileLoadRequested());
            context.read<AstrologerBloc>().add(AstrologerSavedLoadRequested());
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.surface,
                      backgroundImage: me?['avatar_url'] != null ? NetworkImage(me!['avatar_url'] as String) : null,
                      child: me?['avatar_url'] == null
                          ? const Text('🧑', style: TextStyle(fontSize: 32))
                          : null,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      me?['name'] ?? '—',
                      style: const TextStyle(
                          color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    if (me?['email'] != null)
                      Text(me!['email'] as String,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                    if (me?['phone'] != null)
                      Text(me!['phone'] as String,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: me == null ? null : () => _openEditDialog(me),
                      icon: const Icon(Icons.edit, size: 14),
                      label: Text(l.editProfile),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(120, 36),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Birth details
              if (me != null) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.birthDetails,
                          style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      _detailRow('Gender', (me['gender'] as String?) ?? '—'),
                      _detailRow('Date of Birth', (me['dob'] as String?) ?? '—'),
                      _detailRow('Time of Birth', (me['tob'] as String?) ?? '—'),
                      _detailRow('Birth Place', (me['birth_place'] as String?) ?? '—'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Saved astrologers
              BlocBuilder<AstrologerBloc, AstrologerState>(
                builder: (context, aState) {
                  final saved = aState.saved;
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.bookmark, color: AppColors.primary, size: 14),
                            const SizedBox(width: 6),
                            Text('${l.savedAstrologers} (${saved.length})',
                                style: const TextStyle(
                                    color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (saved.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(l.noSavedAstrologers,
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                            ),
                          )
                        else
                          ...saved.map((a) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: InkWell(
                                  onTap: () => showAstrologerProfileSheet(context, a['id'] as String),
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 18,
                                          backgroundColor: AppColors.card,
                                          backgroundImage: a['profile_image_url'] != null
                                              ? NetworkImage(a['profile_image_url'] as String)
                                              : null,
                                          child: a['profile_image_url'] == null
                                              ? const Text('🔮', style: TextStyle(fontSize: 14))
                                              : null,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                a['display_name'] ?? '—',
                                                style: const TextStyle(
                                                    color: AppColors.textPrimary,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              Text(
                                                '₹${(a['rate_per_min_chat'] as num?)?.toInt() ?? 0}/m · ⭐ ${((a['rating'] as num?)?.toDouble() ?? 0).toStringAsFixed(1)}',
                                                style: const TextStyle(
                                                    color: AppColors.textSecondary, fontSize: 9),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.favorite, color: AppColors.error, size: 18),
                                          onPressed: () {
                                            context
                                                .read<AstrologerBloc>()
                                                .add(AstrologerToggleSave(a['id'] as String));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // My Orders
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 14),
                        const SizedBox(width: 6),
                        Text('${l.myOrders} (${profState.ordersTotal})',
                            style: const TextStyle(
                                color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (profState.orders.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('No orders yet',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                        ),
                      )
                    else
                      ...profState.orders.map((o) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Text(o['icon'] ?? '📜', style: const TextStyle(fontSize: 22)),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          o['service_name'] ?? '—',
                                          style: const TextStyle(
                                              color: AppColors.textPrimary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          (o['created_at'] as String?)?.substring(0, 10) ?? '',
                                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 9),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        (o['amount_paid'] as num?) != null && (o['amount_paid'] as num) > 0
                                            ? '₹${(o['amount_paid'] as num).toInt()}'
                                            : 'FREE',
                                        style: const TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.success.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          o['status'] ?? '',
                                          style: const TextStyle(
                                              color: AppColors.success,
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Language Selector
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => LanguageSelector.show(context),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.gold.withOpacity(0.15)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.language, color: AppColors.gold, size: 22),
                    const SizedBox(width: 12),
                    const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Language / \u092d\u093e\u0937\u093e', style: TextStyle(color: AppColors.ivory, fontSize: 14, fontWeight: FontWeight.w600)),
                      Text('Tap to change app language', style: TextStyle(color: AppColors.smoke, fontSize: 11)),
                    ])),
                    const Icon(Icons.chevron_right, color: AppColors.gold, size: 20),
                  ]),
                ),
              ),
              const SizedBox(height: 20),

              // Communication History
              Row(children: [
                const Icon(Icons.history, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(l.communicationHistory,
                    style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _historyTile(Icons.call, l.callHistory, AppColors.success, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CallHistoryScreen()));
                })),
                const SizedBox(width: 10),
                Expanded(child: _historyTile(Icons.chat_bubble_outline, l.chatHistory, AppColors.accent, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatHistoryScreen()));
                })),
              ]),
              const SizedBox(height: 20),

              // Logout
              OutlinedButton.icon(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthLogoutRequested());
                },
                icon: const Icon(Icons.logout, color: AppColors.error),
                label: Text(l.logout, style: const TextStyle(color: AppColors.error)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.error)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _historyTile(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
