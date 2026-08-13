import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

import '../../l10n/app_localizations.dart';

/// Astrologer card with two layouts:
///
/// * Compact row (default) — used on the home feed. No action buttons.
/// * Rich vertical card — used in the discovery grid. Shows languages, all
///   rates and Chat/Call/Video actions. Activated by passing any of
///   [onChat]/[onCall]/[onVideo].
class AstrologerCard extends StatelessWidget {
  const AstrologerCard({
    super.key,
    required this.astrologer,
    this.onTap,
    this.onChat,
    this.onCall,
    this.onVideo,
  });

  final Astrologer astrologer;
  final VoidCallback? onTap;
  final VoidCallback? onChat;
  final VoidCallback? onCall;
  final VoidCallback? onVideo;

  bool get _hasActions => onChat != null || onCall != null || onVideo != null;

  @override
  Widget build(BuildContext context) {
    return _hasActions ? _buildGridCard(context) : _buildCompact(context);
  }

  // ---- Rich vertical card (discovery grid) --------------------------------
  Widget _buildGridCard(BuildContext context) {
    final l = AppLocalizations.of(context);
    final a = astrologer;
    final skills = a.skills.isEmpty ? 'Vedic' : a.skills.take(2).join(' · ');
    final languages = a.languages.isEmpty
        ? '—'
        : a.languages.take(3).join(', ');
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.surface2, AppColors.surface1],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSoft),
          boxShadow: const [
            BoxShadow(color: AppColors.shadowSoft, blurRadius: 14, offset: Offset(0, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _Avatar(url: a.photoUrl, online: a.isOnline, live: a.isLive),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a.displayName ?? l.cardAstrologer,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body(
                          size: 15,
                          weight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        skills,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.label(
                          size: 12,
                          color: AppColors.ivoryDim,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 13,
                            color: AppColors.gold,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            a.avgRating,
                            style: AppTextStyles.mono(
                              size: 11,
                              color: AppColors.gold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              l.cardYearsExp(a.yearsExperience),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.label(
                                size: 11,
                                color: AppColors.ivoryFaint,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _OnlineBadge(online: a.isOnline, l: l),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.translate,
                  size: 13,
                  color: AppColors.ivoryFaint,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    languages,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label(
                      size: 11,
                      color: AppColors.ivoryDim,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _RatePill(
                  icon: Icons.chat_bubble_outline,
                  text: l.cardRatePerMsg(a.rateChatPerMsg),
                ),
                _RatePill(icon: Icons.call, text: l.cardRatePerMin(a.rateCallPerMin)),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                _ActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: l.cardChat,
                  onTap: onChat,
                ),
                const SizedBox(width: 8),
                _ActionButton(icon: Icons.call, label: l.cardCall, onTap: onCall),
                const SizedBox(width: 8),
                _ActionButton(
                  icon: Icons.videocam_outlined,
                  label: l.cardVideo,
                  onTap: onVideo,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---- Compact row card (home feed) ---------------------------------------
  Widget _buildCompact(BuildContext context) {
    final l = AppLocalizations.of(context);
    final a = astrologer;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.surface2, AppColors.surface1],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSoft),
          boxShadow: const [
            BoxShadow(color: AppColors.shadowSoft, blurRadius: 14, offset: Offset(0, 6)),
          ],
        ),
        child: Row(
          children: [
            _Avatar(url: a.photoUrl, online: a.isOnline, live: a.isLive),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.displayName ?? l.cardAstrologer,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body(
                      size: 15,
                      weight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    a.skills.isEmpty ? 'Vedic' : a.skills.take(2).join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label(
                      size: 12,
                      color: AppColors.ivoryDim,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 13, color: AppColors.gold),
                      const SizedBox(width: 3),
                      Text(
                        a.avgRating,
                        style: AppTextStyles.mono(
                          size: 11,
                          color: AppColors.gold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          l.cardYears(a.yearsExperience),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.label(
                            size: 11,
                            color: AppColors.ivoryFaint,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  l.cardRatePerMin(a.rateCallPerMin),
                  style: AppTextStyles.body(
                    size: 13,
                    weight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: a.isOnline
                        ? const LinearGradient(colors: AppColors.saffronGradient)
                        : null,
                    color: a.isOnline ? null : AppColors.surface2,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: a.isOnline
                        ? const [
                            BoxShadow(
                              color: AppColors.saffronHalo,
                              blurRadius: 12,
                              spreadRadius: -2,
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    a.isOnline ? l.cardConsult : l.commonOffline,
                    style: AppTextStyles.label(
                      size: 12,
                      weight: FontWeight.w700,
                      color: a.isOnline
                          ? const Color(0xFF1A1102)
                          : AppColors.ivoryFaint,
                    ),
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

class _RatePill extends StatelessWidget {
  const _RatePill({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.success),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.mono(size: 11, color: AppColors.success),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: AppColors.saffronGlow,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.saffron.withValues(alpha: 0.35),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 16, color: AppColors.saffronBright),
              const SizedBox(height: 2),
              Text(
                label,
                style: AppTextStyles.label(
                  size: 10,
                  color: AppColors.saffronBright,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnlineBadge extends StatelessWidget {
  const _OnlineBadge({required this.online, required this.l});
  final bool online;
  final AppLocalizations l;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (online ? AppColors.success : AppColors.ivoryFaint).withValues(
          alpha: 0.16,
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        online ? l.commonOnline : l.commonOffline,
        style: AppTextStyles.label(
          size: 10,
          color: online ? AppColors.success : AppColors.ivoryFaint,
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.url, required this.online, required this.live});
  final String? url;
  final bool online;
  final bool live;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: live ? AppColors.live : AppColors.borderMid,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: live
                    ? AppColors.live.withValues(alpha: 0.4)
                    : AppColors.copperGlow,
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: url == null
              ? ColoredBox(
                  color: AppColors.indigoMid,
                  child: Icon(Icons.person, color: AppColors.copperLight),
                )
              : CachedNetworkImage(
                  imageUrl: url!,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) =>
                      const Icon(Icons.person, color: AppColors.copperLight),
                ),
        ),
        if (online)
          Positioned(
            right: 1,
            bottom: 1,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.indigoVoid, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
